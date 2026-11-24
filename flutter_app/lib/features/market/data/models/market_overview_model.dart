import 'package:equatable/equatable.dart';

class MarketOverviewModel extends Equatable {
  final double totalMarketCapUsd;
  final double totalVolume24hUsd;
  final double marketCapChange24hPercentage;
  final double btcDominancePercentage;
  final double ethDominancePercentage;
  final int activeCryptocurrencies;
  final int ongoingIcos;
  final int marketsCount;
  final String updatedAt;

  const MarketOverviewModel({
    required this.totalMarketCapUsd,
    required this.totalVolume24hUsd,
    required this.marketCapChange24hPercentage,
    required this.btcDominancePercentage,
    required this.ethDominancePercentage,
    required this.activeCryptocurrencies,
    required this.ongoingIcos,
    required this.marketsCount,
    required this.updatedAt,
  });

  factory MarketOverviewModel.fromJson(Map<String, dynamic> json) {
    return MarketOverviewModel(
      totalMarketCapUsd: (json['totalMarketCapUsd'] as num?)?.toDouble() ?? 0.0,
      totalVolume24hUsd: (json['totalVolume24hUsd'] as num?)?.toDouble() ?? 0.0,
      marketCapChange24hPercentage: (json['marketCapChange24hPercentage'] as num?)?.toDouble() ?? 0.0,
      btcDominancePercentage: (json['btcDominancePercentage'] as num?)?.toDouble() ?? 0.0,
      ethDominancePercentage: (json['ethDominancePercentage'] as num?)?.toDouble() ?? 0.0,
      activeCryptocurrencies: (json['activeCryptocurrencies'] as num?)?.toInt() ?? 0,
      ongoingIcos: (json['ongoingIcos'] as num?)?.toInt() ?? 0,
      marketsCount: (json['marketsCount'] as num?)?.toInt() ?? 0,
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalMarketCapUsd': totalMarketCapUsd,
      'totalVolume24hUsd': totalVolume24hUsd,
      'marketCapChange24hPercentage': marketCapChange24hPercentage,
      'btcDominancePercentage': btcDominancePercentage,
      'ethDominancePercentage': ethDominancePercentage,
      'activeCryptocurrencies': activeCryptocurrencies,
      'ongoingIcos': ongoingIcos,
      'marketsCount': marketsCount,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
        totalMarketCapUsd,
        totalVolume24hUsd,
        marketCapChange24hPercentage,
        btcDominancePercentage,
        ethDominancePercentage,
        activeCryptocurrencies,
      ];
}
