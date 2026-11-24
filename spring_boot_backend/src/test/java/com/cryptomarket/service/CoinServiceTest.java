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
    void getCoins_DelegatesPaginationToUpstream() {
        // Sorting is now delegated to CoinGecko — the service returns whatever order
        // the upstream (or mock) returns for a given page. We verify that the correct
        // page and perPage are forwarded, and results are returned as-is (no re-sorting).
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

        // Mock returns coins in the order CoinGecko would (market_cap_desc = btc first)
        List<CoinSummaryDto> upstreamOrder = new ArrayList<>(List.of(c1, c2));
        when(client.fetchCoins(eq(1), eq(10), anyString(), anyString())).thenReturn(upstreamOrder);

        List<CoinSummaryDto> result = coinService.getCoins(1, 10, "market_cap", "desc", null);

        assertEquals(2, result.size());
        assertEquals("btc", result.get(0).getId());   // upstream order preserved
        assertEquals("eth", result.get(1).getId());
    }

    @Test
    void getCoins_Page2_ReturnsCorrectPage() {
        // Verify that page 2 is passed correctly to the upstream client (not faked)
        CoinSummaryDto c1 = new CoinSummaryDto();
        c1.setId("bnb");
        c1.setName("BNB");

        when(client.fetchCoins(eq(2), eq(5), anyString(), anyString())).thenReturn(List.of(c1));

        List<CoinSummaryDto> result = coinService.getCoins(2, 5, "market_cap", "desc", null);

        assertEquals(1, result.size());
        assertEquals("bnb", result.get(0).getId());
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
