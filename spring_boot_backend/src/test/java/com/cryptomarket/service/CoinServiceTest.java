package com.cryptomarket.service;

import com.cryptomarket.client.CoinGeckoRestClient;
import com.cryptomarket.dto.ChartDataDto;
import com.cryptomarket.dto.CoinDetailDto;
import com.cryptomarket.dto.CoinSummaryDto;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CoinServiceTest {

    @Mock
    private CoinGeckoRestClient client;

    private CoinService coinService;

    @BeforeEach
    void setUp() {
        coinService = new CoinService(client);
    }

    @Test
    void getCoins_SortsByPrice() {
        CoinSummaryDto c1 = new CoinSummaryDto();
        c1.setId("btc");
        c1.setName("Bitcoin");
        c1.setMarketCapRank(1);
        c1.setCurrentPrice(60000.0);

        CoinSummaryDto c2 = new CoinSummaryDto();
        c2.setId("eth");
        c2.setName("Ethereum");
        c2.setMarketCapRank(2);
        c2.setCurrentPrice(3000.0);

        List<CoinSummaryDto> list = new ArrayList<>(List.of(c2, c1));
        when(client.fetchCoins(anyInt(), anyInt(), anyString(), anyString())).thenReturn(list);

        List<CoinSummaryDto> result = coinService.getCoins(1, 10, "price", "desc", null);

        assertEquals(2, result.size());
        assertEquals("btc", result.get(0).getId());
        assertEquals("eth", result.get(1).getId());
    }

    @Test
    void getCoins_FiltersBySearch() {
        CoinSummaryDto c1 = new CoinSummaryDto();
        c1.setId("bitcoin");
        c1.setName("Bitcoin");
        c1.setSymbol("btc");

        CoinSummaryDto c2 = new CoinSummaryDto();
        c2.setId("ethereum");
        c2.setName("Ethereum");
        c2.setSymbol("eth");

        when(client.fetchCoins(anyInt(), anyInt(), anyString(), anyString())).thenReturn(new ArrayList<>(List.of(c1, c2)));

        List<CoinSummaryDto> result = coinService.getCoins(1, 10, "market_cap", "desc", "eth");

        assertEquals(1, result.size());
        assertEquals("ethereum", result.get(0).getId());
    }

    @Test
    void getCoinDetail_ReturnsDetail() {
        CoinDetailDto detail = new CoinDetailDto();
        detail.setId("solana");
        detail.setName("Solana");
        when(client.fetchCoinDetail("solana")).thenReturn(detail);

        CoinDetailDto result = coinService.getCoinDetail("solana");
        assertNotNull(result);
        assertEquals("solana", result.getId());
    }

    @Test
    void getCoinChart_ReturnsChart() {
        ChartDataDto chart = new ChartDataDto();
        chart.setCoinId("bitcoin");
        chart.setRange("24h");
        when(client.fetchCoinChart("bitcoin", "24h")).thenReturn(chart);

        ChartDataDto result = coinService.getCoinChart("bitcoin", "24h");
        assertNotNull(result);
        assertEquals("bitcoin", result.getCoinId());
    }
}
