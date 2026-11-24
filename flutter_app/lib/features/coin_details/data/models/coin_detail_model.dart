import 'package:equatable/equatable.dart';

class CoinDetailModel extends Equatable {
  final String id;
  final String symbol;
  final String name;
  final String? image;
  final String? description;
  final double currentPrice;
  final double? marketCap;
  final int? marketCapRank;
  final double? fullyDilutedValuation;
  final double? totalVolume;
  final double? high24h;
  final double? low24h;
  final double? priceChange24h;
  final double priceChangePercentage24h;
  final double? priceChangePercentage7d;
  final double? priceChangePercentage30d;
  final double? circulatingSupply;
  final double? totalSupply;
  final double? maxSupply;
  final double? ath;
  final double? athChangePercentage;
  final String? athDate;
  final double? atl;
  final double? atlChangePercentage;
  final String? atlDate;
  final String? homepage;
  final String? blockchainSite;
  final String? genesisDate;
  final double? sentimentVotesUpPercentage;
  final double? sentimentVotesDownPercentage;
  final List<double> sparklineIn7d;

  const CoinDetailModel({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    this.description,
    required this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.fullyDilutedValuation,
    this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChange24h,
    required this.priceChangePercentage24h,
    this.priceChangePercentage7d,
    this.priceChangePercentage30d,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.ath,
    this.athChangePercentage,
    this.athDate,
    this.atl,
    this.atlChangePercentage,
    this.atlDate,
    this.homepage,
    this.blockchainSite,
    this.genesisDate,
    this.sentimentVotesUpPercentage,
    this.sentimentVotesDownPercentage,
    this.sparklineIn7d = const [],
  });

  bool get isPositive => priceChangePercentage24h >= 0;

  factory CoinDetailModel.fromJson(Map<String, dynamic> json) {
    List<double> sparkline = [];
    if (json['sparklineIn7d'] is List) {
      sparkline = (json['sparklineIn7d'] as List)
          .map((e) => (e as num).toDouble())
          .toList();
    }

    return CoinDetailModel(
      id: json['id']?.toString() ?? '',
      symbol: json['symbol']?.toString().toUpperCase() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString(),
      description: json['description']?.toString(),
      currentPrice: (json['currentPrice'] as num?)?.toDouble() ?? 0.0,
      marketCap: (json['marketCap'] as num?)?.toDouble(),
      marketCapRank: (json['marketCapRank'] as num?)?.toInt(),
      fullyDilutedValuation: (json['fullyDilutedValuation'] as num?)?.toDouble(),
      totalVolume: (json['totalVolume'] as num?)?.toDouble(),
      high24h: (json['high24h'] as num?)?.toDouble(),
      low24h: (json['low24h'] as num?)?.toDouble(),
      priceChange24h: (json['priceChange24h'] as num?)?.toDouble(),
      priceChangePercentage24h: (json['priceChangePercentage24h'] as num?)?.toDouble() ?? 0.0,
      priceChangePercentage7d: (json['priceChangePercentage7d'] as num?)?.toDouble(),
      priceChangePercentage30d: (json['priceChangePercentage30d'] as num?)?.toDouble(),
      circulatingSupply: (json['circulatingSupply'] as num?)?.toDouble(),
      totalSupply: (json['totalSupply'] as num?)?.toDouble(),
      maxSupply: (json['maxSupply'] as num?)?.toDouble(),
      ath: (json['ath'] as num?)?.toDouble(),
      athChangePercentage: (json['athChangePercentage'] as num?)?.toDouble(),
      athDate: json['athDate']?.toString(),
      atl: (json['atl'] as num?)?.toDouble(),
      atlChangePercentage: (json['atlChangePercentage'] as num?)?.toDouble(),
      atlDate: json['atlDate']?.toString(),
      homepage: json['homepage']?.toString(),
      blockchainSite: json['blockchainSite']?.toString(),
      genesisDate: json['genesisDate']?.toString(),
      sentimentVotesUpPercentage: (json['sentimentVotesUpPercentage'] as num?)?.toDouble(),
      sentimentVotesDownPercentage: (json['sentimentVotesDownPercentage'] as num?)?.toDouble(),
      sparklineIn7d: sparkline,
    );
  }

  @override
  List<Object?> get props => [id, symbol, name, currentPrice, marketCapRank, priceChangePercentage24h];
}
