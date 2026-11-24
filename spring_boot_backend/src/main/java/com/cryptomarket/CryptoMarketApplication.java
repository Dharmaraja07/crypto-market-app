package com.cryptomarket;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@EnableCaching
public class CryptoMarketApplication {

    public static void main(String[] args) {
        SpringApplication.run(CryptoMarketApplication.class, args);
    }
}
