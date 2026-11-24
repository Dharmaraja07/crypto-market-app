package com.cryptomarket.dto;

import java.io.Serializable;
import java.util.List;

public class CoinDetailDto implements Serializable {
    private String id;
    private String symbol;
    private String name;
    private String image;
    private String description;
    private Double currentPrice;
    private Double marketCap;
    private Integer marketCapRank;
    private Double fullyDilutedValuation;
    private Double totalVolume;
    private Double high24h;
    private Double low24h;
    private Double priceChange24h;
    private Double priceChangePercentage24h;
    private Double priceChangePercentage7d;
    private Double priceChangePercentage30d;
    private Double circulatingSupply;
    private Double totalSupply;
    private Double maxSupply;
    private Double ath;
    private Double athChangePercentage;
    private String athDate;
    private Double atl;
    private Double atlChangePercentage;
    private String atlDate;
    private String homepage;
    private String blockchainSite;
    private String genesisDate;
    private Double sentimentVotesUpPercentage;
    private Double sentimentVotesDownPercentage;
    private List<Double> sparklineIn7d;
    private String lastUpdated;

    public CoinDetailDto() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Double getCurrentPrice() {
        return currentPrice;
    }

    public void setCurrentPrice(Double currentPrice) {
        this.currentPrice = currentPrice;
    }

    public Double getMarketCap() {
        return marketCap;
    }

    public void setMarketCap(Double marketCap) {
        this.marketCap = marketCap;
    }

    public Integer getMarketCapRank() {
        return marketCapRank;
    }

    public void setMarketCapRank(Integer marketCapRank) {
        this.marketCapRank = marketCapRank;
    }

    public Double getFullyDilutedValuation() {
        return fullyDilutedValuation;
    }

    public void setFullyDilutedValuation(Double fullyDilutedValuation) {
        this.fullyDilutedValuation = fullyDilutedValuation;
    }

    public Double getTotalVolume() {
        return totalVolume;
    }

    public void setTotalVolume(Double totalVolume) {
        this.totalVolume = totalVolume;
    }

    public Double getHigh24h() {
        return high24h;
    }

    public void setHigh24h(Double high24h) {
        this.high24h = high24h;
    }

    public Double getLow24h() {
        return low24h;
    }

    public void setLow24h(Double low24h) {
        this.low24h = low24h;
    }

    public Double getPriceChange24h() {
        return priceChange24h;
    }

    public void setPriceChange24h(Double priceChange24h) {
        this.priceChange24h = priceChange24h;
    }

    public Double getPriceChangePercentage24h() {
        return priceChangePercentage24h;
    }

    public void setPriceChangePercentage24h(Double priceChangePercentage24h) {
        this.priceChangePercentage24h = priceChangePercentage24h;
    }

    public Double getPriceChangePercentage7d() {
        return priceChangePercentage7d;
    }

    public void setPriceChangePercentage7d(Double priceChangePercentage7d) {
        this.priceChangePercentage7d = priceChangePercentage7d;
    }

    public Double getPriceChangePercentage30d() {
        return priceChangePercentage30d;
    }

    public void setPriceChangePercentage30d(Double priceChangePercentage30d) {
        this.priceChangePercentage30d = priceChangePercentage30d;
    }

    public Double getCirculatingSupply() {
        return circulatingSupply;
    }

    public void setCirculatingSupply(Double circulatingSupply) {
        this.circulatingSupply = circulatingSupply;
    }

    public Double getTotalSupply() {
        return totalSupply;
    }

    public void setTotalSupply(Double totalSupply) {
        this.totalSupply = totalSupply;
    }

    public Double getMaxSupply() {
        return maxSupply;
    }

    public void setMaxSupply(Double maxSupply) {
        this.maxSupply = maxSupply;
    }

    public Double getAth() {
        return ath;
    }

    public void setAth(Double ath) {
        this.ath = ath;
    }

    public Double getAthChangePercentage() {
        return athChangePercentage;
    }

    public void setAthChangePercentage(Double athChangePercentage) {
        this.athChangePercentage = athChangePercentage;
    }

    public String getAthDate() {
        return athDate;
    }

    public void setAthDate(String athDate) {
        this.athDate = athDate;
    }

    public Double getAtl() {
        return atl;
    }

    public void setAtl(Double atl) {
        this.atl = atl;
    }

    public Double getAtlChangePercentage() {
        return atlChangePercentage;
    }

    public void setAtlChangePercentage(Double atlChangePercentage) {
        this.atlChangePercentage = atlChangePercentage;
    }

    public String getAtlDate() {
        return atlDate;
    }

    public void setAtlDate(String atlDate) {
        this.atlDate = atlDate;
    }

    public String getHomepage() {
        return homepage;
    }

    public void setHomepage(String homepage) {
        this.homepage = homepage;
    }

    public String getBlockchainSite() {
        return blockchainSite;
    }

    public void setBlockchainSite(String blockchainSite) {
        this.blockchainSite = blockchainSite;
    }

    public String getGenesisDate() {
        return genesisDate;
    }

    public void setGenesisDate(String genesisDate) {
        this.genesisDate = genesisDate;
    }

    public Double getSentimentVotesUpPercentage() {
        return sentimentVotesUpPercentage;
    }

    public void setSentimentVotesUpPercentage(Double sentimentVotesUpPercentage) {
        this.sentimentVotesUpPercentage = sentimentVotesUpPercentage;
    }

    public Double getSentimentVotesDownPercentage() {
        return sentimentVotesDownPercentage;
    }

    public void setSentimentVotesDownPercentage(Double sentimentVotesDownPercentage) {
        this.sentimentVotesDownPercentage = sentimentVotesDownPercentage;
    }

    public List<Double> getSparklineIn7d() {
        return sparklineIn7d;
    }

    public void setSparklineIn7d(List<Double> sparklineIn7d) {
        this.sparklineIn7d = sparklineIn7d;
    }

    public String getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(String lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
}
