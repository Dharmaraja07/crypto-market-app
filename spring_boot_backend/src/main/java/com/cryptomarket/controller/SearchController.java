package com.cryptomarket.controller;

import com.cryptomarket.dto.ApiResponse;
import com.cryptomarket.dto.SearchResultDto;
import com.cryptomarket.service.CoinService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.NotBlank;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/search")
@Validated
@Tag(name = "Search", description = "Endpoints for searching cryptocurrencies")
public class SearchController {

    private final CoinService coinService;

    public SearchController(CoinService coinService) {
        this.coinService = coinService;
    }

    @GetMapping
    @Operation(summary = "Search for cryptocurrencies", description = "Searches coins by symbol, name or identifier")
    public ResponseEntity<ApiResponse<List<SearchResultDto>>> search(
            @RequestParam @NotBlank(message = "Search query must not be blank")
            @Parameter(description = "Search keyword, e.g. bitcoin, eth, sol") String query
    ) {
        List<SearchResultDto> results = coinService.searchCoins(query);
        return ResponseEntity.ok(ApiResponse.ok(results));
    }
}
