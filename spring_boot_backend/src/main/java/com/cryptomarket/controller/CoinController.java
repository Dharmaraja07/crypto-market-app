package com.cryptomarket.controller;

import com.cryptomarket.dto.*;
import com.cryptomarket.service.CoinService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/coins")
@Validated
@Tag(name = "Cryptocurrencies", description = "Endpoints for coin listings, details, historical price charts, trending, gainers, and losers")
public class CoinController {

    private final CoinService coinService;

    public CoinController(CoinService coinService) {
        this.coinService = coinService;
    }

    @GetMapping
    @Operation(summary = "Get paginated cryptocurrency data", description = "Supports pagination, sorting by market_cap/price/volume/change, and search filtering")
    public ResponseEntity<ApiResponse<List<CoinSummaryDto>>> getCoins(
            @RequestParam(defaultValue = "1") @Min(1) int page,
            @RequestParam(defaultValue = "20") @Min(1) @Max(100) int perPage,
            @RequestParam(defaultValue = "market_cap") String sortBy,
            @RequestParam(defaultValue = "desc") String order,
            @RequestParam(required = false) String search
    ) {
        List<CoinSummaryDto> coins = coinService.getCoins(page, perPage, sortBy, order, search);
        return ResponseEntity.ok(ApiResponse.ok(coins));
    }

    @GetMapping("/trending")
    @Operation(summary = "Get trending cryptocurrencies", description = "Returns most popular cryptocurrencies searched and traded globally")
    public ResponseEntity<ApiResponse<List<CoinSummaryDto>>> getTrendingCoins() {
        List<CoinSummaryDto> trending = coinService.getTrendingCoins();
        return ResponseEntity.ok(ApiResponse.ok(trending));
    }

    @GetMapping("/top-gainers")
    @Operation(summary = "Get top gaining cryptocurrencies", description = "Returns cryptocurrencies with highest 24h percentage gain")
    public ResponseEntity<ApiResponse<List<CoinSummaryDto>>> getTopGainers(
            @RequestParam(defaultValue = "5") @Min(1) @Max(50) int limit
    ) {
        List<CoinSummaryDto> gainers = coinService.getTopGainers(limit);
        return ResponseEntity.ok(ApiResponse.ok(gainers));
    }

    @GetMapping("/top-losers")
    @Operation(summary = "Get top losing cryptocurrencies", description = "Returns cryptocurrencies with highest 24h percentage loss")
    public ResponseEntity<ApiResponse<List<CoinSummaryDto>>> getTopLosers(
            @RequestParam(defaultValue = "5") @Min(1) @Max(50) int limit
    ) {
        List<CoinSummaryDto> losers = coinService.getTopLosers(limit);
        return ResponseEntity.ok(ApiResponse.ok(losers));
    }

    @GetMapping("/{coinId}")
    @Operation(summary = "Get detailed information for a cryptocurrency", description = "Returns comprehensive metadata, supplies, ATH/ATL, and links for a specific coin")
    public ResponseEntity<ApiResponse<CoinDetailDto>> getCoinDetail(
            @PathVariable @Parameter(description = "Coin identifier e.g. bitcoin, ethereum, solana") String coinId
    ) {
        CoinDetailDto detail = coinService.getCoinDetail(coinId);
        return ResponseEntity.ok(ApiResponse.ok(detail));
    }

    @GetMapping("/{coinId}/chart")
    @Operation(summary = "Get historical price chart data", description = "Returns time-series price points for chart rendering (supported ranges: 1h, 24h, 7d, 30d, 90d, 1y)")
    public ResponseEntity<ApiResponse<ChartDataDto>> getCoinChart(
            @PathVariable String coinId,
            @RequestParam(defaultValue = "7d") @Parameter(description = "Range: 1h, 24h, 7d, 30d, 90d, 1y") String range
    ) {
        ChartDataDto chart = coinService.getCoinChart(coinId, range);
        return ResponseEntity.ok(ApiResponse.ok(chart));
    }
}
