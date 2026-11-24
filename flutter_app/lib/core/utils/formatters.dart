import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _currencyCompact = NumberFormat.compactCurrency(symbol: '\$');
  static final NumberFormat _percentFormat = NumberFormat('+0.00%;-0.00%');
  static final NumberFormat _standardCurrency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  static String formatCurrency(num? value) {
    if (value == null) return '\$0.00';
    if (value.abs() >= 1e9) {
      // Billions or Trillions
      if (value.abs() >= 1e12) {
        return '\$${(value / 1e12).toStringAsFixed(2)}T';
      }
      return '\$${(value / 1e9).toStringAsFixed(2)}B';
    } else if (value.abs() >= 1e6) {
      return '\$${(value / 1e6).toStringAsFixed(2)}M';
    } else if (value.abs() >= 1) {
      return _standardCurrency.format(value);
    } else if (value.abs() >= 0.0001) {
      return '\$${value.toStringAsFixed(4)}';
    } else if (value.abs() > 0) {
      return '\$${value.toStringAsFixed(6)}';
    }
    return '\$0.00';
  }

  static String formatPrice(num? value) {
    if (value == null) return '\$0.00';
    if (value >= 1000) {
      return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(value);
    } else if (value >= 1) {
      return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(value);
    } else if (value >= 0.0001) {
      return '\$${value.toStringAsFixed(4)}';
    } else if (value > 0) {
      return '\$${value.toStringAsFixed(6)}';
    }
    return '\$0.00';
  }

  static String formatCompact(num? value) {
    if (value == null) return '\$0';
    return _currencyCompact.format(value);
  }

  static String formatPercentage(num? percentage) {
    if (percentage == null) return '0.00%';
    final sign = percentage > 0 ? '+' : '';
    return '$sign${percentage.toStringAsFixed(2)}%';
  }

  static String formatSupply(num? supply, String? symbol) {
    if (supply == null) return 'N/A';
    final compact = NumberFormat.compact().format(supply);
    return '$compact ${symbol?.toUpperCase() ?? ''}'.trim();
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy HH:mm').format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
}
