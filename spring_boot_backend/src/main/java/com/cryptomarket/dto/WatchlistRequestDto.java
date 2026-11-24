package com.cryptomarket.dto;

import jakarta.validation.constraints.Size;

public class WatchlistRequestDto {
    @Size(max = 100, message = "User ID must not exceed 100 characters")
    private String userId;

    public WatchlistRequestDto() {
    }

    public WatchlistRequestDto(String userId) {
        this.userId = userId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }
}
