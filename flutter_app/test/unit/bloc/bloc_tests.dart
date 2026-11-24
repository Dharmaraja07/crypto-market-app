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

import 'package:crypto_market_app/features/coin_details/data/models/coin_detail_model.dart';
import 'package:crypto_market_app/features/coin_details/presentation/bloc/coin_details_bloc.dart';
import 'package:crypto_market_app/features/coin_details/presentation/bloc/coin_details_event.dart';
import 'package:crypto_market_app/features/coin_details/presentation/bloc/coin_details_state.dart';

class MockMarketRepository extends Mock implements MarketRepository {}
class MockCoinRepository extends Mock implements CoinRepository {}
class MockWatchlistRepository extends Mock implements WatchlistRepository {}

void main() {
  late MockMarketRepository mockMarketRepo;
  late MockCoinRepository mockCoinRepo;
  late MockWatchlistRepository mockWatchlistRepo;

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

  setUpAll(() {
    registerFallbackValue(testCoin);
  });

  setUp(() {
    mockMarketRepo = MockMarketRepository();
    mockCoinRepo = MockCoinRepository();
    mockWatchlistRepo = MockWatchlistRepository();
    when(() => mockWatchlistRepo.watchlistStream).thenAnswer((_) => const Stream.empty());
  });

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

    blocTest<WatchlistBloc, WatchlistState>(
      'immediately emits WatchlistEmpty optimistically when RemoveCoinFromWatchlist is called',
      build: () {
        when(() => mockWatchlistRepo.removeFromWatchlist(coinId: any(named: 'coinId')))
            .thenAnswer((_) async {});
        return WatchlistBloc(repository: mockWatchlistRepo);
      },
      seed: () => const WatchlistLoaded([testWatchlistItem]),
      act: (bloc) => bloc.add(const RemoveCoinFromWatchlist('bitcoin')),
      expect: () => [
        isA<WatchlistEmpty>(),
      ],
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'immediately emits WatchlistLoaded optimistically when AddCoinToWatchlist is called',
      build: () {
        when(() => mockWatchlistRepo.addToWatchlist(
          coinId: any(named: 'coinId'),
          coin: any(named: 'coin'),
        )).thenAnswer((_) async => testWatchlistItem);
        return WatchlistBloc(repository: mockWatchlistRepo);
      },
      act: (bloc) => bloc.add(const AddCoinToWatchlist(testCoin)),
      expect: () => [
        isA<WatchlistLoaded>().having((s) => s.items.first.coinId, 'coinId', 'bitcoin'),
      ],
    );
  });

  group('CoinDetailsBloc Tests', () {
    const testDetail = CoinDetailModel(
      id: 'bitcoin',
      symbol: 'BTC',
      name: 'Bitcoin',
      currentPrice: 65000.0,
      priceChangePercentage24h: 2.5,
      marketCapRank: 1,
    );

    blocTest<CoinDetailsBloc, CoinDetailsState>(
      'emits [CoinDetailsLoading, CoinDetailsLoaded] when FetchCoinDetail succeeds',
      build: () {
        when(() => mockCoinRepo.getCoinDetail('bitcoin')).thenAnswer((_) async => testDetail);
        when(() => mockWatchlistRepo.isInWatchlist('bitcoin')).thenAnswer((_) async => true);
        return CoinDetailsBloc(
          coinRepository: mockCoinRepo,
          watchlistRepository: mockWatchlistRepo,
        );
      },
      act: (bloc) => bloc.add(const FetchCoinDetail('bitcoin')),
      expect: () => [
        isA<CoinDetailsLoading>(),
        isA<CoinDetailsLoaded>().having((s) => s.isInWatchlist, 'isInWatchlist', true),
      ],
    );

    blocTest<CoinDetailsBloc, CoinDetailsState>(
      'toggles isInWatchlist immediately when ToggleWatchlistStatus is called',
      build: () {
        when(() => mockWatchlistRepo.removeFromWatchlist(coinId: 'bitcoin')).thenAnswer((_) async {});
        return CoinDetailsBloc(
          coinRepository: mockCoinRepo,
          watchlistRepository: mockWatchlistRepo,
        );
      },
      seed: () => const CoinDetailsLoaded(coin: testDetail, isInWatchlist: true),
      act: (bloc) => bloc.add(const ToggleWatchlistStatus(testDetail)),
      expect: () => [
        isA<CoinDetailsLoaded>().having((s) => s.isInWatchlist, 'isInWatchlist', false),
      ],
    );

    blocTest<CoinDetailsBloc, CoinDetailsState>(
      'syncs isInWatchlist when WatchlistStatusSync is received',
      build: () {
        return CoinDetailsBloc(
          coinRepository: mockCoinRepo,
          watchlistRepository: mockWatchlistRepo,
        );
      },
      seed: () => const CoinDetailsLoaded(coin: testDetail, isInWatchlist: false),
      act: (bloc) => bloc.add(const WatchlistStatusSync([
        WatchlistItemModel(
          userId: 'default_user',
          coinId: 'bitcoin',
          coinSymbol: 'BTC',
          coinName: 'Bitcoin',
          currentPrice: 65000.0,
          priceChangePercentage24h: 2.5,
        ),
      ])),
      expect: () => [
        isA<CoinDetailsLoaded>().having((s) => s.isInWatchlist, 'isInWatchlist', true),
      ],
    );
  });
}
