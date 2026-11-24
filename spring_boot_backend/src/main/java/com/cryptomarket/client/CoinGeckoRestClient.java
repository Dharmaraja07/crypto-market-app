package com.cryptomarket.client;

import com.cryptomarket.dto.*;
import com.cryptomarket.service.MockCryptoDataService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.time.Instant;
import java.util.*;

@Component
public class CoinGeckoRestClient {

    private static final Logger log = LoggerFactory.getLogger(CoinGeckoRestClient.class);

    private final RestClient restClient;
    private final MockCryptoDataService mockService;

    @Value("${crypto.coingecko.mock-fallback-enabled:true}")
    private boolean mockFallbackEnabled;

    public CoinGeckoRestClient(@org.springframework.beans.factory.annotation.Qualifier("cgRestClient") RestClient restClient, MockCryptoDataService mockService) {
        this.restClient = restClient;
        this.mockService = mockService;
    }

    public MarketOverviewDto fetchGlobalOverview() {
        try {
            log.info("Fetching global market data from CoinGecko /global");
            Map<String, Object> response = restClient.get()
                    .uri("/global")
                    .retrieve()
                    .body(new ParameterizedTypeReference<Map<String, Object>>() {});

            if (response != null && response.containsKey("data")) {
                @SuppressWarnings("unchecked")
                Map<String, Object> data = (Map<String, Object>) response.get("data");
                return mapToMarketOverview(data);
            }
        } catch (Exception ex) {
            log.warn("CoinGecko /global request failed: {}. Falling back to mock data.", ex.getMessage());
            if (mockFallbackEnabled) {
                return mockService.getMockOverview();
            }
            throw new RuntimeException("External market API unavailable: " + ex.getMessage(), ex);
        }
        return mockService.getMockOverview();
    }

    public List<CoinSummaryDto> fetchCoins(int page, int perPage, String vsCurrency, String order) {
        try {
            log.info("Fetching coins from CoinGecko /coins/markets (page={}, perPage={})", page, perPage);
            List<Map<String, Object>> response = restClient.get()
                    .uri(uriBuilder -> uriBuilder
                            .path("/coins/markets")
                            .queryParam("vs_currency", vsCurrency)
                            .queryParam("order", order != null ? order : "market_cap_desc")
                            .queryParam("per_page", perPage)
                            .queryParam("page", page)
                            .queryParam("sparkline", "true")
                            .queryParam("price_change_percentage", "24h,7d")
                            .build())
                    .retrieve()
                    .body(new ParameterizedTypeReference<List<Map<String, Object>>>() {});

            if (response != null && !response.isEmpty()) {
                List<CoinSummaryDto> list = new ArrayList<>();
                for (Map<String, Object> item : response) {
                    list.add(mapToCoinSummary(item));
                }
                return list;
            }
        } catch (Exception ex) {
            log.warn("CoinGecko /coins/markets failed: {}. Falling back to mock data.", ex.getMessage());
            if (mockFallbackEnabled) {
                return mockService.getMockCoins(page, perPage, "market_cap", "desc");
            }
            throw new RuntimeException("Failed to fetch coins: " + ex.getMessage(), ex);
        }
        return mockService.getMockCoins(page, perPage, "market_cap", "desc");
    }

    public CoinDetailDto fetchCoinDetail(String coinId) {
        try {
            log.info("Fetching details for coin: {}", coinId);
            Map<String, Object> response = restClient.get()
                    .uri(uriBuilder -> uriBuilder
                            .path("/coins/{id}")
                            .queryParam("localization", "false")
                            .queryParam("tickers", "false")
                            .queryParam("market_data", "true")
                            .queryParam("community_data", "true")
                            .queryParam("developer_data", "false")
                            .queryParam("sparkline", "true")
                            .build(coinId.toLowerCase()))
                    .retrieve()
                    .body(new ParameterizedTypeReference<Map<String, Object>>() {});

            if (response != null) {
                return mapToCoinDetail(response);
            }
        } catch (Exception ex) {
            log.warn("CoinGecko /coins/{} failed: {}. Falling back to mock data.", coinId, ex.getMessage());
            if (mockFallbackEnabled) {
                return mockService.getMockCoinDetail(coinId);
            }
            throw new RuntimeException("Failed to fetch coin detail: " + ex.getMessage(), ex);
        }
        return mockService.getMockCoinDetail(coinId);
    }

    public ChartDataDto fetchCoinChart(String coinId, String range) {
        String days = mapRangeToDays(range);
        try {
            log.info("Fetching market chart for coin {} with range {} (days={})", coinId, range, days);
            Map<String, Object> response = restClient.get()
                    .uri(uriBuilder -> uriBuilder
                            .path("/coins/{id}/market_chart")
                            .queryParam("vs_currency", "usd")
                            .queryParam("days", days)
                            .build(coinId.toLowerCase()))
                    .retrieve()
                    .body(new ParameterizedTypeReference<Map<String, Object>>() {});

            if (response != null && response.containsKey("prices")) {
                @SuppressWarnings("unchecked")
                List<List<Object>> rawPrices = (List<List<Object>>) response.get("prices");
                List<ChartPointDto> points = new ArrayList<>();
                double minPrice = Double.MAX_VALUE;
                double maxPrice = Double.MIN_VALUE;

                for (List<Object> p : rawPrices) {
                    if (p.size() >= 2) {
                        long ts = ((Number) p.get(0)).longValue();
                        double price = ((Number) p.get(1)).doubleValue();
                        points.add(new ChartPointDto(ts, price));
                        minPrice = Math.min(minPrice, price);
                        maxPrice = Math.max(maxPrice, price);
                    }
                }

                double changePct = 0.0;
                if (!points.isEmpty()) {
                    double first = points.get(0).getPrice();
                    double last = points.get(points.size() - 1).getPrice();
                    changePct = first > 0 ? ((last - first) / first) * 100.0 : 0.0;
                }

                return new ChartDataDto(coinId, range, points, minPrice, maxPrice, Math.round(changePct * 100.0) / 100.0);
            }
        } catch (Exception ex) {
            log.warn("CoinGecko /coins/{}/market_chart failed: {}. Falling back to mock data.", coinId, ex.getMessage());
            if (mockFallbackEnabled) {
                return mockService.getMockChart(coinId, range);
            }
            throw new RuntimeException("Failed to fetch coin chart: " + ex.getMessage(), ex);
        }
        return mockService.getMockChart(coinId, range);
    }

    public List<CoinSummaryDto> fetchTrendingCoins() {
        try {
            log.info("Fetching trending coins from CoinGecko /search/trending");
            Map<String, Object> response = restClient.get()
                    .uri("/search/trending")
                    .retrieve()
                    .body(new ParameterizedTypeReference<Map<String, Object>>() {});

            if (response != null && response.containsKey("coins")) {
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> trendingCoins = (List<Map<String, Object>>) response.get("coins");
                List<CoinSummaryDto> result = new ArrayList<>();

                for (Map<String, Object> wrapper : trendingCoins) {
                    @SuppressWarnings("unchecked")
                    Map<String, Object> item = (Map<String, Object>) wrapper.get("item");
                    if (item != null) {
                        String id = (String) item.get("id");
                        String name = (String) item.get("name");
                        String symbol = (String) item.get("symbol");
                        String image = (String) item.get("large");
                        Integer rank = item.get("market_cap_rank") != null ? ((Number) item.get("market_cap_rank")).intValue() : null;

                        @SuppressWarnings("unchecked")
                        Map<String, Object> data = (Map<String, Object>) item.get("data");
                        Double price = 0.0;
                        Double changePct = 0.0;
                        List<Double> sparkline = Collections.emptyList();

                        if (data != null) {
                            if (data.get("price") instanceof Number n) {
                                price = n.doubleValue();
                            }
                            @SuppressWarnings("unchecked")
                            Map<String, Object> priceChange = (Map<String, Object>) data.get("price_change_percentage_24h");
                            if (priceChange != null && priceChange.get("usd") instanceof Number n) {
                                changePct = n.doubleValue();
                            }
                        }

                        result.add(new CoinSummaryDto(
                                id, symbol, name, image, price, null, rank, null,
                                null, null, null, changePct, sparkline, Instant.now().toString()
                        ));
                    }
                }
                if (!result.isEmpty()) {
                    return result;
                }
            }
        } catch (Exception ex) {
            log.warn("CoinGecko /search/trending failed: {}. Falling back to mock data.", ex.getMessage());
        }
        return mockService.getMockTrending();
    }

    public List<SearchResultDto> searchCoins(String query) {
        try {
            log.info("Searching coins on CoinGecko with query: {}", query);
            Map<String, Object> response = restClient.get()
                    .uri(uriBuilder -> uriBuilder
                            .path("/search")
                            .queryParam("query", query)
                            .build())
                    .retrieve()
                    .body(new ParameterizedTypeReference<Map<String, Object>>() {});

            if (response != null && response.containsKey("coins")) {
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> rawCoins = (List<Map<String, Object>>) response.get("coins");
                List<SearchResultDto> results = new ArrayList<>();

                for (Map<String, Object> c : rawCoins) {
                    String id = (String) c.get("id");
                    String name = (String) c.get("name");
                    String symbol = (String) c.get("symbol");
                    Integer rank = c.get("market_cap_rank") != null ? ((Number) c.get("market_cap_rank")).intValue() : null;
                    String thumb = (String) c.get("thumb");
                    String large = (String) c.get("large");

                    results.add(new SearchResultDto(id, name, symbol, rank, thumb, large));
                }
                return results;
            }
        } catch (Exception ex) {
            log.warn("CoinGecko /search failed: {}. Falling back to mock search.", ex.getMessage());
        }
        return mockService.searchMockCoins(query);
    }

    private String mapRangeToDays(String range) {
        if (range == null) return "7";
        return switch (range.toLowerCase()) {
            case "1h" -> "1";
            case "24h", "1d" -> "1";
            case "30d", "1m" -> "30";
            case "90d", "3m" -> "90";
            case "1y", "365d" -> "365";
            default -> "7";
        };
    }

    @SuppressWarnings("unchecked")
    private MarketOverviewDto mapToMarketOverview(Map<String, Object> data) {
        Map<String, Object> totalMarketCap = (Map<String, Object>) data.get("total_market_cap");
        Map<String, Object> totalVolume = (Map<String, Object>) data.get("total_volume");
        Map<String, Object> marketCapPercentage = (Map<String, Object>) data.get("market_cap_percentage");

        Double totalMarketCapUsd = totalMarketCap != null && totalMarketCap.get("usd") instanceof Number n ? n.doubleValue() : 2500000000000.0;
        Double totalVolumeUsd = totalVolume != null && totalVolume.get("usd") instanceof Number n ? n.doubleValue() : 80000000000.0;
        Double mcapChange = data.get("market_cap_change_percentage_24h_usd") instanceof Number n ? n.doubleValue() : 0.0;
        Double btcDom = marketCapPercentage != null && marketCapPercentage.get("btc") instanceof Number n ? n.doubleValue() : 50.0;
        Double ethDom = marketCapPercentage != null && marketCapPercentage.get("eth") instanceof Number n ? n.doubleValue() : 15.0;
        Long activeCoins = data.get("active_cryptocurrencies") instanceof Number n ? n.longValue() : 10000L;
        Integer ongoingIcos = data.get("ongoing_icos") instanceof Number n ? n.intValue() : 0;
        Integer markets = data.get("markets") instanceof Number n ? n.intValue() : 800;

        return new MarketOverviewDto(
                totalMarketCapUsd, totalVolumeUsd, mcapChange, btcDom, ethDom,
                activeCoins, ongoingIcos, markets, Instant.now().toString()
        );
    }

    @SuppressWarnings("unchecked")
    private CoinSummaryDto mapToCoinSummary(Map<String, Object> item) {
        String id = (String) item.get("id");
        String symbol = (String) item.get("symbol");
        String name = (String) item.get("name");
        String image = (String) item.get("image");

        Double price = getDouble(item, "current_price");
        Double mcap = getDouble(item, "market_cap");
        Integer rank = getInteger(item, "market_cap_rank");
        Double volume = getDouble(item, "total_volume");
        Double high24 = getDouble(item, "high_24h");
        Double low24 = getDouble(item, "low_24h");
        Double change24h = getDouble(item, "price_change_24h");
        Double changePct24h = getDouble(item, "price_change_percentage_24h");
        String lastUpdated = (String) item.get("last_updated");

        List<Double> sparkline = new ArrayList<>();
        Map<String, Object> sparklineObj = (Map<String, Object>) item.get("sparkline_in_7d");
        if (sparklineObj != null && sparklineObj.get("price") instanceof List<?> list) {
            for (Object o : list) {
                if (o instanceof Number n) {
                    sparkline.add(n.doubleValue());
                }
            }
        }

        return new CoinSummaryDto(
                id, symbol, name, image, price, mcap, rank, volume,
                high24, low24, change24h, changePct24h, sparkline, lastUpdated
        );
    }

    @SuppressWarnings("unchecked")
    private CoinDetailDto mapToCoinDetail(Map<String, Object> map) {
        CoinDetailDto coin = new CoinDetailDto();
        coin.setId((String) map.get("id"));
        coin.setSymbol((String) map.get("symbol"));
        coin.setName((String) map.get("name"));
        coin.setGenesisDate((String) map.get("genesis_date"));

        Map<String, Object> images = (Map<String, Object>) map.get("image");
        if (images != null) {
            coin.setImage((String) images.get("large"));
        }

        Map<String, Object> desc = (Map<String, Object>) map.get("description");
        if (desc != null) {
            coin.setDescription((String) desc.get("en"));
        }

        Map<String, Object> links = (Map<String, Object>) map.get("links");
        if (links != null) {
            if (links.get("homepage") instanceof List<?> list && !list.isEmpty()) {
                coin.setHomepage(String.valueOf(list.get(0)));
            }
            if (links.get("blockchain_site") instanceof List<?> list && !list.isEmpty()) {
                coin.setBlockchainSite(String.valueOf(list.get(0)));
            }
        }

        Map<String, Object> marketData = (Map<String, Object>) map.get("market_data");
        if (marketData != null) {
            coin.setCurrentPrice(getMapUsd(marketData, "current_price"));
            coin.setMarketCap(getMapUsd(marketData, "market_cap"));
            coin.setMarketCapRank(getInteger(marketData, "market_cap_rank"));
            coin.setFullyDilutedValuation(getMapUsd(marketData, "fully_diluted_valuation"));
            coin.setTotalVolume(getMapUsd(marketData, "total_volume"));
            coin.setHigh24h(getMapUsd(marketData, "high_24h"));
            coin.setLow24h(getMapUsd(marketData, "low_24h"));
            coin.setPriceChange24h(getDouble(marketData, "price_change_24h"));
            coin.setPriceChangePercentage24h(getDouble(marketData, "price_change_percentage_24h"));
            coin.setPriceChangePercentage7d(getDouble(marketData, "price_change_percentage_7d"));
            coin.setPriceChangePercentage30d(getDouble(marketData, "price_change_percentage_30d"));
            coin.setCirculatingSupply(getDouble(marketData, "circulating_supply"));
            coin.setTotalSupply(getDouble(marketData, "total_supply"));
            coin.setMaxSupply(getDouble(marketData, "max_supply"));

            coin.setAth(getMapUsd(marketData, "ath"));
            coin.setAthChangePercentage(getMapUsd(marketData, "ath_change_percentage"));
            coin.setAthDate(getMapString(marketData, "ath_date"));

            coin.setAtl(getMapUsd(marketData, "atl"));
            coin.setAtlChangePercentage(getMapUsd(marketData, "atl_change_percentage"));
            coin.setAtlDate(getMapString(marketData, "atl_date"));

            Map<String, Object> sparklineObj = (Map<String, Object>) marketData.get("sparkline_7d");
            if (sparklineObj != null && sparklineObj.get("price") instanceof List<?> list) {
                List<Double> sparkline = new ArrayList<>();
                for (Object o : list) {
                    if (o instanceof Number n) {
                        sparkline.add(n.doubleValue());
                    }
                }
                coin.setSparklineIn7d(sparkline);
            }
        }

        coin.setSentimentVotesUpPercentage(getDouble(map, "sentiment_votes_up_percentage"));
        coin.setSentimentVotesDownPercentage(getDouble(map, "sentiment_votes_down_percentage"));
        coin.setLastUpdated(Instant.now().toString());

        return coin;
    }

    @SuppressWarnings("unchecked")
    private Double getMapUsd(Map<String, Object> parent, String key) {
        Object val = parent.get(key);
        if (val instanceof Map<?, ?> m) {
            Object usd = m.get("usd");
            if (usd instanceof Number n) return n.doubleValue();
        } else if (val instanceof Number n) {
            return n.doubleValue();
        }
        return null;
    }

    @SuppressWarnings("unchecked")
    private String getMapString(Map<String, Object> parent, String key) {
        Object val = parent.get(key);
        if (val instanceof Map<?, ?> m) {
            Object usd = m.get("usd");
            if (usd != null) return String.valueOf(usd);
        }
        return null;
    }

    private Double getDouble(Map<String, Object> map, String key) {
        Object val = map.get(key);
        if (val instanceof Number n) return n.doubleValue();
        return null;
    }

    private Integer getInteger(Map<String, Object> map, String key) {
        Object val = map.get(key);
        if (val instanceof Number n) return n.intValue();
        return null;
    }
}
