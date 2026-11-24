import 'package:flutter/material.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';
import 'package:crypto_market_app/core/utils/formatters.dart';
import 'package:crypto_market_app/core/widgets/coin_image.dart';
import 'package:crypto_market_app/features/market/presentation/widgets/mini_sparkline_chart.dart';
import '../../data/models/coin_summary_model.dart';

class CoinListItem extends StatelessWidget {
  final CoinSummaryModel coin;
  final VoidCallback onTap;

  const CoinListItem({
    super.key,
    required this.coin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = coin.isPositive;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.divider, width: 0.8),
          ),
        ),
        child: Row(
          children: [
            // Rank
            SizedBox(
              width: 24,
              child: Text(
                coin.marketCapRank != null ? '${coin.marketCapRank}' : '-',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Logo
            CoinImage(imageUrl: coin.image, symbol: coin.symbol, size: 36),
            const SizedBox(width: 12),

            // Name & Symbol & Market Cap
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.border, width: 0.8),
                        ),
                        child: Text(
                          coin.symbol,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (coin.marketCap != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          Formatters.formatCompact(coin.marketCap),
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Mini Sparkline Chart
            if (coin.sparklineIn7d.isNotEmpty)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: MiniSparklineChart(
                    dataPoints: coin.sparklineIn7d,
                    isPositive: isPositive,
                    width: 60,
                    height: 32,
                  ),
                ),
              )
            else
              const Spacer(),

            // Price & 24h Change
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.formatPrice(coin.currentPrice),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                        size: 14,
                      ),
                      Text(
                        Formatters.formatPercentage(coin.priceChangePercentage24h),
                        style: TextStyle(
                          color: isPositive ? AppColors.gain : AppColors.loss,
                          fontSize: 11,
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
    );
  }
}
