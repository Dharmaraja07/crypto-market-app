package com.cryptomarket.entity;

import jakarta.persistence.*;
import java.time.Instant;

@Entity
@Table(name = "watchlist_items",
        uniqueConstraints = {
                @UniqueConstraint(name = "uq_user_coin", columnNames = {"user_id", "coin_id"})
        },
        indexes = {
                @Index(name = "idx_watchlist_user_id", columnList = "user_id")
        }
)
public class WatchlistItemEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false, length = 100)
    private String userId;

    @Column(name = "coin_id", nullable = false, length = 100)
    private String coinId;

    @Column(name = "coin_symbol", nullable = false, length = 20)
    private String coinSymbol;

    @Column(name = "coin_name", nullable = false, length = 100)
    private String coinName;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    public WatchlistItemEntity() {
        this.createdAt = Instant.now();
    }

    public WatchlistItemEntity(String userId, String coinId, String coinSymbol, String coinName) {
        this.userId = userId;
        this.coinId = coinId;
        this.coinSymbol = coinSymbol;
        this.coinName = coinName;
        this.createdAt = Instant.now();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getCoinId() {
        return coinId;
    }

    public void setCoinId(String coinId) {
        this.coinId = coinId;
    }

    public String getCoinSymbol() {
        return coinSymbol;
    }

    public void setCoinSymbol(String coinSymbol) {
        this.coinSymbol = coinSymbol;
    }

    public String getCoinName() {
        return coinName;
    }

    public void setCoinName(String coinName) {
        this.coinName = coinName;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }
}
