import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';
import 'package:crypto_market_app/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:crypto_market_app/features/watchlist/presentation/bloc/watchlist_event.dart';

class MainNavigationShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.border, width: 0.8),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
            if (index == 2) {
              context.read<WatchlistBloc>().add(const FetchWatchlist(isRefresh: true));
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart_rounded),
              activeIcon: Icon(Icons.show_chart_rounded, color: AppColors.primary),
              label: 'Markets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted_rounded),
              activeIcon: Icon(Icons.format_list_bulleted_rounded, color: AppColors.primary),
              label: 'Coins',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_outline_rounded),
              activeIcon: Icon(Icons.star_rounded, color: Colors.amber),
              label: 'Watchlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_outline_rounded),
              activeIcon: Icon(Icons.pie_chart_rounded, color: AppColors.primary),
              label: 'Statistics',
            ),
          ],
        ),
      ),
    );
  }
}
