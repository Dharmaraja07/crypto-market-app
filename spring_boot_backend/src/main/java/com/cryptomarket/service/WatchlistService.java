package com.cryptomarket.service;

import com.cryptomarket.dto.CoinDetailDto;
import com.cryptomarket.dto.WatchlistItemDto;
import com.cryptomarket.entity.WatchlistItemEntity;
import com.cryptomarket.exception.ResourceNotFoundException;
import com.cryptomarket.repository.WatchlistItemRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Service
public class WatchlistService {

    private static final Logger log = LoggerFactory.getLogger(WatchlistService.class);

    private final WatchlistItemRepository repository;
    private final CoinService coinService;

    public WatchlistService(WatchlistItemRepository repository, CoinService coinService) {
        this.repository = repository;
        this.coinService = coinService;
    }

    public List<WatchlistItemDto> getWatchlist(String userId) {
        String effectiveUser = normalizeUserId(userId);
        log.info("Fetching watchlist for user: {}", effectiveUser);

        List<WatchlistItemEntity> items = repository.findByUserIdOrderByCreatedAtDesc(effectiveUser);
        List<WatchlistItemDto> dtos = new ArrayList<>();

        for (WatchlistItemEntity item : items) {
            WatchlistItemDto dto = new WatchlistItemDto();
            dto.setId(item.getId());
            dto.setUserId(item.getUserId());
            dto.setCoinId(item.getCoinId());
            dto.setCoinSymbol(item.getCoinSymbol());
            dto.setCoinName(item.getCoinName());
            dto.setAddedAt(DateTimeFormatter.ISO_INSTANT.format(item.getCreatedAt()));

            // Enrich with live price data
            try {
                CoinDetailDto coin = coinService.getCoinDetail(item.getCoinId());
                if (coin != null) {
                    dto.setCoinImage(coin.getImage());
                    dto.setCurrentPrice(coin.getCurrentPrice());
                    dto.setPriceChangePercentage24h(coin.getPriceChangePercentage24h());
                    dto.setMarketCap(coin.getMarketCap());
                    dto.setMarketCapRank(coin.getMarketCapRank());
                }
            } catch (Exception e) {
                log.warn("Could not enrich watchlist item {}: {}", item.getCoinId(), e.getMessage());
            }

            dtos.add(dto);
        }

        return dtos;
    }

    @Transactional
    public WatchlistItemDto addToWatchlist(String userId, String coinId) {
        String effectiveUser = normalizeUserId(userId);
        String normalizedCoinId = coinId.trim().toLowerCase();
        log.info("Adding coin {} to watchlist for user {}", normalizedCoinId, effectiveUser);

        if (repository.existsByUserIdAndCoinId(effectiveUser, normalizedCoinId)) {
            log.info("Coin {} already in watchlist for user {}", normalizedCoinId, effectiveUser);
            return getWatchlistItemDto(effectiveUser, normalizedCoinId);
        }

        // Fetch coin details to verify and grab name/symbol
        CoinDetailDto coin = coinService.getCoinDetail(normalizedCoinId);
        String name = coin != null ? coin.getName() : normalizedCoinId;
        String symbol = coin != null ? coin.getSymbol().toUpperCase() : normalizedCoinId.toUpperCase();

        WatchlistItemEntity entity = new WatchlistItemEntity(effectiveUser, normalizedCoinId, symbol, name);
        WatchlistItemEntity saved = repository.save(entity);

        WatchlistItemDto dto = new WatchlistItemDto();
        dto.setId(saved.getId());
        dto.setUserId(saved.getUserId());
        dto.setCoinId(saved.getCoinId());
        dto.setCoinSymbol(saved.getCoinSymbol());
        dto.setCoinName(saved.getCoinName());
        dto.setAddedAt(DateTimeFormatter.ISO_INSTANT.format(saved.getCreatedAt()));
        if (coin != null) {
            dto.setCoinImage(coin.getImage());
            dto.setCurrentPrice(coin.getCurrentPrice());
            dto.setPriceChangePercentage24h(coin.getPriceChangePercentage24h());
            dto.setMarketCap(coin.getMarketCap());
            dto.setMarketCapRank(coin.getMarketCapRank());
        }

        return dto;
    }

    @Transactional
    public void removeFromWatchlist(String userId, String coinId) {
        String effectiveUser = normalizeUserId(userId);
        String normalizedCoinId = coinId.trim().toLowerCase();
        log.info("Removing coin {} from watchlist for user {}", normalizedCoinId, effectiveUser);

        if (!repository.existsByUserIdAndCoinId(effectiveUser, normalizedCoinId)) {
            throw new ResourceNotFoundException("Coin " + normalizedCoinId + " not found in user's watchlist");
        }

        repository.deleteByUserIdAndCoinId(effectiveUser, normalizedCoinId);
    }

    public boolean isInWatchlist(String userId, String coinId) {
        String effectiveUser = normalizeUserId(userId);
        return repository.existsByUserIdAndCoinId(effectiveUser, coinId.trim().toLowerCase());
    }

    private WatchlistItemDto getWatchlistItemDto(String userId, String coinId) {
        WatchlistItemEntity entity = repository.findByUserIdAndCoinId(userId, coinId)
                .orElseThrow(() -> new ResourceNotFoundException("Watchlist item not found"));

        WatchlistItemDto dto = new WatchlistItemDto();
        dto.setId(entity.getId());
        dto.setUserId(entity.getUserId());
        dto.setCoinId(entity.getCoinId());
        dto.setCoinSymbol(entity.getCoinSymbol());
        dto.setCoinName(entity.getCoinName());
        dto.setAddedAt(DateTimeFormatter.ISO_INSTANT.format(entity.getCreatedAt()));

        CoinDetailDto coin = coinService.getCoinDetail(coinId);
        if (coin != null) {
            dto.setCoinImage(coin.getImage());
            dto.setCurrentPrice(coin.getCurrentPrice());
            dto.setPriceChangePercentage24h(coin.getPriceChangePercentage24h());
            dto.setMarketCap(coin.getMarketCap());
            dto.setMarketCapRank(coin.getMarketCapRank());
        }

        return dto;
    }

    private String normalizeUserId(String userId) {
        if (userId == null || userId.trim().isEmpty()) {
            return "default_user";
        }
        return userId.trim();
    }
}
