import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_market_app/features/market/data/models/market_overview_model.dart';
import 'package:crypto_market_app/features/market/data/repositories/market_repository.dart';
import 'package:crypto_market_app/features/market/presentation/bloc/market_bloc.dart';
import 'package:crypto_market_app/features/market/presentation/bloc/market_event.dart';
import 'package:crypto_market_app/features/market/presentation/bloc/market_state.dart';

import 'package:crypto_market_app/features/coins/data/models/coin_summary_model.dart';
import 'package:crypto_market_app/features/coins/data/repositories/coin_repository.dart';
import 'package:crypto_market_app/features/coins/presentation/bloc/coins_bloc.dart';
import 'package:crypto_market_app/features/coins/presentation/bloc/coins_event.dart';
import 'package:crypto_market_app/features/coins/presentation/bloc/coins_state.dart';

import 'package:crypto_market_app/features/charts/data/models/chart_data_model.dart';
import 'package:crypto_market_app/features/charts/presentation/bloc/chart_bloc.dart';
import 'package:crypto_market_app/features/charts/presentation/bloc/chart_event.dart';
import 'package:crypto_market_app/features/charts/presentation/bloc/chart_state.dart';

import 'package:crypto_market_app/features/watchlist/data/models/watchlist_item_model.dart';
import 'package:crypto_market_app/features/watchlist/data/repositories/watchlist_repository.dart';
import 'package:crypto_market_app/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:crypto_market_app/features/watchlist/presentation/bloc/watchlist_event.dart';
import 'package:crypto_market_app/features/watchlist/presentation/bloc/watchlist_state.dart';

class MockMarketRepository extends Mock implements MarketRepository {}
class MockCoinRepository extends Mock implements CoinRepository {}
class MockWatchlistRepository extends Mock implements WatchlistRepository {}

void main() {
  late MockMarketRepository mockMarketRepo;
  late MockCoinRepository mockCoinRepo;
  late MockWatchlistRepository mockWatchlistRepo;

  setUp(() {
    mockMarketRepo = MockMarketRepository();
    mockCoinRepo = MockCoinRepository();
    mockWatchlistRepo = MockWatchlistRepository();
  });

  const testOverview = MarketOverviewModel(
    totalMarketCapUsd: 2500000000000.0,
    totalVolume24hUsd: 80000000000.0,
    marketCapChange24hPercentage: 2.1,
    btcDominancePercentage: 55.0,
    ethDominancePercentage: 15.0,
    activeCryptocurrencies: 14000,
    ongoingIcos: 20,
    marketsCount: 1000,
    updatedAt: '2024-11-01',
  );

  const testCoin = CoinSummaryModel(
    id: 'bitcoin',
    symbol: 'BTC',
    name: 'Bitcoin',
    currentPrice: 65000.0,
    priceChangePercentage24h: 2.5,
    marketCapRank: 1,
  );

  group('MarketBloc Tests', () {
    blocTest<MarketBloc, MarketState>(
      'emits [MarketLoading, MarketLoaded] when FetchMarketData is successful',
      build: () {
        when(() => mockMarketRepo.getMarketOverview()).thenAnswer((_) async => testOverview);
        when(() => mockMarketRepo.getTrendingCoins()).thenAnswer((_) async => [testCoin]);
        when(() => mockMarketRepo.getTopGainers(limit: any(named: 'limit'))).thenAnswer((_) async => [testCoin]);
        when(() => mockMarketRepo.getTopLosers(limit: any(named: 'limit'))).thenAnswer((_) async => [testCoin]);
        return MarketBloc(repository: mockMarketRepo);
      },
      act: (bloc) => bloc.add(const FetchMarketData()),
      expect: () => [
        isA<MarketLoading>(),
        isA<MarketLoaded>(),
      ],
    );
  });

  group('CoinsBloc Tests', () {
    blocTest<CoinsBloc, CoinsState>(
      'emits [CoinsLoading, CoinsLoaded] when FetchCoins succeeds',
      build: () {
        when(() => mockCoinRepo.getCoins(
          page: any(named: 'page'),
          perPage: any(named: 'perPage'),
          sortBy: any(named: 'sortBy'),
          order: any(named: 'order'),
          search: any(named: 'search'),
        )).thenAnswer((_) async => [testCoin]);
        return CoinsBloc(repository: mockCoinRepo);
      },
      act: (bloc) => bloc.add(const FetchCoins()),
      expect: () => [
        isA<CoinsLoading>(),
        isA<CoinsLoaded>().having((s) => s.coins.length, 'coins length', 1),
      ],
    );
  });

  group('ChartBloc Tests', () {
    const testChart = ChartDataModel(
      coinId: 'bitcoin',
      range: '7d',
      points: [ChartPointModel(timestamp: 1000, price: 65000)],
      minPrice: 64000,
      maxPrice: 66000,
      changePercentage: 1.5,
    );

    blocTest<ChartBloc, ChartState>(
      'emits [ChartLoading, ChartLoaded] when FetchChartData succeeds',
      build: () {
        when(() => mockCoinRepo.getCoinChart(any(), any())).thenAnswer((_) async => testChart);
        return ChartBloc(repository: mockCoinRepo);
      },
      act: (bloc) => bloc.add(const FetchChartData(coinId: 'bitcoin', range: '7d')),
      expect: () => [
        isA<ChartLoading>(),
        isA<ChartLoaded>().having((s) => s.chartData.coinId, 'coinId', 'bitcoin'),
      ],
    );
  });

  group('WatchlistBloc Tests', () {
    const testWatchlistItem = WatchlistItemModel(
      userId: 'default_user',
      coinId: 'bitcoin',
      coinSymbol: 'BTC',
      coinName: 'Bitcoin',
      currentPrice: 65000.0,
      priceChangePercentage24h: 2.5,
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'emits [WatchlistLoading, WatchlistLoaded] when FetchWatchlist succeeds',
      build: () {
        when(() => mockWatchlistRepo.getWatchlist(userId: any(named: 'userId')))
            .thenAnswer((_) async => [testWatchlistItem]);
        return WatchlistBloc(repository: mockWatchlistRepo);
      },
      act: (bloc) => bloc.add(const FetchWatchlist()),
      expect: () => [
        isA<WatchlistLoading>(),
        isA<WatchlistLoaded>().having((s) => s.items.length, 'items count', 1),
      ],
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'emits [WatchlistLoading, WatchlistEmpty] when Watchlist is empty',
      build: () {
        when(() => mockWatchlistRepo.getWatchlist(userId: any(named: 'userId')))
            .thenAnswer((_) async => []);
        return WatchlistBloc(repository: mockWatchlistRepo);
      },
      act: (bloc) => bloc.add(const FetchWatchlist()),
      expect: () => [
        isA<WatchlistLoading>(),
        isA<WatchlistEmpty>(),
      ],
    );
  });
}
