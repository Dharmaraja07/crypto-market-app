package com.cryptomarket.controller;

import com.cryptomarket.dto.*;
import com.cryptomarket.service.CoinService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(CoinController.class)
class CoinControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private CoinService coinService;

    @Test
    void getCoins_ReturnsCoinList() throws Exception {
        CoinSummaryDto coin = new CoinSummaryDto(
                "bitcoin", "btc", "Bitcoin", "https://img.coingecko.com/btc.png",
                65000.0, 1200000000000.0, 1, 30000000000.0,
                66000.0, 64000.0, 1000.0, 1.5, List.of(64000.0, 65000.0), "2024-10-01"
        );
        when(coinService.getCoins(anyInt(), anyInt(), anyString(), anyString(), any())).thenReturn(List.of(coin));

        mockMvc.perform(get("/api/v1/coins")
                        .param("page", "1")
                        .param("perPage", "10")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data[0].id").value("bitcoin"))
                .andExpect(jsonPath("$.data[0].symbol").value("btc"))
                .andExpect(jsonPath("$.data[0].currentPrice").value(65000.0));
    }

    @Test
    void getCoinDetail_ReturnsDetail() throws Exception {
        CoinDetailDto detail = new CoinDetailDto();
        detail.setId("ethereum");
        detail.setName("Ethereum");
        detail.setSymbol("eth");
        detail.setCurrentPrice(3500.0);
        detail.setMarketCapRank(2);

        when(coinService.getCoinDetail("ethereum")).thenReturn(detail);

        mockMvc.perform(get("/api/v1/coins/ethereum")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value("ethereum"))
                .andExpect(jsonPath("$.data.currentPrice").value(3500.0));
    }

    @Test
    void getCoinChart_ReturnsChartData() throws Exception {
        ChartDataDto chart = new ChartDataDto(
                "bitcoin", "7d",
                List.of(new ChartPointDto(1700000000000L, 64000.0), new ChartPointDto(1700000100000L, 65000.0)),
                64000.0, 65000.0, 1.56
        );
        when(coinService.getCoinChart("bitcoin", "7d")).thenReturn(chart);

        mockMvc.perform(get("/api/v1/coins/bitcoin/chart?range=7d")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.coinId").value("bitcoin"))
                .andExpect(jsonPath("$.data.points.length()").value(2));
    }

    @Test
    void getTrending_ReturnsTrendingCoins() throws Exception {
        CoinSummaryDto coin = new CoinSummaryDto();
        coin.setId("solana");
        coin.setName("Solana");
        when(coinService.getTrendingCoins()).thenReturn(List.of(coin));

        mockMvc.perform(get("/api/v1/coins/trending"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data[0].id").value("solana"));
    }
}
