package com.cryptomarket.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI cryptoMarketOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Crypto Market Research API")
                        .description("Production-grade cryptocurrency market data API inspired by CoinGecko")
                        .version("v1.0.0")
                        .contact(new Contact()
                                .name("Crypto Market Architecture Team")
                                .email("dev@cryptomarket.io"))
                        .license(new License().name("Apache 2.0").url("https://springdoc.org")))
                .servers(List.of(
                        new Server().url("http://localhost:8080").description("Local Development Server")
                ));
    }
}
