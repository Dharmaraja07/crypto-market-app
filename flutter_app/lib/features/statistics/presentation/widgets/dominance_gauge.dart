import 'package:flutter/material.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';

class DominanceGauge extends StatelessWidget {
  final double btcDominance;
  final double ethDominance;

  const DominanceGauge({
    super.key,
    required this.btcDominance,
    required this.ethDominance,
  });

  @override
  Widget build(BuildContext context) {
    final othersDominance = (100.0 - btcDominance - ethDominance).clamp(0.0, 100.0);

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
            'Market Dominance',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  Expanded(
                    flex: btcDominance.toInt(),
                    child: Container(color: AppColors.btcGold),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: ethDominance.toInt(),
                    child: Container(color: AppColors.ethBlue),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: othersDominance.toInt(),
                    child: Container(color: AppColors.accentCyan),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _legendItem('Bitcoin', '${btcDominance.toStringAsFixed(1)}%', AppColors.btcGold),
              _legendItem('Ethereum', '${ethDominance.toStringAsFixed(1)}%', AppColors.ethBlue),
              _legendItem('Others', '${othersDominance.toStringAsFixed(1)}%', AppColors.accentCyan),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String name, String percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            Text(
              percentage,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
