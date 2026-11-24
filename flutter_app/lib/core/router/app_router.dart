import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../network/api_client.dart';
import 'package:crypto_market_app/features/main/presentation/pages/main_navigation_shell.dart';
import 'package:crypto_market_app/features/market/presentation/pages/home_market_page.dart';
import 'package:crypto_market_app/features/coins/presentation/pages/coins_list_page.dart';
import 'package:crypto_market_app/features/watchlist/presentation/pages/watchlist_page.dart';
import 'package:crypto_market_app/features/statistics/presentation/pages/statistics_page.dart';
import 'package:crypto_market_app/features/coin_details/presentation/pages/coin_details_page.dart';
import 'package:crypto_market_app/features/search/presentation/pages/search_page.dart';
import 'package:crypto_market_app/features/settings/presentation/pages/settings_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter(ApiClient apiClient) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/market',
      routes: [
        // Stateful Nested Shell for Bottom Navigation Tabs
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainNavigationShell(navigationShell: navigationShell);
          },
          branches: [
            // Tab 1: Markets / Home
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/market',
                  builder: (context, state) => const HomeMarketPage(),
                ),
              ],
            ),
            // Tab 2: All Coins
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/coins',
                  builder: (context, state) => const CoinsListPage(),
                ),
              ],
            ),
            // Tab 3: Watchlist
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/watchlist',
                  builder: (context, state) => const WatchlistPage(),
                ),
              ],
            ),
            // Tab 4: Statistics
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/statistics',
                  builder: (context, state) => const StatisticsPage(),
                ),
              ],
            ),
          ],
        ),

        // Detail and Modal Routes
        GoRoute(
          path: '/coin/:coinId',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final coinId = state.pathParameters['coinId'] ?? 'bitcoin';
            return CoinDetailsPage(coinId: coinId);
          },
        ),
        GoRoute(
          path: '/search',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const SearchPage(),
        ),
        GoRoute(
          path: '/settings',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => SettingsPage(apiClient: apiClient),
        ),
      ],
    );
  }
}
