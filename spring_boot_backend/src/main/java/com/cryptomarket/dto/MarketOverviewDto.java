package com.cryptomarket.dto;

import java.io.Serializable;

public class MarketOverviewDto implements Serializable {
    private Double totalMarketCapUsd;
    private Double totalVolume24hUsd;
    private Double marketCapChange24hPercentage;
    private Double btcDominancePercentage;
    private Double ethDominancePercentage;
    private Long activeCryptocurrencies;
    private Integer ongoingIcos;
    private Integer marketsCount;
    private String updatedAt;

    public MarketOverviewDto() {
    }

    public MarketOverviewDto(Double totalMarketCapUsd, Double totalVolume24hUsd,
                             Double marketCapChange24hPercentage, Double btcDominancePercentage,
                             Double ethDominancePercentage, Long activeCryptocurrencies,
                             Integer ongoingIcos, Integer marketsCount, String updatedAt) {
        this.totalMarketCapUsd = totalMarketCapUsd;
        this.totalVolume24hUsd = totalVolume24hUsd;
        this.marketCapChange24hPercentage = marketCapChange24hPercentage;
        this.btcDominancePercentage = btcDominancePercentage;
        this.ethDominancePercentage = ethDominancePercentage;
        this.activeCryptocurrencies = activeCryptocurrencies;
        this.ongoingIcos = ongoingIcos;
        this.marketsCount = marketsCount;
        this.updatedAt = updatedAt;
    }

    public Double getTotalMarketCapUsd() {
        return totalMarketCapUsd;
    }

    public void setTotalMarketCapUsd(Double totalMarketCapUsd) {
        this.totalMarketCapUsd = totalMarketCapUsd;
    }

    public Double getTotalVolume24hUsd() {
        return totalVolume24hUsd;
    }

    public void setTotalVolume24hUsd(Double totalVolume24hUsd) {
        this.totalVolume24hUsd = totalVolume24hUsd;
    }

    public Double getMarketCapChange24hPercentage() {
        return marketCapChange24hPercentage;
    }

    public void setMarketCapChange24hPercentage(Double marketCapChange24hPercentage) {
        this.marketCapChange24hPercentage = marketCapChange24hPercentage;
    }

    public Double getBtcDominancePercentage() {
        return btcDominancePercentage;
    }

    public void setBtcDominancePercentage(Double btcDominancePercentage) {
        this.btcDominancePercentage = btcDominancePercentage;
    }

    public Double getEthDominancePercentage() {
        return ethDominancePercentage;
    }

    public void setEthDominancePercentage(Double ethDominancePercentage) {
        this.ethDominancePercentage = ethDominancePercentage;
    }

    public Long getActiveCryptocurrencies() {
        return activeCryptocurrencies;
    }

    public void setActiveCryptocurrencies(Long activeCryptocurrencies) {
        this.activeCryptocurrencies = activeCryptocurrencies;
    }

    public Integer getOngoingIcos() {
        return ongoingIcos;
    }

    public void setOngoingIcos(Integer ongoingIcos) {
        this.ongoingIcos = ongoingIcos;
    }

    public Integer getMarketsCount() {
        return marketsCount;
    }

    public void setMarketsCount(Integer marketsCount) {
        this.marketsCount = marketsCount;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }
}
