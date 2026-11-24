import 'package:flutter/material.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';

class FilterSortDialog extends StatefulWidget {
  final String currentSortBy;
  final String currentOrder;
  final Function(String sortBy, String order) onApply;

  const FilterSortDialog({
    super.key,
    required this.currentSortBy,
    required this.currentOrder,
    required this.onApply,
  });

  @override
  State<FilterSortDialog> createState() => _FilterSortDialogState();
}

class _FilterSortDialogState extends State<FilterSortDialog> {
  late String _sortBy;
  late String _order;

  final List<Map<String, String>> sortOptions = [
    {'label': 'Market Capitalization', 'value': 'market_cap'},
    {'label': 'Price (USD)', 'value': 'price'},
    {'label': '24h Trading Volume', 'value': 'volume'},
    {'label': '24h Price Change %', 'value': 'percentage_change'},
  ];

  @override
  void initState() {
    super.initState();
    _sortBy = widget.currentSortBy;
    _order = widget.currentOrder;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sort & Filter Coins',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textMuted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Sort By',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sortOptions.map((opt) {
              final isSelected = _sortBy == opt['value'];
              return ChoiceChip(
                label: Text(opt['label']!),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) setState(() => _sortBy = opt['value']!);
                },
                selectedColor: AppColors.primary.withAlpha(50),
                backgroundColor: AppColors.card,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Direction',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _directionButton('High to Low (Desc)', 'desc'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _directionButton('Low to High (Asc)', 'asc'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_sortBy, _order);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Apply Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _directionButton(String label, String orderValue) {
    final isSelected = _order == orderValue;

    return GestureDetector(
      onTap: () => setState(() => _order = orderValue),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withAlpha(40) : AppColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
