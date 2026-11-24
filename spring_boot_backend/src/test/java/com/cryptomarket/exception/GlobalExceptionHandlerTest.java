package com.cryptomarket.exception;

import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockHttpServletRequest;

import static org.junit.jupiter.api.Assertions.*;

class GlobalExceptionHandlerTest {

    private final GlobalExceptionHandler handler = new GlobalExceptionHandler();

    @Test
    void handleResourceNotFound_Returns404() {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/api/v1/coins/fakecoin");
        ResourceNotFoundException ex = new ResourceNotFoundException("Coin not found");

        ResponseEntity<ErrorResponse> response = handler.handleResourceNotFound(ex, request);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals("Coin not found", response.getBody().getMessage());
        assertEquals("/api/v1/coins/fakecoin", response.getBody().getPath());
    }

    @Test
    void handleExternalApiException_ReturnsGatewayError() {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/api/v1/market/overview");
        ExternalApiException ex = new ExternalApiException("Rate limited by upstream provider", 429);

        ResponseEntity<ErrorResponse> response = handler.handleExternalApiException(ex, request);

        assertEquals(HttpStatus.TOO_MANY_REQUESTS, response.getStatusCode());
        assertNotNull(response.getBody());
        assertTrue(response.getBody().getMessage().contains("Rate limited"));
    }
}
