import 'package:flutter/material.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';
import 'package:crypto_market_app/core/utils/formatters.dart';
import '../../data/models/coin_detail_model.dart';

class SupplyProgressCard extends StatelessWidget {
  final CoinDetailModel coin;

  const SupplyProgressCard({
    super.key,
    required this.coin,
  });

  @override
  Widget build(BuildContext context) {
    double? progress;
    if (coin.circulatingSupply != null && coin.maxSupply != null && coin.maxSupply! > 0) {
      progress = (coin.circulatingSupply! / coin.maxSupply!).clamp(0.0, 1.0);
    }

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
            'Supply & History',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Supply Progress
          if (progress != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Circulating / Max Supply',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.surface,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 14),
          ],

          _rowItem('Circulating Supply', Formatters.formatSupply(coin.circulatingSupply, coin.symbol)),
          const SizedBox(height: 10),
          _rowItem('Total Supply', Formatters.formatSupply(coin.totalSupply, coin.symbol)),
          const SizedBox(height: 10),
          _rowItem('Max Supply', coin.maxSupply != null ? Formatters.formatSupply(coin.maxSupply, coin.symbol) : 'Infinite / Uncapped'),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: AppColors.divider),
          ),

          // All-Time High
          _athAtlRow(
            title: 'All-Time High (ATH)',
            price: coin.ath,
            changePct: coin.athChangePercentage,
            date: coin.athDate,
          ),
          const SizedBox(height: 14),

          // All-Time Low
          _athAtlRow(
            title: 'All-Time Low (ATL)',
            price: coin.atl,
            changePct: coin.atlChangePercentage,
            date: coin.atlDate,
          ),
        ],
      ),
    );
  }

  Widget _rowItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _athAtlRow({
    required String title,
    required double? price,
    required double? changePct,
    required String? date,
  }) {
    final isPositive = (changePct ?? 0) >= 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            if (date != null && date.isNotEmpty)
              Text(
                date.split('T').first,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Formatters.formatPrice(price),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            if (changePct != null)
              Text(
                Formatters.formatPercentage(changePct),
                style: TextStyle(
                  color: isPositive ? AppColors.gain : AppColors.loss,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
