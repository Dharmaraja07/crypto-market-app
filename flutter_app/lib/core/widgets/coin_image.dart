import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CoinImage extends StatelessWidget {
  final String? imageUrl;
  final String symbol;
  final double size;

  const CoinImage({
    super.key,
    required this.imageUrl,
    required this.symbol,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        imageBuilder: (context, imageProvider) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => _fallbackBadge(),
        errorWidget: (context, url, error) => _fallbackBadge(),
      );
    }
    return _fallbackBadge();
  }

  Widget _fallbackBadge() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        symbol.length > 3 ? symbol.substring(0, 3).toUpperCase() : symbol.toUpperCase(),
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: size * 0.32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
