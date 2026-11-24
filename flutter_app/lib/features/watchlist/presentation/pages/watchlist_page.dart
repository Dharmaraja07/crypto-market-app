import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';
import 'package:crypto_market_app/core/widgets/custom_shimmer.dart';
import 'package:crypto_market_app/core/widgets/empty_state_view.dart';
import 'package:crypto_market_app/core/widgets/error_view.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';
import '../widgets/watchlist_coin_item.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistBloc>().add(const FetchWatchlist());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoading || state is WatchlistInitial) {
            return ListView.builder(
              itemCount: 4,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: CustomShimmer(width: double.infinity, height: 75, borderRadius: 16),
              ),
            );
          }

          if (state is WatchlistError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<WatchlistBloc>().add(const FetchWatchlist(isRefresh: true)),
            );
          }

          if (state is WatchlistEmpty) {
            return EmptyStateView(
              title: 'Your Watchlist is Empty',
              description: 'Track your favorite cryptocurrencies in real-time by tapping the star icon on any coin.',
              icon: Icons.star_border_rounded,
              action: ElevatedButton.icon(
                onPressed: () => context.go('/coins'),
                icon: const Icon(Icons.explore_outlined, size: 18),
                label: const Text('Explore Coins'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          }

          if (state is WatchlistLoaded) {
            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              onRefresh: () async {
                context.read<WatchlistBloc>().add(const FetchWatchlist(isRefresh: true));
              },
              child: ListView.builder(
                itemCount: state.items.length,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return WatchlistCoinItem(
                    item: item,
                    onTap: () => context.push('/coin/${item.coinId}'),
                    onRemove: () {
                      context.read<WatchlistBloc>().add(RemoveCoinFromWatchlist(item.coinId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.coinName} removed from Watchlist'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: AppColors.surface,
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
