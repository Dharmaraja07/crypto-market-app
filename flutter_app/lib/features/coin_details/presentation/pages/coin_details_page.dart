import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';
import 'package:crypto_market_app/core/utils/formatters.dart';
import 'package:crypto_market_app/core/widgets/coin_image.dart';
import 'package:crypto_market_app/core/widgets/custom_shimmer.dart';
import 'package:crypto_market_app/core/widgets/error_view.dart';
import 'package:crypto_market_app/features/charts/presentation/widgets/interactive_price_chart.dart';
import '../bloc/coin_details_bloc.dart';
import '../bloc/coin_details_event.dart';
import '../bloc/coin_details_state.dart';
import '../widgets/market_stats_grid.dart';
import '../widgets/supply_progress_card.dart';

class CoinDetailsPage extends StatefulWidget {
  final String coinId;

  const CoinDetailsPage({
    super.key,
    required this.coinId,
  });

  @override
  State<CoinDetailsPage> createState() => _CoinDetailsPageState();
}

class _CoinDetailsPageState extends State<CoinDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CoinDetailsBloc>().add(FetchCoinDetail(widget.coinId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CoinDetailsBloc, CoinDetailsState>(
          builder: (context, state) {
            if (state is CoinDetailsLoaded) {
              return Row(
                children: [
                  CoinImage(imageUrl: state.coin.image, symbol: state.coin.symbol, size: 26),
                  const SizedBox(width: 8),
                  Text(state.coin.name, overflow: TextOverflow.ellipsis),
                ],
              );
            }
            return const Text('Coin Details');
          },
        ),
        actions: [
          BlocBuilder<CoinDetailsBloc, CoinDetailsState>(
            builder: (context, state) {
              if (state is CoinDetailsLoaded) {
                return IconButton(
                  icon: Icon(
                    state.isInWatchlist ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: state.isInWatchlist ? Colors.amber : AppColors.textPrimary,
                    size: 26,
                  ),
                  tooltip: state.isInWatchlist ? 'Remove from Watchlist' : 'Add to Watchlist',
                  onPressed: () {
                    final wasInWatchlist = state.isInWatchlist;
                    context.read<CoinDetailsBloc>().add(ToggleWatchlistStatus(state.coin));
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          wasInWatchlist
                              ? '${state.coin.name} removed from Watchlist'
                              : '${state.coin.name} added to Watchlist',
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: AppColors.surface,
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<CoinDetailsBloc, CoinDetailsState>(
        builder: (context, state) {
          if (state is CoinDetailsLoading || state is CoinDetailsInitial) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CustomShimmer(width: 150, height: 32),
                  SizedBox(height: 12),
                  CustomShimmer(width: double.infinity, height: 260, borderRadius: 16),
                  SizedBox(height: 16),
                  CustomShimmer(width: double.infinity, height: 180, borderRadius: 16),
                ],
              ),
            );
          }

          if (state is CoinDetailsError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<CoinDetailsBloc>().add(FetchCoinDetail(widget.coinId)),
            );
          }

          if (state is CoinDetailsLoaded) {
            final coin = state.coin;
            final isPositive = coin.isPositive;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Price Header Banner
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CoinImage(imageUrl: coin.image, symbol: coin.symbol, size: 40),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      coin.name,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: Text(
                                        coin.symbol,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (coin.marketCapRank != null)
                                  Text(
                                    'Rank #${coin.marketCapRank}',
                                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              Formatters.formatPrice(coin.currentPrice),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              margin: const EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                color: isPositive ? AppColors.gainLight : AppColors.lossLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                    color: isPositive ? AppColors.gain : AppColors.loss,
                                    size: 16,
                                  ),
                                  Text(
                                    Formatters.formatPercentage(coin.priceChangePercentage24h),
                                    style: TextStyle(
                                      color: isPositive ? AppColors.gain : AppColors.loss,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Interactive Chart
                  InteractivePriceChart(coinId: coin.id),

                  // Market Stats Grid
                  MarketStatsGrid(coin: coin),

                  // Supply & History Card
                  SupplyProgressCard(coin: coin),

                  // About & Description
                  if (coin.description != null && coin.description!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _cleanHtml(coin.description!),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Links Card
                  if (coin.homepage != null || coin.blockchainSite != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Official Resources',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (coin.homepage != null && coin.homepage!.isNotEmpty)
                            _linkTile(
                              icon: Icons.language_rounded,
                              label: 'Official Website',
                              url: coin.homepage!,
                            ),
                          if (coin.blockchainSite != null && coin.blockchainSite!.isNotEmpty)
                            _linkTile(
                              icon: Icons.open_in_browser_rounded,
                              label: 'Blockchain Explorer',
                              url: coin.blockchainSite!,
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _linkTile({required IconData icon, required String label, required String url}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            url.replaceAll('https://', '').replaceAll('http://', '').split('/').first,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _cleanHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').trim();
  }
}
