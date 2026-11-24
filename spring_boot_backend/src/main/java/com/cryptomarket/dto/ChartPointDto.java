package com.cryptomarket.dto;

import java.io.Serializable;

public class ChartPointDto implements Serializable {
    private Long timestamp;
    private Double price;

    public ChartPointDto() {
    }

    public ChartPointDto(Long timestamp, Double price) {
        this.timestamp = timestamp;
        this.price = price;
    }

    public Long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Long timestamp) {
        this.timestamp = timestamp;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }
}
