import 'package:flutter/material.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';
import 'package:crypto_market_app/core/utils/formatters.dart';
import '../../data/models/coin_detail_model.dart';

class MarketStatsGrid extends StatelessWidget {
  final CoinDetailModel coin;

  const MarketStatsGrid({
    super.key,
    required this.coin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Market Statistics',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 2.2,
            children: [
              _statItem(
                label: 'Market Cap Rank',
                value: coin.marketCapRank != null ? '#${coin.marketCapRank}' : 'N/A',
                highlight: true,
              ),
              _statItem(
                label: 'Market Capitalization',
                value: Formatters.formatCurrency(coin.marketCap),
              ),
              _statItem(
                label: '24h Trading Volume',
                value: Formatters.formatCurrency(coin.totalVolume),
              ),
              _statItem(
                label: 'Fully Diluted Val. (FDV)',
                value: Formatters.formatCurrency(coin.fullyDilutedValuation),
              ),
              _statItem(
                label: '24h High',
                value: Formatters.formatPrice(coin.high24h),
              ),
              _statItem(
                label: '24h Low',
                value: Formatters.formatPrice(coin.low24h),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem({required String label, required String value, bool highlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: highlight ? AppColors.primary : AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
