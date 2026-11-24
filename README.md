# Crypto Market Research Mobile Application & Spring Boot API

A cryptocurrency market research mobile application inspired by **CoinGecko**, built with a **Flutter** frontend and a **Java 17 / Spring Boot 3** backend.

---

## 1. Architecture Overview

### Layered Backend Architecture (Spring Boot 3)
```
[Flutter Mobile Client / Web / Desktop]
                     │  (HTTP / JSON REST)
                     ▼
          [Spring Web Controllers]
                     │
          [Service & Business Logic]
        ┌────────────┴─────────────┐
        ▼                          ▼
[Watchlist JPA Repo]      [CoinGecko Client Service]
        │                   ┌──────┴──────┐
        ▼                   ▼             ▼
  [PostgreSQL / H2]   [CoinGecko API]  [Mock Fallback Engine]
                      (Caffeine Cache) (Resilience & Offline)
```

- **Controller Layer**: REST controllers validating input parameters, managing CORS, and serving standardized `ApiResponse<T>` payloads.
- **Service Layer**: Business logic, cache management (`@Cacheable` with Caffeine 120s TTL), pagination, and sorting.
- **Client & Integration Layer**: Spring `RestClient` configured with timeouts and fallback mock data when CoinGecko limits (429) or is offline.
- **Persistence Layer**: Spring Data JPA with PostgreSQL production profile and H2 in-memory dev profile.
- **Documentation**: Springdoc OpenAPI / Swagger UI interactive API explorer.

---

### Clean Feature-Based Frontend Architecture (Flutter)
```
lib/
├── core/
│   ├── constants/       # AppColors, ApiConstants
│   ├── errors/          # Failures, Exceptions
│   ├── network/         # Dio HTTP ApiClient with interceptors
│   ├── router/          # GoRouter with StatefulShellRoute (Tabs)
│   ├── theme/           # Dark Obsidian financial theme + GoogleFonts
│   ├── utils/           # Formatters (currency, compact notation, %, supply)
│   └── widgets/         # CustomShimmer, CoinImage, ErrorView, EmptyStateView
├── features/
│   ├── market/          # Overview card, trending carousel, gainers/losers
│   ├── coins/           # Paginated coin listing, sorting, pull-to-refresh
│   ├── coin_details/    # Full stats, supply progress, ATH/ATL, description
│   ├── charts/          # Interactive FL Chart with 1h/24h/7d/30d/90d/1y touch
│   ├── watchlist/       # Local SharedPreferences cache + backend sync
│   ├── statistics/      # Dominance visual gauges, aggregates, market movers
│   ├── search/          # Instant debounce search delegate
│   └── settings/        # Backend URL configuration & connectivity ping
└── main.dart
```

---

## 2. Technology Stack

### Flutter Frontend
- **Framework**: Flutter 3.35+ & Dart 3.9+
- **State Management**: `flutter_bloc` / Cubit 8.1.6
- **Networking**: `dio` 5.11+
- **Routing**: `go_router` 14.8+
- **Charts**: `fl_chart` 0.69+
- **Local Persistence**: `shared_preferences` 2.5+
- **Typography & UI**: `google_fonts`, `shimmer`, `cached_network_image`
- **Testing**: `flutter_test`, `bloc_test`, `mocktail`

### Spring Boot Backend
- **Language / Runtime**: Java 17
- **Framework**: Spring Boot 3.3.4
- **Modules**: Spring Web, Spring Data JPA, Spring Validation, Spring Cache
- **Caching**: Caffeine Cache (120s TTL)
- **API Docs**: Springdoc OpenAPI / Swagger UI 2.6.0
- **Database**: PostgreSQL 16 (production), H2 (local development & testing)
- **HTTP Client**: Spring Web `RestClient` with timeout handling
- **Testing**: JUnit 5, Mockito, MockMvc

---

## 3. REST API Endpoints

All endpoints return a standardized envelope:
```json
{
  "success": true,
  "message": "Success",
  "data": { ... },
  "timestamp": 1732278000000
}
```

| Method | Endpoint | Query Parameters | Description |
|---|---|---|---|
| `GET` | `/api/v1/market/overview` | - | Global market cap, 24h volume, BTC/ETH dominance, active coins |
| `GET` | `/api/v1/coins` | `page`, `perPage`, `sortBy`, `order`, `search` | Paginated cryptocurrency listing with sorting & search filter |
| `GET` | `/api/v1/coins/{coinId}` | - | Comprehensive metadata, supplies, ATH, ATL, links for a coin |
| `GET` | `/api/v1/coins/{coinId}/chart` | `range` (`1h`, `24h`, `7d`, `30d`, `90d`, `1y`) | Time-series historical price chart data |
| `GET` | `/api/v1/coins/trending` | - | Trending and top-searched cryptocurrencies |
| `GET` | `/api/v1/coins/top-gainers` | `limit` (default 5) | Best performing cryptocurrencies by 24h percentage gain |
| `GET` | `/api/v1/coins/top-losers` | `limit` (default 5) | Worst performing cryptocurrencies by 24h percentage loss |
| `GET` | `/api/v1/watchlist` | `userId` | User's saved watchlist enriched with live price data |
| `POST` | `/api/v1/watchlist/{coinId}` | `userId` | Add a cryptocurrency to user's watchlist |
| `DELETE` | `/api/v1/watchlist/{coinId}` | `userId` | Remove a cryptocurrency from user's watchlist |
| `GET` | `/api/v1/watchlist/{coinId}/status` | `userId` | Check if a coin is in watchlist |
| `GET` | `/api/v1/search` | `query` | Search coins by name, symbol, or ID |

---

## 4. Setup and Execution Instructions

### A. Prerequisites
- **Java 17** (`java -version`)
- **Maven 3.8+** (`mvn -version`)
- **Flutter 3.24+** (`flutter --version`)
- **Docker & Docker Compose** (Optional, for running PostgreSQL in a container)

---

### B. Running the Backend

#### Option 1: Standalone (H2 In-Memory, zero setup)
```bash
cd crypto_market_app/spring_boot_backend
mvn clean spring-boot:run
```
The server will start on `http://localhost:8080`.
- **Swagger UI**: [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html)
- **OpenAPI JSON**: [http://localhost:8080/v3/api-docs](http://localhost:8080/v3/api-docs)
- **H2 Web Console**: [http://localhost:8080/h2-console](http://localhost:8080/h2-console) (JDBC URL: `jdbc:h2:mem:cryptodb`, User: `sa`, Password: empty)

#### Option 2: Docker Compose (PostgreSQL + Backend)
```bash
cd crypto_market_app
docker-compose up --build
```
This launches:
- PostgreSQL 16 on port `5432` with pre-executed `schema.sql`
- Spring Boot Backend on port `8080` configured with `SPRING_PROFILES_ACTIVE=postgres`

---

### C. Running the Flutter Application

1. Navigate to the flutter app directory:
```bash
cd crypto_market_app/flutter_app
```

2. Fetch dependencies:
```bash
flutter pub get
```

3. Run on your preferred target (macOS / Chrome / iOS / Android):
```bash
# Run on macOS desktop
flutter run -d macos

# Run on Chrome Web
flutter run -d chrome

# Run on Android Emulator
flutter run -d android
```

> **Note on Android Emulator**: Android emulators route `http://localhost:8080` to `http://10.0.2.2:8080`. `ApiConstants.defaultBaseUrl` automatically detects Android and sets the appropriate host. You can also customize the backend endpoint live inside **Settings > Base REST API URL**.

---

## 5. Testing Instructions

### Backend Tests (JUnit 5 & Mockito)
Runs Controller tests, Service tests, Repository tests, External API client tests, and Global Exception Handling tests:
```bash
cd crypto_market_app/spring_boot_backend
mvn test
```

### Flutter Tests (Unit, BLoC, Repository & Widget Tests)
Runs Model serialization tests, Formatters tests, BLoC event-state transition tests, Repository tests, and Widget interaction tests:
```bash
cd crypto_market_app/flutter_app
flutter test
```

---

## 6. Database Schema (PostgreSQL)

Located in `spring_boot_backend/src/main/resources/schema.sql`:

```sql
CREATE TABLE IF NOT EXISTS watchlist_items (
    id BIGSERIAL PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    coin_id VARCHAR(100) NOT NULL,
    coin_symbol VARCHAR(20) NOT NULL,
    coin_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_user_coin UNIQUE (user_id, coin_id)
);

CREATE INDEX IF NOT EXISTS idx_watchlist_user_id ON watchlist_items(user_id);
```

---

## 7. Resilience & Rate-Limiting Design

CoinGecko's free public tier limits calls to 10–30 req/min and often responds with HTTP 429.
The application implements multi-tier resilience:
1. **Caffeine In-Memory Cache**: All coin lists, overviews, charts, and details are cached for 120 seconds to minimize external API calls.
2. **Timeout Handling**: RestClient has strict 10s connect and read timeouts.
3. **Graceful Fallback Mock Data Engine**: If CoinGecko rate-limits, errors, or the network is offline, the backend seamlessly falls back to high-fidelity cryptocurrency market data so the mobile UI never displays broken states.
4. **Offline Local Watchlist**: The Flutter app persists the user's watchlist in `SharedPreferences` locally and synchronizes bidirectionally with the backend whenever connectivity is available.
