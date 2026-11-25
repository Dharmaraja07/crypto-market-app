import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';
import 'package:crypto_market_app/core/widgets/custom_shimmer.dart';
import 'package:crypto_market_app/core/widgets/empty_state_view.dart';
import 'package:crypto_market_app/core/widgets/error_view.dart';
import '../bloc/coins_bloc.dart';
import '../bloc/coins_event.dart';
import '../bloc/coins_state.dart';
import '../widgets/coin_list_item.dart';
import '../widgets/filter_sort_dialog.dart';

class CoinsListPage extends StatefulWidget {
  const CoinsListPage({super.key});

  @override
  State<CoinsListPage> createState() => _CoinsListPageState();
}

class _CoinsListPageState extends State<CoinsListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<CoinsBloc>().add(LoadMoreCoins());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cryptocurrencies', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'Sort & Filter',
            onPressed: () => _openSortDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search TextField
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search coin or symbol...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18, color: AppColors.textMuted),
                        onPressed: () {
                          _searchController.clear();
                          context.read<CoinsBloc>().add(const SearchFilterChanged(null));
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                setState(() {});
                context.read<CoinsBloc>().add(SearchFilterChanged(val));
              },
            ),
          ),

          // Active Sort & Filter Chips
          BlocBuilder<CoinsBloc, CoinsState>(
            builder: (context, state) {
              if (state is CoinsLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.swap_vert_rounded, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              '${state.sortBy.replaceAll('_', ' ').toUpperCase()} (${state.order.toUpperCase()})',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${state.coins.length} coins',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 6),

          // Coin List / Loading / Error
          Expanded(
            child: BlocBuilder<CoinsBloc, CoinsState>(
              builder: (context, state) {
                if (state is CoinsLoading || state is CoinsInitial) {
                  return ListView.builder(
                    itemCount: 10,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: CustomShimmer(width: double.infinity, height: 50, borderRadius: 12),
                    ),
                  );
                }

                if (state is CoinsError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: () => context.read<CoinsBloc>().add(const FetchCoins(isRefresh: true)),
                  );
                }

                if (state is CoinsEmpty) {
                  return EmptyStateView(
                    title: 'No Coins Found',
                    description: state.message,
                    icon: Icons.search_off_rounded,
                  );
                }

                if (state is CoinsLoaded) {
                  return RefreshIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    onRefresh: () async {
                      context.read<CoinsBloc>().add(const FetchCoins(isRefresh: true));
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.coins.length + (state.isFetchingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.coins.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                              ),
                            ),
                          );
                        }

                        final coin = state.coins[index];
                        return CoinListItem(
                          coin: coin,
                          index: index + 1,
                          onTap: () => context.push('/coin/${coin.id}'),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openSortDialog(BuildContext context) {
    final state = context.read<CoinsBloc>().state;
    String currentSortBy = 'market_cap';
    String currentOrder = 'desc';

    if (state is CoinsLoaded) {
      currentSortBy = state.sortBy;
      currentOrder = state.order;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FilterSortDialog(
        currentSortBy: currentSortBy,
        currentOrder: currentOrder,
        onApply: (sortBy, order) {
          context.read<CoinsBloc>().add(SortCoinsChanged(sortBy: sortBy, order: order));
        },
      ),
    );
  }
}
