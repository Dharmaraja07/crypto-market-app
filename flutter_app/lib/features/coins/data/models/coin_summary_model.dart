import 'package:equatable/equatable.dart';

class CoinSummaryModel extends Equatable {
  final String id;
  final String symbol;
  final String name;
  final String? image;
  final double currentPrice;
  final double? marketCap;
  final int? marketCapRank;
  final double? totalVolume;
  final double? high24h;
  final double? low24h;
  final double? priceChange24h;
  final double priceChangePercentage24h;
  final List<double> sparklineIn7d;
  final String? lastUpdated;

  const CoinSummaryModel({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    required this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChange24h,
    required this.priceChangePercentage24h,
    this.sparklineIn7d = const [],
    this.lastUpdated,
  });

  bool get isPositive => priceChangePercentage24h >= 0;

  factory CoinSummaryModel.fromJson(Map<String, dynamic> json) {
    List<double> sparkline = [];
    if (json['sparklineIn7d'] is List) {
      sparkline = (json['sparklineIn7d'] as List)
          .map((e) => (e as num).toDouble())
          .toList();
    }

    return CoinSummaryModel(
      id: json['id']?.toString() ?? '',
      symbol: json['symbol']?.toString().toUpperCase() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString(),
      currentPrice: (json['currentPrice'] as num?)?.toDouble() ?? 0.0,
      marketCap: (json['marketCap'] as num?)?.toDouble(),
      marketCapRank: (json['marketCapRank'] as num?)?.toInt(),
      totalVolume: (json['totalVolume'] as num?)?.toDouble(),
      high24h: (json['high24h'] as num?)?.toDouble(),
      low24h: (json['low24h'] as num?)?.toDouble(),
      priceChange24h: (json['priceChange24h'] as num?)?.toDouble(),
      priceChangePercentage24h: (json['priceChangePercentage24h'] as num?)?.toDouble() ?? 0.0,
      sparklineIn7d: sparkline,
      lastUpdated: json['lastUpdated']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'currentPrice': currentPrice,
      'marketCap': marketCap,
      'marketCapRank': marketCapRank,
      'totalVolume': totalVolume,
      'high24h': high24h,
      'low24h': low24h,
      'priceChange24h': priceChange24h,
      'priceChangePercentage24h': priceChangePercentage24h,
      'sparklineIn7d': sparklineIn7d,
      'lastUpdated': lastUpdated,
    };
  }

  @override
  List<Object?> get props => [id, symbol, name, currentPrice, priceChangePercentage24h, marketCapRank];
}
