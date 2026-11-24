import 'package:flutter/material.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';

class TimeRangeSelector extends StatelessWidget {
  final String selectedRange;
  final ValueChanged<String> onRangeSelected;

  static const List<Map<String, String>> ranges = [
    {'label': '1H', 'value': '1h'},
    {'label': '24H', 'value': '24h'},
    {'label': '7D', 'value': '7d'},
    {'label': '30D', 'value': '30d'},
    {'label': '90D', 'value': '90d'},
    {'label': '1Y', 'value': '1y'},
  ];

  const TimeRangeSelector({
    super.key,
    required this.selectedRange,
    required this.onRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ranges.map((r) {
          final isSelected = selectedRange.toLowerCase() == r['value'];
          return Expanded(
            child: GestureDetector(
              onTap: () => onRangeSelected(r['value']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.cardLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(color: AppColors.primary.withAlpha(120), width: 1)
                      : null,
                ),
                child: Text(
                  r['label']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
