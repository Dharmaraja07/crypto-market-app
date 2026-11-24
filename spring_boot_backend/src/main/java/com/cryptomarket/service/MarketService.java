package com.cryptomarket.service;

import com.cryptomarket.client.CoinGeckoRestClient;
import com.cryptomarket.dto.MarketOverviewDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

@Service
public class MarketService {

    private static final Logger log = LoggerFactory.getLogger(MarketService.class);
    private final CoinGeckoRestClient client;

    public MarketService(CoinGeckoRestClient client) {
        this.client = client;
    }

    @Cacheable(value = "marketOverview", unless = "#result == null")
    public MarketOverviewDto getMarketOverview() {
        log.info("Fetching market overview (cache miss)");
        return client.fetchGlobalOverview();
    }
}
