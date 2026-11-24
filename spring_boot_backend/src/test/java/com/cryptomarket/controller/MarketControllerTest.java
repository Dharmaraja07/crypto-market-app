package com.cryptomarket.controller;

import com.cryptomarket.dto.MarketOverviewDto;
import com.cryptomarket.service.MarketService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(MarketController.class)
class MarketControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private MarketService marketService;

    @Test
    void getMarketOverview_ReturnsSuccess() throws Exception {
        MarketOverviewDto dto = new MarketOverviewDto(
                2500000000000.0, 80000000000.0, 2.5, 55.0, 15.0,
                14000L, 20, 900, "2024-10-01T00:00:00Z"
        );
        when(marketService.getMarketOverview()).thenReturn(dto);

        mockMvc.perform(get("/api/v1/market/overview")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.totalMarketCapUsd").value(2500000000000.0))
                .andExpect(jsonPath("$.data.btcDominancePercentage").value(55.0));
    }
}
