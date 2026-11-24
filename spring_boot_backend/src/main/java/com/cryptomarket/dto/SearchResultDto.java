package com.cryptomarket.dto;

import java.io.Serializable;

public class SearchResultDto implements Serializable {
    private String id;
    private String name;
    private String symbol;
    private Integer marketCapRank;
    private String thumb;
    private String large;

    public SearchResultDto() {
    }

    public SearchResultDto(String id, String name, String symbol, Integer marketCapRank, String thumb, String large) {
        this.id = id;
        this.name = name;
        this.symbol = symbol;
        this.marketCapRank = marketCapRank;
        this.thumb = thumb;
        this.large = large;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public Integer getMarketCapRank() {
        return marketCapRank;
    }

    public void setMarketCapRank(Integer marketCapRank) {
        this.marketCapRank = marketCapRank;
    }

    public String getThumb() {
        return thumb;
    }

    public void setThumb(String thumb) {
        this.thumb = thumb;
    }

    public String getLarge() {
        return large;
    }

    public void setLarge(String large) {
        this.large = large;
    }
}
