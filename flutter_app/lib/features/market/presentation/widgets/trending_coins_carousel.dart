import 'package:flutter/material.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';
import 'package:crypto_market_app/core/utils/formatters.dart';
import 'package:crypto_market_app/core/widgets/coin_image.dart';
import 'package:crypto_market_app/features/coins/data/models/coin_summary_model.dart';

class TrendingCoinsCarousel extends StatelessWidget {
  final List<CoinSummaryModel> trendingCoins;
  final ValueChanged<CoinSummaryModel> onCoinSelected;

  const TrendingCoinsCarousel({
    super.key,
    required this.trendingCoins,
    required this.onCoinSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (trendingCoins.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: const [
              Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 20),
              SizedBox(width: 6),
              Text(
                'Trending Coins',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: trendingCoins.length,
            itemBuilder: (context, index) {
              final coin = trendingCoins[index];
              final isPositive = coin.isPositive;

              return InkWell(
                onTap: () => onCoinSelected(coin),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 145,
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CoinImage(imageUrl: coin.image, symbol: coin.symbol, size: 28),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  coin.symbol,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  coin.name,
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (coin.currentPrice > 0)
                            Text(
                              Formatters.formatPrice(coin.currentPrice),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          const SizedBox(height: 2),
                          Row(
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
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
