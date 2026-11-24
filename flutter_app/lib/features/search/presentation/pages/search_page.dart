import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';
import 'package:crypto_market_app/core/widgets/coin_image.dart';
import 'package:crypto_market_app/core/widgets/empty_state_view.dart';
import 'package:crypto_market_app/core/widgets/error_view.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search Bitcoin, Ethereum, SOL...',
              prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18, color: AppColors.textMuted),
                      onPressed: () {
                        _searchController.clear();
                        context.read<SearchBloc>().add(ClearSearch());
                      },
                    )
                  : null,
            ),
            onChanged: (val) {
              setState(() {});
              context.read<SearchBloc>().add(SearchQueryChanged(val));
            },
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return const Center(
              child: Text(
                'Type a coin name or symbol to search',
                style: TextStyle(color: AppColors.textMuted),
              ),
            );
          }

          if (state is SearchLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is SearchError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<SearchBloc>().add(SearchQueryChanged(_searchController.text)),
            );
          }

          if (state is SearchEmpty) {
            return EmptyStateView(
              title: 'No Cryptocurrencies Found',
              description: 'We couldn\'t find any coin matching "${state.query}". Check the spelling and try again.',
              icon: Icons.search_off_rounded,
            );
          }

          if (state is SearchLoaded) {
            return ListView.separated(
              itemCount: state.results.length,
              separatorBuilder: (context, index) => const Divider(color: AppColors.divider, height: 1),
              itemBuilder: (context, index) {
                final coin = state.results[index];

                return ListTile(
                  leading: CoinImage(imageUrl: coin.thumb ?? coin.large, symbol: coin.symbol, size: 36),
                  title: Text(
                    coin.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    coin.symbol,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  trailing: coin.marketCapRank != null
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            '#${coin.marketCapRank}',
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                          ),
                        )
                      : null,
                  onTap: () => context.push('/coin/${coin.id}'),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
