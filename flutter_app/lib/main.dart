import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/api_client.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/charts/presentation/bloc/chart_bloc.dart';
import 'features/coin_details/presentation/bloc/coin_details_bloc.dart';
import 'features/coins/data/repositories/coin_repository.dart';
import 'features/coins/presentation/bloc/coins_bloc.dart';
import 'features/market/data/repositories/market_repository.dart';
import 'features/market/presentation/bloc/market_bloc.dart';
import 'features/search/presentation/bloc/search_bloc.dart';
import 'features/statistics/presentation/bloc/statistics_bloc.dart';
import 'features/watchlist/data/datasources/watchlist_local_data_source.dart';
import 'features/watchlist/data/repositories/watchlist_repository.dart';
import 'features/watchlist/presentation/bloc/watchlist_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent google_fonts from attempting network requests at startup;
  // all Inter font files are bundled locally in assets/google_fonts/
  GoogleFonts.config.allowRuntimeFetching = false;

  final prefs = await SharedPreferences.getInstance();

  final apiClient = ApiClient(prefs: prefs);
  final watchlistLocalDataSource = WatchlistLocalDataSource(prefs: prefs);

  final marketRepository = MarketRepository(apiClient: apiClient);
  final coinRepository = CoinRepository(apiClient: apiClient);
  final watchlistRepository = WatchlistRepository(
    apiClient: apiClient,
    localDataSource: watchlistLocalDataSource,
  );

  runApp(
    CryptoMarketApp(
      apiClient: apiClient,
      marketRepository: marketRepository,
      coinRepository: coinRepository,
      watchlistRepository: watchlistRepository,
    ),
  );
}

class CryptoMarketApp extends StatefulWidget {
  final ApiClient apiClient;
  final MarketRepository marketRepository;
  final CoinRepository coinRepository;
  final WatchlistRepository watchlistRepository;

  const CryptoMarketApp({
    super.key,
    required this.apiClient,
    required this.marketRepository,
    required this.coinRepository,
    required this.watchlistRepository,
  });

  @override
  State<CryptoMarketApp> createState() => _CryptoMarketAppState();
}

class _CryptoMarketAppState extends State<CryptoMarketApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(widget.apiClient);
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: widget.marketRepository),
        RepositoryProvider.value(value: widget.coinRepository),
        RepositoryProvider.value(value: widget.watchlistRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MarketBloc(repository: widget.marketRepository),
          ),
          BlocProvider(
            create: (context) => CoinsBloc(repository: widget.coinRepository),
          ),
          BlocProvider(
            create: (context) => CoinDetailsBloc(
              coinRepository: widget.coinRepository,
              watchlistRepository: widget.watchlistRepository,
            ),
          ),
          BlocProvider(
            create: (context) => ChartBloc(repository: widget.coinRepository),
          ),
          BlocProvider(
            create: (context) => WatchlistBloc(repository: widget.watchlistRepository),
          ),
          BlocProvider(
            create: (context) => StatisticsBloc(repository: widget.marketRepository),
          ),
          BlocProvider(
            create: (context) => SearchBloc(repository: widget.coinRepository),
          ),
        ],
        child: MaterialApp.router(
          title: 'Crypto Market Research',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          routerConfig: _router,
        ),
      ),
    );
  }
}
