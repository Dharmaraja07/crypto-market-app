import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';
import 'package:crypto_market_app/core/utils/formatters.dart';
import 'package:crypto_market_app/core/widgets/custom_shimmer.dart';
import 'package:crypto_market_app/core/widgets/error_view.dart';
import '../bloc/statistics_bloc.dart';
import '../bloc/statistics_event.dart';
import '../bloc/statistics_state.dart';
import '../widgets/dominance_gauge.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    super.initState();
    context.read<StatisticsBloc>().add(const FetchStatistics());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Statistics', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<StatisticsBloc, StatisticsState>(
        builder: (context, state) {
          if (state is StatisticsLoading || state is StatisticsInitial) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: const [
                  CustomShimmer(width: double.infinity, height: 180, borderRadius: 16),
                  SizedBox(height: 16),
                  CustomShimmer(width: double.infinity, height: 140, borderRadius: 16),
                ],
              ),
            );
          }

          if (state is StatisticsError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<StatisticsBloc>().add(const FetchStatistics(isRefresh: true)),
            );
          }

          if (state is StatisticsLoaded) {
            final overview = state.overview;

            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              onRefresh: () async {
                context.read<StatisticsBloc>().add(const FetchStatistics(isRefresh: true));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dominance Visual Progress Bar
                    DominanceGauge(
                      btcDominance: overview.btcDominancePercentage,
                      ethDominance: overview.ethDominancePercentage,
                    ),

                    // Key Global Metrics
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
                            'Global Aggregates',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _metricRow('Total Cryptocurrency Market Cap', Formatters.formatCurrency(overview.totalMarketCapUsd)),
                          const Divider(color: AppColors.divider, height: 20),
                          _metricRow('Total 24h Trading Volume', Formatters.formatCurrency(overview.totalVolume24hUsd)),
                          const Divider(color: AppColors.divider, height: 20),
                          _metricRow('24h Market Cap Change', Formatters.formatPercentage(overview.marketCapChange24hPercentage)),
                          const Divider(color: AppColors.divider, height: 20),
                          _metricRow('Tracked Cryptocurrencies', overview.activeCryptocurrencies.toString()),
                          const Divider(color: AppColors.divider, height: 20),
                          _metricRow('Active Exchange Markets', overview.marketsCount.toString()),
                        ],
                      ),
                    ),

                    // Top Performers section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: const Text(
                        'Market Mover Leaders',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Gainers mini list
                    _buildPerformersCard('24h Top Gainers', state.topGainers, true),
                    const SizedBox(height: 8),
                    // Losers mini list
                    _buildPerformersCard('24h Top Losers', state.topLosers, false),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _metricRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformersCard(String title, List<dynamic> coins, bool isGainers) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
              Icon(
                isGainers ? Icons.trending_up : Icons.trending_down,
                color: isGainers ? AppColors.gain : AppColors.loss,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...coins.map((c) => InkWell(
                onTap: () => context.push('/coin/${c.id}'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Text(
                        c.name,
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        c.symbol,
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                      ),
                      const Spacer(),
                      Text(
                        Formatters.formatPrice(c.currentPrice),
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        Formatters.formatPercentage(c.priceChangePercentage24h),
                        style: TextStyle(
                          color: isGainers ? AppColors.gain : AppColors.loss,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
