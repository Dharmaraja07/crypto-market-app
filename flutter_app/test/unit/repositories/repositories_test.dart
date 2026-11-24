import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_market_app/core/network/api_client.dart';
import 'package:crypto_market_app/features/market/data/repositories/market_repository.dart';
import 'package:crypto_market_app/features/coins/data/repositories/coin_repository.dart';
import 'package:crypto_market_app/features/watchlist/data/datasources/watchlist_local_data_source.dart';
import 'package:crypto_market_app/features/watchlist/data/repositories/watchlist_repository.dart';

class MockApiClient extends Mock implements ApiClient {}
class MockWatchlistLocalDataSource extends Mock implements WatchlistLocalDataSource {}

void main() {
  late MockApiClient mockApiClient;
  late MockWatchlistLocalDataSource mockLocalDataSource;
  late MarketRepository marketRepo;
  late CoinRepository coinRepo;
  late WatchlistRepository watchlistRepo;

  setUp(() {
    mockApiClient = MockApiClient();
    mockLocalDataSource = MockWatchlistLocalDataSource();
    marketRepo = MarketRepository(apiClient: mockApiClient);
    coinRepo = CoinRepository(apiClient: mockApiClient);
    watchlistRepo = WatchlistRepository(
      apiClient: mockApiClient,
      localDataSource: mockLocalDataSource,
    );
  });

  group('MarketRepository Tests', () {
    test('getMarketOverview returns valid model', () async {
      when(() => mockApiClient.get(any())).thenAnswer((_) async => {
        'totalMarketCapUsd': 2600000000000.0,
        'totalVolume24hUsd': 85000000000.0,
        'marketCapChange24hPercentage': 1.85,
        'btcDominancePercentage': 56.2,
        'ethDominancePercentage': 15.1,
        'activeCryptocurrencies': 14500,
        'ongoingIcos': 30,
        'marketsCount': 1050,
        'updatedAt': '2024-11-01',
      });

      final result = await marketRepo.getMarketOverview();
      expect(result.totalMarketCapUsd, 2600000000000.0);
      expect(result.btcDominancePercentage, 56.2);
    });

    test('getTrendingCoins parses list', () async {
      when(() => mockApiClient.get(any())).thenAnswer((_) async => [
        {
          'id': 'solana',
          'symbol': 'SOL',
          'name': 'Solana',
          'currentPrice': 180.0,
          'priceChangePercentage24h': 5.0,
        }
      ]);

      final result = await marketRepo.getTrendingCoins();
      expect(result.length, 1);
      expect(result.first.id, 'solana');
    });
  });

  group('CoinRepository Tests', () {
    test('getCoins parses paginated list', () async {
      when(() => mockApiClient.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer((_) async => [
        {
          'id': 'bitcoin',
          'symbol': 'BTC',
          'name': 'Bitcoin',
          'currentPrice': 68000.0,
          'priceChangePercentage24h': 2.0,
          'marketCapRank': 1,
        }
      ]);

      final result = await coinRepo.getCoins(page: 1, perPage: 10);
      expect(result.length, 1);
      expect(result.first.id, 'bitcoin');
    });

    test('getCoinDetail parses full detail model', () async {
      when(() => mockApiClient.get(any())).thenAnswer((_) async => {
        'id': 'ethereum',
        'symbol': 'ETH',
        'name': 'Ethereum',
        'currentPrice': 3500.0,
        'priceChangePercentage24h': -1.2,
        'marketCapRank': 2,
        'circulatingSupply': 120000000.0,
        'totalSupply': 120000000.0,
      });

      final result = await coinRepo.getCoinDetail('ethereum');
      expect(result.id, 'ethereum');
      expect(result.symbol, 'ETH');
      expect(result.currentPrice, 3500.0);
    });
  });
}
