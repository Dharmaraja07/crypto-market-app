package com.cryptomarket.controller;

import com.cryptomarket.dto.WatchlistItemDto;
import com.cryptomarket.service.WatchlistService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(WatchlistController.class)
class WatchlistControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private WatchlistService watchlistService;

    @Test
    void getWatchlist_ReturnsItems() throws Exception {
        WatchlistItemDto item = new WatchlistItemDto();
        item.setId(1L);
        item.setCoinId("bitcoin");
        item.setCoinName("Bitcoin");
        item.setCoinSymbol("BTC");
        when(watchlistService.getWatchlist("default_user")).thenReturn(List.of(item));

        mockMvc.perform(get("/api/v1/watchlist").param("userId", "default_user"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data[0].coinId").value("bitcoin"));
    }

    @Test
    void addToWatchlist_ReturnsCreatedItem() throws Exception {
        WatchlistItemDto item = new WatchlistItemDto();
        item.setId(1L);
        item.setCoinId("solana");
        item.setCoinName("Solana");
        item.setCoinSymbol("SOL");
        when(watchlistService.addToWatchlist("default_user", "solana")).thenReturn(item);

        mockMvc.perform(post("/api/v1/watchlist/solana").param("userId", "default_user"))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.coinId").value("solana"));
    }

    @Test
    void removeFromWatchlist_ReturnsOk() throws Exception {
        doNothing().when(watchlistService).removeFromWatchlist("default_user", "solana");

        mockMvc.perform(delete("/api/v1/watchlist/solana").param("userId", "default_user"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }
}
