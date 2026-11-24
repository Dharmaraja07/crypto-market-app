package com.cryptomarket.repository;

import com.cryptomarket.entity.WatchlistItemEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WatchlistItemRepository extends JpaRepository<WatchlistItemEntity, Long> {
    List<WatchlistItemEntity> findByUserIdOrderByCreatedAtDesc(String userId);

    Optional<WatchlistItemEntity> findByUserIdAndCoinId(String userId, String coinId);

    boolean existsByUserIdAndCoinId(String userId, String coinId);

    void deleteByUserIdAndCoinId(String userId, String coinId);
}
