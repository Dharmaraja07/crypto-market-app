import 'package:flutter/material.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';
import 'package:crypto_market_app/core/utils/formatters.dart';
import 'package:crypto_market_app/core/widgets/coin_image.dart';
import 'package:crypto_market_app/features/coins/data/models/coin_summary_model.dart';

class GainersLosersSection extends StatefulWidget {
  final List<CoinSummaryModel> gainers;
  final List<CoinSummaryModel> losers;
  final ValueChanged<CoinSummaryModel> onCoinSelected;

  const GainersLosersSection({
    super.key,
    required this.gainers,
    required this.losers,
    required this.onCoinSelected,
  });

  @override
  State<GainersLosersSection> createState() => _GainersLosersSectionState();
}

class _GainersLosersSectionState extends State<GainersLosersSection> {
  bool _showGainers = true;

  @override
  Widget build(BuildContext context) {
    final list = _showGainers ? widget.gainers : widget.losers;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
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
              _buildTabButton('Top Gainers', true, Icons.trending_up_rounded, AppColors.gain),
              const SizedBox(width: 8),
              _buildTabButton('Top Losers', false, Icons.trending_down_rounded, AppColors.loss),
            ],
          ),
          const SizedBox(height: 12),
          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('No data available', style: TextStyle(color: AppColors.textMuted)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length > 5 ? 5 : list.length,
              separatorBuilder: (context, index) => const Divider(color: AppColors.divider, height: 16),
              itemBuilder: (context, index) {
                final coin = list[index];
                final isPositive = coin.isPositive;

                return InkWell(
                  onTap: () => widget.onCoinSelected(coin),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        CoinImage(imageUrl: coin.image, symbol: coin.symbol, size: 30),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coin.name,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                coin.symbol,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              Formatters.formatPrice(coin.currentPrice),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isPositive ? AppColors.gainLight : AppColors.lossLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                Formatters.formatPercentage(coin.priceChangePercentage24h),
                                style: TextStyle(
                                  color: isPositive ? AppColors.gain : AppColors.loss,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, bool isGainersTab, IconData icon, Color activeColor) {
    final isSelected = _showGainers == isGainersTab;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _showGainers = isGainersTab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withAlpha(30) : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? activeColor.withAlpha(120) : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? activeColor : AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? activeColor : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
