package com.cryptomarket.service;

import com.cryptomarket.client.CoinGeckoRestClient;
import com.cryptomarket.dto.MarketOverviewDto;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class MarketServiceTest {

    @Mock
    private CoinGeckoRestClient client;

    private MarketService marketService;

    @BeforeEach
    void setUp() {
        marketService = new MarketService(client);
    }

    @Test
    void getMarketOverview_ReturnsOverview() {
        MarketOverviewDto dto = new MarketOverviewDto();
        dto.setTotalMarketCapUsd(2500000000000.0);
        dto.setBtcDominancePercentage(56.0);
        when(client.fetchGlobalOverview()).thenReturn(dto);

        MarketOverviewDto result = marketService.getMarketOverview();
        assertNotNull(result);
        assertEquals(2500000000000.0, result.getTotalMarketCapUsd());
        assertEquals(56.0, result.getBtcDominancePercentage());
    }
}
