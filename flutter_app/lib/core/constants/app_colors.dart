import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0B0E14);
  static const Color surface = Color(0xFF151A24);
  static const Color card = Color(0xFF1C2230);
  static const Color cardLight = Color(0xFF242C3D);
  static const Color border = Color(0xFF283044);
  static const Color divider = Color(0xFF1F2636);

  // Financial Accents
  static const Color gain = Color(0xFF16C784);
  static const Color gainLight = Color(0x1F16C784);
  static const Color loss = Color(0xFFEA3943);
  static const Color lossLight = Color(0x1FEA3943);

  // Brand Accents
  static const Color primary = Color(0xFF00C087);
  static const Color secondary = Color(0xFF3861FB);
  static const Color accentCyan = Color(0xFF00B4D8);
  static const Color btcGold = Color(0xFFF7931A);
  static const Color ethBlue = Color(0xFF627EEA);

  // Text
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textGain = Color(0xFF16C784);
  static const Color textLoss = Color(0xFFEA3943);

  // Chart Gradients
  static const List<Color> gainGradient = [
    Color(0x6616C784),
    Color(0x0016C784),
  ];

  static const List<Color> lossGradient = [
    Color(0x66EA3943),
    Color(0x00EA3943),
  ];
}
