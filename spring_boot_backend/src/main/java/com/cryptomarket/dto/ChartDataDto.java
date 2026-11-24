package com.cryptomarket.dto;

import java.io.Serializable;
import java.util.List;

public class ChartDataDto implements Serializable {
    private String coinId;
    private String range;
    private List<ChartPointDto> points;
    private Double minPrice;
    private Double maxPrice;
    private Double changePercentage;

    public ChartDataDto() {
    }

    public ChartDataDto(String coinId, String range, List<ChartPointDto> points,
                        Double minPrice, Double maxPrice, Double changePercentage) {
        this.coinId = coinId;
        this.range = range;
        this.points = points;
        this.minPrice = minPrice;
        this.maxPrice = maxPrice;
        this.changePercentage = changePercentage;
    }

    public String getCoinId() {
        return coinId;
    }

    public void setCoinId(String coinId) {
        this.coinId = coinId;
    }

    public String getRange() {
        return range;
    }

    public void setRange(String range) {
        this.range = range;
    }

    public List<ChartPointDto> getPoints() {
        return points;
    }

    public void setPoints(List<ChartPointDto> points) {
        this.points = points;
    }

    public Double getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(Double minPrice) {
        this.minPrice = minPrice;
    }

    public Double getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(Double maxPrice) {
        this.maxPrice = maxPrice;
    }

    public Double getChangePercentage() {
        return changePercentage;
    }

    public void setChangePercentage(Double changePercentage) {
        this.changePercentage = changePercentage;
    }
}
