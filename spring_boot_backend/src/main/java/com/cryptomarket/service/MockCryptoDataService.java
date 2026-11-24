package com.cryptomarket.service;

import com.cryptomarket.dto.*;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class MockCryptoDataService {

    private final List<CoinDetailDto> mockCoins = new ArrayList<>();

    public MockCryptoDataService() {
        initMockCoins();
    }

    private void initMockCoins() {
        mockCoins.add(createCoin(
                "bitcoin", "btc", "Bitcoin",
                "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
                "Bitcoin is the first decentralized digital currency. It was invented in 2008 by Satoshi Nakamoto and released as open-source software in 2009.",
                68420.50, 1348000000000.0, 1, 1420000000000.0, 38500000000.0,
                69200.0, 67100.0, 1320.50, 2.45, 5.12, 12.80,
                19700000.0, 19700000.0, 21000000.0,
                73750.07, -7.2, "2024-03-14T07:10:00Z",
                67.81, 100800.0, "2013-07-06T00:00:00Z",
                "https://bitcoin.org", "https://mempool.space", "2009-01-03",
                88.5, 11.5
        ));

        mockCoins.add(createCoin(
                "ethereum", "eth", "Ethereum",
                "https://assets.coingecko.com/coins/images/279/large/ethereum.png",
                "Ethereum is a decentralized, open-source blockchain with smart contract functionality. Ether is the native cryptocurrency of the platform.",
                3560.80, 428000000000.0, 2, 428000000000.0, 21400000000.0,
                3620.0, 3480.0, -42.20, -1.18, 3.40, 8.90,
                120200000.0, 120200000.0, null,
                4891.70, -27.2, "2021-11-16T08:42:00Z",
                0.4209, 845000.0, "2015-10-21T00:00:00Z",
                "https://ethereum.org", "https://etherscan.io", "2015-07-30",
                82.0, 18.0
        ));

        mockCoins.add(createCoin(
                "solana", "sol", "Solana",
                "https://assets.coingecko.com/coins/images/4128/large/solana.png",
                "Solana is a high-performance blockchain supporting builders around the world making crypto apps that scale today.",
                182.40, 85400000000.0, 3, 105000000000.0, 8900000000.0,
                188.0, 172.5, 9.90, 5.74, 18.25, 34.60,
                468000000.0, 584000000.0, null,
                260.06, -29.8, "2021-11-06T21:54:00Z",
                0.5052, 36000.0, "2020-05-11T19:35:00Z",
                "https://solana.com", "https://solscan.io", "2020-03-16",
                85.0, 15.0
        ));

        mockCoins.add(createCoin(
                "binancecoin", "bnb", "BNB",
                "https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png",
                "BNB powers the BNB Chain ecosystem and is one of the world's most popular utility tokens.",
                592.15, 87600000000.0, 4, 87600000000.0, 1450000000.0,
                601.0, 584.0, 6.30, 1.08, 2.10, 4.50,
                147500000.0, 147500000.0, 200000000.0,
                720.67, -17.8, "2024-06-06T09:00:00Z",
                0.096, 616000.0, "2017-10-19T00:00:00Z",
                "https://bnbchain.org", "https://bscscan.com", "2017-07-08",
                79.0, 21.0
        ));

        mockCoins.add(createCoin(
                "ripple", "xrp", "XRP",
                "https://assets.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png",
                "XRP is a digital asset built for global payments, offering financial institutions a reliable, on-demand option for liquidity.",
                0.584, 32800000000.0, 5, 58400000000.0, 1920000000.0,
                0.612, 0.572, -0.018, -2.99, -4.20, 1.10,
                56200000000.0, 99980000000.0, 100000000000.0,
                3.84, -84.8, "2018-01-04T00:00:00Z",
                0.0028, 20700.0, "2014-07-07T00:00:00Z",
                "https://ripple.com/xrp", "https://xrpscan.com", "2012-08-01",
                71.0, 29.0
        ));

        mockCoins.add(createCoin(
                "cardano", "ada", "Cardano",
                "https://assets.coingecko.com/coins/images/975/large/cardano.png",
                "Cardano is a proof-of-stake blockchain platform that says its goal is to allow changemakers, innovators and visionaries to bring about positive global change.",
                0.412, 14800000000.0, 6, 18500000000.0, 620000000.0,
                0.428, 0.405, 0.007, 1.73, 8.40, 15.20,
                35800000000.0, 45000000000.0, 45000000000.0,
                3.10, -86.7, "2021-09-02T06:00:00Z",
                0.0173, 2280.0, "2020-03-13T02:00:00Z",
                "https://cardano.org", "https://cardanoscan.io", "2017-09-29",
                76.0, 24.0
        ));

        mockCoins.add(createCoin(
                "avalanche-2", "avax", "Avalanche",
                "https://assets.coingecko.com/coins/images/12559/large/Avalanche_Circle_RedWhite_Trans.png",
                "Avalanche is an umbrella platform for launching decentralized finance (DeFi) applications, financial assets, trading and other services.",
                29.80, 11900000000.0, 7, 21400000000.0, 480000000.0,
                31.2, 28.9, 1.45, 5.12, 14.50, 28.00,
                398000000.0, 444000000.0, 720000000.0,
                146.22, -79.6, "2021-11-21T13:00:00Z",
                2.79, 968.0, "2020-12-31T14:00:00Z",
                "https://avax.network", "https://snowtrace.io", "2020-09-21",
                81.0, 19.0
        ));

        mockCoins.add(createCoin(
                "dogecoin", "doge", "Dogecoin",
                "https://assets.coingecko.com/coins/images/5/large/dogecoin.png",
                "Dogecoin is based on the popular 'doge' Internet meme and features a Shiba Inu on its logo. The open-source digital currency was created by Billy Markus and Jackson Palmer.",
                0.142, 20600000000.0, 8, 20600000000.0, 1800000000.0,
                0.155, 0.138, 0.008, 5.97, 12.40, 24.80,
                146000000000.0, 146000000000.0, null,
                0.7376, -80.7, "2021-05-08T05:00:00Z",
                0.000085, 167000.0, "2015-05-07T00:00:00Z",
                "https://dogecoin.com", "https://dogechain.info", "2013-12-06",
                74.0, 26.0
        ));

        mockCoins.add(createCoin(
                "polkadot", "dot", "Polkadot",
                "https://assets.coingecko.com/coins/images/12171/large/polkadot.png",
                "Polkadot is an open-source sharded multichain protocol that connects and secures a network of specialized blockchains.",
                4.85, 7100000000.0, 9, 7400000000.0, 240000000.0,
                4.95, 4.70, -0.15, -3.00, -2.10, -6.50,
                1460000000.0, 1510000000.0, null,
                55.00, -91.2, "2021-11-04T14:00:00Z",
                2.69, 80.3, "2020-08-20T05:00:00Z",
                "https://polkadot.network", "https://polkascan.io", "2020-05-26",
                68.0, 32.0
        ));

        mockCoins.add(createCoin(
                "chainlink", "link", "Chainlink",
                "https://assets.coingecko.com/coins/images/877/large/chainlink-new-logo.png",
                "Founded in 2017, Chainlink is a blockchain abstraction layer that enables universally connected smart contracts through decentralized oracle networks.",
                12.60, 7800000000.0, 10, 12600000000.0, 310000000.0,
                13.10, 12.30, 0.35, 2.85, 6.70, 11.20,
                608000000.0, 1000000000.0, 1000000000.0,
                52.88, -76.1, "2021-05-10T00:00:00Z",
                0.126, 9900.0, "2017-09-23T00:00:00Z",
                "https://chain.link", "https://etherscan.io/token/0x514910771af9ca656af840dff83e8264ecf986ca", "2017-09-19",
                86.0, 14.0
        ));

        mockCoins.add(createCoin(
                "near", "near", "NEAR Protocol",
                "https://assets.coingecko.com/coins/images/10365/large/near.png",
                "NEAR Protocol is a layer-one blockchain that was designed as a community-run cloud compute platform.",
                5.65, 6900000000.0, 11, 6900000000.0, 490000000.0,
                5.90, 5.30, 0.45, 8.65, 22.40, 45.10,
                1210000000.0, 1210000000.0, null,
                20.42, -72.3, "2022-01-16T17:00:00Z",
                0.526, 974.0, "2020-11-04T15:00:00Z",
                "https://near.org", "https://nearblocks.io", "2020-04-22",
                89.0, 11.0
        ));

        mockCoins.add(createCoin(
                "sui", "sui", "Sui",
                "https://assets.coingecko.com/coins/images/26375/large/sui-ocean-square.png",
                "Sui is an innovative Layer 1 blockchain and smart contract platform designed to make digital asset ownership fast, private, secure, and accessible.",
                2.15, 6100000000.0, 12, 21500000000.0, 890000000.0,
                2.35, 1.95, 0.28, 14.97, 45.30, 120.40,
                2840000000.0, 10000000000.0, 10000000000.0,
                2.36, -8.9, "2024-10-13T12:00:00Z",
                0.364, 490.0, "2023-10-19T00:00:00Z",
                "https://sui.io", "https://suiscan.xyz", "2023-05-03",
                91.0, 9.0
        ));

        mockCoins.add(createCoin(
                "render-token", "render", "Render",
                "https://assets.coingecko.com/coins/images/11636/large/rndr.png",
                "Render Network is a provider of decentralized GPU based rendering solutions, revolutionary for AI and 3D graphics.",
                6.42, 3300000000.0, 13, 3400000000.0, 210000000.0,
                6.80, 6.10, -0.32, -4.75, 7.80, 21.30,
                518000000.0, 532000000.0, 532000000.0,
                13.53, -52.5, "2024-03-17T18:00:00Z",
                0.036, 17700.0, "2020-06-16T00:00:00Z",
                "https://render.x.io", "https://solscan.io", "2020-04-10",
                80.0, 20.0
        ));
    }

    private CoinDetailDto createCoin(
            String id, String symbol, String name, String image, String desc,
            Double price, Double marketCap, Integer rank, Double fdv, Double volume,
            Double high24, Double low24, Double change24, Double changePct24,
            Double changePct7d, Double changePct30d,
            Double circSupply, Double totalSupply, Double maxSupply,
            Double ath, Double athPct, String athDate,
            Double atl, Double atlPct, String atlDate,
            String homepage, String explorer, String genesis,
            Double sentimentUp, Double sentimentDown
    ) {
        CoinDetailDto coin = new CoinDetailDto();
        coin.setId(id);
        coin.setSymbol(symbol);
        coin.setName(name);
        coin.setImage(image);
        coin.setDescription(desc);
        coin.setCurrentPrice(price);
        coin.setMarketCap(marketCap);
        coin.setMarketCapRank(rank);
        coin.setFullyDilutedValuation(fdv);
        coin.setTotalVolume(volume);
        coin.setHigh24h(high24);
        coin.setLow24h(low24);
        coin.setPriceChange24h(change24);
        coin.setPriceChangePercentage24h(changePct24);
        coin.setPriceChangePercentage7d(changePct7d);
        coin.setPriceChangePercentage30d(changePct30d);
        coin.setCirculatingSupply(circSupply);
        coin.setTotalSupply(totalSupply);
        coin.setMaxSupply(maxSupply);
        coin.setAth(ath);
        coin.setAthChangePercentage(athPct);
        coin.setAthDate(athDate);
        coin.setAtl(atl);
        coin.setAtlChangePercentage(atlPct);
        coin.setAtlDate(atlDate);
        coin.setHomepage(homepage);
        coin.setBlockchainSite(explorer);
        coin.setGenesisDate(genesis);
        coin.setSentimentVotesUpPercentage(sentimentUp);
        coin.setSentimentVotesDownPercentage(sentimentDown);
        coin.setSparklineIn7d(generateSparkline(price, changePct24 >= 0));
        coin.setLastUpdated(Instant.now().toString());
        return coin;
    }

    private List<Double> generateSparkline(double currentPrice, boolean positive) {
        List<Double> points = new ArrayList<>();
        double base = positive ? currentPrice * 0.94 : currentPrice * 1.06;
        double step = (currentPrice - base) / 20.0;
        Random rnd = new Random(Math.abs((long) currentPrice * 100));

        for (int i = 0; i <= 20; i++) {
            double noise = (rnd.nextDouble() - 0.5) * (currentPrice * 0.02);
            double val = base + (step * i) + noise;
            points.add(Math.round(val * 100.0) / 100.0);
        }
        points.set(points.size() - 1, currentPrice);
        return points;
    }

    public MarketOverviewDto getMockOverview() {
        return new MarketOverviewDto(
                2648291034020.0,
                88421094320.0,
                2.15,
                56.4,
                15.2,
                14982L,
                42,
                1120,
                Instant.now().toString()
        );
    }

    public List<CoinSummaryDto> getMockCoins(int page, int perPage, String sortBy, String order) {
        List<CoinSummaryDto> summaries = mockCoins.stream()
                .map(this::toSummary)
                .collect(Collectors.toList());

        // Sort
        Comparator<CoinSummaryDto> comparator = switch (sortBy != null ? sortBy.toLowerCase() : "market_cap") {
            case "price" -> Comparator.comparing(CoinSummaryDto::getCurrentPrice, Comparator.nullsLast(Double::compareTo));
            case "volume", "total_volume" -> Comparator.comparing(CoinSummaryDto::getTotalVolume, Comparator.nullsLast(Double::compareTo));
            case "percentage_change", "price_change_percentage_24h" -> Comparator.comparing(CoinSummaryDto::getPriceChangePercentage24h, Comparator.nullsLast(Double::compareTo));
            default -> Comparator.comparing(CoinSummaryDto::getMarketCapRank, Comparator.nullsLast(Integer::compareTo));
        };

        if ("desc".equalsIgnoreCase(order) && !"market_cap".equalsIgnoreCase(sortBy)) {
            comparator = comparator.reversed();
        } else if ("asc".equalsIgnoreCase(order) && "market_cap".equalsIgnoreCase(sortBy)) {
            comparator = comparator.reversed();
        }

        summaries.sort(comparator);

        int start = Math.max(0, (page - 1) * perPage);
        int end = Math.min(summaries.size(), start + perPage);
        if (start >= summaries.size()) {
            return Collections.emptyList();
        }
        return summaries.subList(start, end);
    }

    public CoinDetailDto getMockCoinDetail(String coinId) {
        return mockCoins.stream()
                .filter(c -> c.getId().equalsIgnoreCase(coinId) || c.getSymbol().equalsIgnoreCase(coinId))
                .findFirst()
                .orElseGet(() -> {
                    // Fallback generic coin
                    return createCoin(
                            coinId.toLowerCase(), coinId.substring(0, Math.min(4, coinId.length())).toUpperCase(),
                            Character.toUpperCase(coinId.charAt(0)) + coinId.substring(1),
                            "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
                            "Comprehensive market insights for " + coinId,
                            10.0, 500000000.0, 99, 1000000000.0, 25000000.0,
                            11.0, 9.5, 0.5, 5.0, 10.0, 20.0,
                            50000000.0, 100000000.0, 100000000.0,
                            25.0, -60.0, "2021-11-10T00:00:00Z",
                            1.0, 900.0, "2020-01-01T00:00:00Z",
                            "https://cryptomarket.io", "https://etherscan.io", "2021-01-01",
                            80.0, 20.0
                    );
                });
    }

    public List<CoinSummaryDto> getMockTrending() {
        return List.of(
                toSummary(mockCoins.get(2)), // solana
                toSummary(mockCoins.get(11)), // sui
                toSummary(mockCoins.get(10)), // near
                toSummary(mockCoins.get(0))  // bitcoin
        );
    }

    public List<CoinSummaryDto> getMockTopGainers() {
        return mockCoins.stream()
                .sorted(Comparator.comparing(CoinDetailDto::getPriceChangePercentage24h).reversed())
                .limit(5)
                .map(this::toSummary)
                .collect(Collectors.toList());
    }

    public List<CoinSummaryDto> getMockTopLosers() {
        return mockCoins.stream()
                .sorted(Comparator.comparing(CoinDetailDto::getPriceChangePercentage24h))
                .limit(5)
                .map(this::toSummary)
                .collect(Collectors.toList());
    }

    public List<SearchResultDto> searchMockCoins(String query) {
        String q = query.toLowerCase().trim();
        return mockCoins.stream()
                .filter(c -> c.getName().toLowerCase().contains(q) || c.getSymbol().toLowerCase().contains(q) || c.getId().contains(q))
                .map(c -> new SearchResultDto(c.getId(), c.getName(), c.getSymbol().toUpperCase(), c.getMarketCapRank(), c.getImage(), c.getImage()))
                .collect(Collectors.toList());
    }

    public ChartDataDto getMockChart(String coinId, String range) {
        CoinDetailDto coin = getMockCoinDetail(coinId);
        double currentPrice = coin.getCurrentPrice() != null ? coin.getCurrentPrice() : 100.0;

        int pointCount;
        long durationMs;
        switch (range != null ? range.toLowerCase() : "7d") {
            case "1h" -> {
                pointCount = 12;
                durationMs = 3600 * 1000L;
            }
            case "24h", "1d" -> {
                pointCount = 24;
                durationMs = 24 * 3600 * 1000L;
            }
            case "30d", "1m" -> {
                pointCount = 30;
                durationMs = 30L * 24 * 3600 * 1000L;
            }
            case "90d", "3m" -> {
                pointCount = 45;
                durationMs = 90L * 24 * 3600 * 1000L;
            }
            case "1y", "365d" -> {
                pointCount = 52;
                durationMs = 365L * 24 * 3600 * 1000L;
            }
            case "7d" -> {
                pointCount = 28;
                durationMs = 7L * 24 * 3600 * 1000L;
            }
            default -> {
                pointCount = 28;
                durationMs = 7L * 24 * 3600 * 1000L;
            }
        }

        long now = System.currentTimeMillis();
        long startTime = now - durationMs;
        long stepTime = durationMs / Math.max(1, pointCount - 1);

        double startPrice;
        Random rnd = new Random((long) coinId.hashCode() + durationMs);
        double changePercent = (rnd.nextDouble() * 20.0) - 8.0; // between -8% and +12%
        startPrice = currentPrice / (1.0 + (changePercent / 100.0));

        List<ChartPointDto> points = new ArrayList<>();
        double minPrice = Double.MAX_VALUE;
        double maxPrice = Double.MIN_VALUE;

        for (int i = 0; i < pointCount; i++) {
            long t = startTime + (i * stepTime);
            double progress = (double) i / (pointCount - 1);
            double linear = startPrice + (currentPrice - startPrice) * progress;
            double volatility = currentPrice * 0.02 * Math.sin(progress * Math.PI * 4);
            double randomJitter = (rnd.nextDouble() - 0.5) * (currentPrice * 0.015);
            double p = Math.max(0.0001, linear + volatility + randomJitter);
            if (i == pointCount - 1) {
                p = currentPrice;
            }
            p = Math.round(p * 100.0) / 100.0;
            minPrice = Math.min(minPrice, p);
            maxPrice = Math.max(maxPrice, p);
            points.add(new ChartPointDto(t, p));
        }

        double calculatedChange = ((currentPrice - points.get(0).getPrice()) / points.get(0).getPrice()) * 100.0;
        calculatedChange = Math.round(calculatedChange * 100.0) / 100.0;

        return new ChartDataDto(coinId, range, points, minPrice, maxPrice, calculatedChange);
    }

    public CoinSummaryDto toSummary(CoinDetailDto d) {
        return new CoinSummaryDto(
                d.getId(), d.getSymbol(), d.getName(), d.getImage(),
                d.getCurrentPrice(), d.getMarketCap(), d.getMarketCapRank(),
                d.getTotalVolume(), d.getHigh24h(), d.getLow24h(),
                d.getPriceChange24h(), d.getPriceChangePercentage24h(),
                d.getSparklineIn7d(), d.getLastUpdated()
        );
    }
}
