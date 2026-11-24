package com.cryptomarket.controller;

import com.cryptomarket.dto.ApiResponse;
import com.cryptomarket.dto.WatchlistItemDto;
import com.cryptomarket.service.WatchlistService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/watchlist")
@Tag(name = "Watchlist", description = "Endpoints for managing user cryptocurrency watchlists")
public class WatchlistController {

    private final WatchlistService watchlistService;

    public WatchlistController(WatchlistService watchlistService) {
        this.watchlistService = watchlistService;
    }

    @GetMapping
    @Operation(summary = "Get user's watchlist", description = "Returns saved cryptocurrencies with live market data for the given user ID")
    public ResponseEntity<ApiResponse<List<WatchlistItemDto>>> getWatchlist(
            @RequestParam(defaultValue = "default_user") @Parameter(description = "User identifier") String userId
    ) {
        List<WatchlistItemDto> items = watchlistService.getWatchlist(userId);
        return ResponseEntity.ok(ApiResponse.ok(items));
    }

    @PostMapping("/{coinId}")
    @Operation(summary = "Add a cryptocurrency to watchlist", description = "Persists a cryptocurrency to the user's watchlist")
    public ResponseEntity<ApiResponse<WatchlistItemDto>> addToWatchlist(
            @PathVariable @Parameter(description = "Coin identifier") String coinId,
            @RequestParam(defaultValue = "default_user") @Parameter(description = "User identifier") String userId
    ) {
        WatchlistItemDto item = watchlistService.addToWatchlist(userId, coinId);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok("Coin added to watchlist", item));
    }

    @DeleteMapping("/{coinId}")
    @Operation(summary = "Remove a cryptocurrency from watchlist", description = "Deletes a cryptocurrency from the user's watchlist")
    public ResponseEntity<ApiResponse<Void>> removeFromWatchlist(
            @PathVariable @Parameter(description = "Coin identifier") String coinId,
            @RequestParam(defaultValue = "default_user") @Parameter(description = "User identifier") String userId
    ) {
        watchlistService.removeFromWatchlist(userId, coinId);
        return ResponseEntity.ok(ApiResponse.ok("Coin removed from watchlist", null));
    }

    @GetMapping("/{coinId}/status")
    @Operation(summary = "Check if coin is in watchlist")
    public ResponseEntity<ApiResponse<Map<String, Boolean>>> checkWatchlistStatus(
            @PathVariable String coinId,
            @RequestParam(defaultValue = "default_user") String userId
    ) {
        boolean inWatchlist = watchlistService.isInWatchlist(userId, coinId);
        return ResponseEntity.ok(ApiResponse.ok(Map.of("inWatchlist", inWatchlist)));
    }
}
