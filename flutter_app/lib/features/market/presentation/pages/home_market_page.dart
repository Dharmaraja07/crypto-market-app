import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';
import 'package:crypto_market_app/core/widgets/custom_shimmer.dart';
import 'package:crypto_market_app/core/widgets/error_view.dart';
import 'package:crypto_market_app/features/coins/presentation/bloc/coins_bloc.dart';
import 'package:crypto_market_app/features/coins/presentation/bloc/coins_event.dart';
import 'package:crypto_market_app/features/coins/presentation/bloc/coins_state.dart';
import 'package:crypto_market_app/features/coins/presentation/widgets/coin_list_item.dart';
import '../bloc/market_bloc.dart';
import '../bloc/market_event.dart';
import '../bloc/market_state.dart';
import '../widgets/gainers_losers_section.dart';
import '../widgets/market_overview_card.dart';
import '../widgets/trending_coins_carousel.dart';

class HomeMarketPage extends StatefulWidget {
  const HomeMarketPage({super.key});

  @override
  State<HomeMarketPage> createState() => _HomeMarketPageState();
}

class _HomeMarketPageState extends State<HomeMarketPage> {
  @override
  void initState() {
    super.initState();
    context.read<MarketBloc>().add(const FetchMarketData());
    context.read<CoinsBloc>().add(const FetchCoins());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(35),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.currency_exchange_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('Crypto Market', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search Coins',
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          context.read<MarketBloc>().add(RefreshMarketData());
          context.read<CoinsBloc>().add(const FetchCoins(isRefresh: true));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Market Overview
              BlocBuilder<MarketBloc, MarketState>(
                builder: (context, state) {
                  if (state is MarketLoading || state is MarketInitial) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: const [
                          CustomShimmer(width: double.infinity, height: 160, borderRadius: 20),
                          SizedBox(height: 16),
                          CustomShimmer(width: double.infinity, height: 120, borderRadius: 16),
                        ],
                      ),
                    );
                  }

                  if (state is MarketError) {
                    return ErrorView(
                      message: state.message,
                      onRetry: () => context.read<MarketBloc>().add(const FetchMarketData()),
                    );
                  }

                  if (state is MarketLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MarketOverviewCard(overview: state.overview),
                        TrendingCoinsCarousel(
                          trendingCoins: state.trendingCoins,
                          onCoinSelected: (coin) => context.push('/coin/${coin.id}'),
                        ),
                        GainersLosersSection(
                          gainers: state.topGainers,
                          losers: state.topLosers,
                          onCoinSelected: (coin) => context.push('/coin/${coin.id}'),
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),

              // Cryptocurrency List Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Cryptocurrencies',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/coins'),
                      child: Row(
                        children: const [
                          Text('View All', style: TextStyle(color: AppColors.primary, fontSize: 13)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Coins Preview List
              BlocBuilder<CoinsBloc, CoinsState>(
                builder: (context, state) {
                  if (state is CoinsLoading || state is CoinsInitial) {
                    return Column(
                      children: List.generate(
                        5,
                        (index) => const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: CustomShimmer(width: double.infinity, height: 50, borderRadius: 12),
                        ),
                      ),
                    );
                  }

                  if (state is CoinsLoaded) {
                    final coins = state.coins.take(10).toList();
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: coins.length,
                      itemBuilder: (context, index) {
                        final coin = coins[index];
                        return CoinListItem(
                          coin: coin,
                          onTap: () => context.push('/coin/${coin.id}'),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
