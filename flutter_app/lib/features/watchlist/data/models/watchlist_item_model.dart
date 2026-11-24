import 'package:equatable/equatable.dart';

class WatchlistItemModel extends Equatable {
  final int? id;
  final String userId;
  final String coinId;
  final String coinSymbol;
  final String coinName;
  final String? coinImage;
  final double currentPrice;
  final double priceChangePercentage24h;
  final double? marketCap;
  final int? marketCapRank;
  final String? addedAt;

  const WatchlistItemModel({
    this.id,
    required this.userId,
    required this.coinId,
    required this.coinSymbol,
    required this.coinName,
    this.coinImage,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    this.marketCap,
    this.marketCapRank,
    this.addedAt,
  });

  bool get isPositive => priceChangePercentage24h >= 0;

  factory WatchlistItemModel.fromJson(Map<String, dynamic> json) {
    return WatchlistItemModel(
      id: (json['id'] as num?)?.toInt(),
      userId: json['userId']?.toString() ?? 'default_user',
      coinId: json['coinId']?.toString() ?? '',
      coinSymbol: json['coinSymbol']?.toString().toUpperCase() ?? '',
      coinName: json['coinName']?.toString() ?? '',
      coinImage: json['coinImage']?.toString(),
      currentPrice: (json['currentPrice'] as num?)?.toDouble() ?? 0.0,
      priceChangePercentage24h: (json['priceChangePercentage24h'] as num?)?.toDouble() ?? 0.0,
      marketCap: (json['marketCap'] as num?)?.toDouble(),
      marketCapRank: (json['marketCapRank'] as num?)?.toInt(),
      addedAt: json['addedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'coinId': coinId,
      'coinSymbol': coinSymbol,
      'coinName': coinName,
      'coinImage': coinImage,
      'currentPrice': currentPrice,
      'priceChangePercentage24h': priceChangePercentage24h,
      'marketCap': marketCap,
      'marketCapRank': marketCapRank,
      'addedAt': addedAt,
    };
  }

  @override
  List<Object?> get props => [coinId, userId, currentPrice, priceChangePercentage24h];
}
