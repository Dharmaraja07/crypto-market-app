package com.cryptomarket.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.client.RestClient;

import java.time.Duration;

@Configuration
public class RestClientConfig {

    @Value("${crypto.coingecko.base-url:https://api.coingecko.com/api/v3}")
    private String baseUrl;

    @Value("${crypto.coingecko.api-key:}")
    private String apiKey;

    @Value("${crypto.coingecko.api-key-header:x-cg-demo-api-key}")
    private String apiKeyHeader;

    @Value("${crypto.coingecko.timeout-seconds:10}")
    private int timeoutSeconds;

    @Bean(name = "cgRestClient")
    public RestClient cgRestClient() {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout((int) Duration.ofSeconds(timeoutSeconds).toMillis());
        factory.setReadTimeout((int) Duration.ofSeconds(timeoutSeconds).toMillis());

        RestClient.Builder builder = RestClient.builder()
                .baseUrl(baseUrl)
                .requestFactory(factory)
                .defaultHeader("Accept", "application/json")
                .defaultHeader("User-Agent", "CryptoMarketApp/1.0");

        if (apiKey != null && !apiKey.trim().isEmpty()) {
            builder.defaultHeader(apiKeyHeader, apiKey.trim());
        }

        return builder.build();
    }
}
