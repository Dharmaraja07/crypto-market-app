package com.cryptomarket.service;

import com.cryptomarket.client.CoinGeckoRestClient;
import com.cryptomarket.dto.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CoinService {

    private static final Logger log = LoggerFactory.getLogger(CoinService.class);
    private final CoinGeckoRestClient client;

    public CoinService(CoinGeckoRestClient client) {
        this.client = client;
    }

    @Cacheable(value = "coinList", key = "'p_' + #page + '_pp_' + #perPage + '_s_' + #sortBy + '_o_' + #order + '_q_' + #search")
    public List<CoinSummaryDto> getCoins(int page, int perPage, String sortBy, String order, String search) {
        log.info("Fetching coins: page={}, perPage={}, sortBy={}, order={}, search={}", page, perPage, sortBy, order, search);

        // --- SEARCH PATH: search is done server-side via CoinGecko search endpoint ---
        // We fetch a broad set for the filtered case, then paginate in memory.
        // For non-search, all pagination AND sorting is delegated directly to CoinGecko.
        if (search != null && !search.trim().isEmpty()) {
            // Search: fetch top 250 so we can sort + paginate filtered results accurately
            List<CoinSummaryDto> allCoins = client.fetchCoins(1, 250, "usd", buildCoinGeckoOrder(sortBy, order));
            String q = search.toLowerCase().trim();
            List<CoinSummaryDto> filtered = allCoins.stream()
                    .filter(c -> c.getName().toLowerCase().contains(q) || c.getSymbol().toLowerCase().contains(q))
                    .collect(Collectors.toList());
            int start = Math.max(0, (page - 1) * perPage);
            int end = Math.min(filtered.size(), start + perPage);
            return start >= filtered.size() ? List.of() : filtered.subList(start, end);
        }

        // --- DEFAULT PATH: delegate page + perPage + order directly to CoinGecko ---
        // This gives access to all 10,000+ coins correctly.
        String cgOrder = buildCoinGeckoOrder(sortBy, order);
        return client.fetchCoins(page, perPage, "usd", cgOrder);
    }

    /**
     * Maps our sortBy/order params to a CoinGecko `order` query string.
     * CoinGecko supports: market_cap_desc, market_cap_asc, volume_desc, volume_asc,
     * id_desc, id_asc, gecko_desc (trending rank).
     */
    private String buildCoinGeckoOrder(String sortBy, String order) {
        boolean desc = order == null || "desc".equalsIgnoreCase(order);
        String direction = desc ? "desc" : "asc";
        return switch (sortBy != null ? sortBy.toLowerCase() : "market_cap") {
            case "volume", "total_volume" -> "volume_" + direction;
            case "id"                     -> "id_" + direction;
            // CoinGecko doesn't support price sort natively — fall back to market_cap
            case "price", "percentage_change", "price_change_percentage_24h"
                                          -> "market_cap_" + direction;
            default                       -> "market_cap_" + direction;
        };
    }

    @Cacheable(value = "coinDetails", key = "#coinId")
    public CoinDetailDto getCoinDetail(String coinId) {
        log.info("Fetching coin details for: {}", coinId);
        return client.fetchCoinDetail(coinId);
    }

    @Cacheable(value = "coinCharts", key = "#coinId + '_' + #range")
    public ChartDataDto getCoinChart(String coinId, String range) {
        log.info("Fetching chart for coin: {}, range: {}", coinId, range);
        return client.fetchCoinChart(coinId, range != null ? range : "7d");
    }

    @Cacheable(value = "trendingCoins")
    public List<CoinSummaryDto> getTrendingCoins() {
        log.info("Fetching trending coins");
        return client.fetchTrendingCoins();
    }

    @Cacheable(value = "coinList", key = "'gainers_' + #limit")
    public List<CoinSummaryDto> getTopGainers(int limit) {
        log.info("Fetching top gainers (limit={})", limit);
        // Fetch top 250 by market cap — large enough pool to find meaningful movers
        List<CoinSummaryDto> coins = client.fetchCoins(1, 250, "usd", "market_cap_desc");
        return coins.stream()
                .filter(c -> c.getPriceChangePercentage24h() != null)
                .sorted(Comparator.comparing(CoinSummaryDto::getPriceChangePercentage24h).reversed())
                .limit(limit > 0 ? limit : 5)
                .collect(Collectors.toList());
    }

    @Cacheable(value = "coinList", key = "'losers_' + #limit")
    public List<CoinSummaryDto> getTopLosers(int limit) {
        log.info("Fetching top losers (limit={})", limit);
        List<CoinSummaryDto> coins = client.fetchCoins(1, 250, "usd", "market_cap_desc");
        return coins.stream()
                .filter(c -> c.getPriceChangePercentage24h() != null)
                .sorted(Comparator.comparing(CoinSummaryDto::getPriceChangePercentage24h))
                .limit(limit > 0 ? limit : 5)
                .collect(Collectors.toList());
    }

    @Cacheable(value = "searchCoins", key = "#query")
    public List<SearchResultDto> searchCoins(String query) {
        log.info("Searching coins for query: {}", query);
        if (query == null || query.trim().isEmpty()) {
            return List.of();
        }
        return client.searchCoins(query.trim());
    }
}
