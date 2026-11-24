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
        // Fetch up to 100 coins
        List<CoinSummaryDto> coins = client.fetchCoins(1, 100, "usd", "market_cap_desc");

        // If search filter is specified
        if (search != null && !search.trim().isEmpty()) {
            String q = search.toLowerCase().trim();
            coins = coins.stream()
                    .filter(c -> c.getName().toLowerCase().contains(q) || c.getSymbol().toLowerCase().contains(q))
                    .collect(Collectors.toList());
        }

        // Apply sorting
        Comparator<CoinSummaryDto> comparator = switch (sortBy != null ? sortBy.toLowerCase() : "market_cap") {
            case "price" -> Comparator.comparing(CoinSummaryDto::getCurrentPrice, Comparator.nullsLast(Double::compareTo));
            case "volume", "total_volume" -> Comparator.comparing(CoinSummaryDto::getTotalVolume, Comparator.nullsLast(Double::compareTo));
            case "percentage_change", "price_change_percentage_24h" -> Comparator.comparing(CoinSummaryDto::getPriceChangePercentage24h, Comparator.nullsLast(Double::compareTo));
            default -> Comparator.comparing(CoinSummaryDto::getMarketCapRank, Comparator.nullsLast(Integer::compareTo));
        };

        boolean isDesc = order == null || "desc".equalsIgnoreCase(order);
        if ("market_cap".equalsIgnoreCase(sortBy != null ? sortBy : "market_cap")) {
            // Rank 1 is highest market cap, so asc rank is desc market cap
            if (!isDesc) {
                comparator = comparator.reversed();
            }
        } else {
            if (isDesc) {
                comparator = comparator.reversed();
            }
        }

        coins.sort(comparator);

        // Apply pagination
        int start = Math.max(0, (page - 1) * perPage);
        int end = Math.min(coins.size(), start + perPage);
        if (start >= coins.size()) {
            return List.of();
        }
        return coins.subList(start, end);
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

    public List<CoinSummaryDto> getTopGainers(int limit) {
        log.info("Fetching top gainers (limit={})", limit);
        List<CoinSummaryDto> coins = client.fetchCoins(1, 100, "usd", "market_cap_desc");
        return coins.stream()
                .filter(c -> c.getPriceChangePercentage24h() != null)
                .sorted(Comparator.comparing(CoinSummaryDto::getPriceChangePercentage24h).reversed())
                .limit(limit > 0 ? limit : 5)
                .collect(Collectors.toList());
    }

    public List<CoinSummaryDto> getTopLosers(int limit) {
        log.info("Fetching top losers (limit={})", limit);
        List<CoinSummaryDto> coins = client.fetchCoins(1, 100, "usd", "market_cap_desc");
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
