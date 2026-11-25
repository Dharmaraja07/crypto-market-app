package com.cryptomarket.service;

import com.cryptomarket.client.CoinGeckoRestClient;
import com.cryptomarket.dto.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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

        boolean isSearch = search != null && !search.trim().isEmpty();
        boolean isPriceOrChangeSort = isPriceOrChangeSort(sortBy);

        // If search filter is active or sorting by price/24h change (which CoinGecko /coins/markets does not support natively)
        if (isSearch || isPriceOrChangeSort) {
            List<CoinSummaryDto> allCoins = new ArrayList<>(client.fetchCoins(1, 250, "usd", "market_cap_desc"));

            List<CoinSummaryDto> list = allCoins;
            if (isSearch) {
                String q = search.toLowerCase().trim();
                list = list.stream()
                        .filter(c -> (c.getName() != null && c.getName().toLowerCase().contains(q)) ||
                                     (c.getSymbol() != null && c.getSymbol().toLowerCase().contains(q)))
                        .collect(Collectors.toList());
            }

            sortCoins(list, sortBy, order);

            int start = Math.max(0, (page - 1) * perPage);
            int end = Math.min(list.size(), start + perPage);
            return start >= list.size() ? List.of() : list.subList(start, end);
        }

        // --- DEFAULT PATH: delegate page + perPage + order directly to CoinGecko for market_cap / volume ---
        String cgOrder = buildCoinGeckoOrder(sortBy, order);
        return client.fetchCoins(page, perPage, "usd", cgOrder);
    }

    private boolean isPriceOrChangeSort(String sortBy) {
        if (sortBy == null) return false;
        String s = sortBy.toLowerCase();
        return s.equals("price") || s.equals("percentage_change") || s.equals("price_change_percentage_24h");
    }

    private void sortCoins(List<CoinSummaryDto> coins, String sortBy, String order) {
        Comparator<CoinSummaryDto> comparator = switch (sortBy != null ? sortBy.toLowerCase() : "market_cap") {
            case "price" -> Comparator.comparing(CoinSummaryDto::getCurrentPrice, Comparator.nullsLast(Double::compareTo));
            case "volume", "total_volume" -> Comparator.comparing(CoinSummaryDto::getTotalVolume, Comparator.nullsLast(Double::compareTo));
            case "percentage_change", "price_change_percentage_24h" -> Comparator.comparing(CoinSummaryDto::getPriceChangePercentage24h, Comparator.nullsLast(Double::compareTo));
            default -> Comparator.comparing(CoinSummaryDto::getMarketCapRank, Comparator.nullsLast(Integer::compareTo));
        };

        boolean isMarketCap = sortBy == null || "market_cap".equalsIgnoreCase(sortBy);
        boolean wantDesc = order == null || "desc".equalsIgnoreCase(order);

        // market_cap rank is inverse: rank 1 = highest cap, so for "desc" (highest cap first) keep ascending rank order;
        // for "asc" (lowest cap first) reverse to descending rank order.
        // For all other fields: "desc" = reverse natural ascending comparator, "asc" = keep it.
        if (isMarketCap ? !wantDesc : wantDesc) {
            comparator = comparator.reversed();
        }

        coins.sort(comparator);
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
