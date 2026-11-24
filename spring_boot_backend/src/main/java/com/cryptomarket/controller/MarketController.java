package com.cryptomarket.controller;

import com.cryptomarket.dto.ApiResponse;
import com.cryptomarket.dto.MarketOverviewDto;
import com.cryptomarket.service.MarketService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/market")
@Tag(name = "Market Overview", description = "Global cryptocurrency market capitalization, dominance, and volume statistics")
public class MarketController {

    private final MarketService marketService;

    public MarketController(MarketService marketService) {
        this.marketService = marketService;
    }

    @GetMapping("/overview")
    @Operation(summary = "Get global market overview", description = "Returns total market cap, 24h volume, BTC/ETH dominance, and market trends")
    public ResponseEntity<ApiResponse<MarketOverviewDto>> getMarketOverview() {
        MarketOverviewDto overview = marketService.getMarketOverview();
        return ResponseEntity.ok(ApiResponse.ok(overview));
    }
}
