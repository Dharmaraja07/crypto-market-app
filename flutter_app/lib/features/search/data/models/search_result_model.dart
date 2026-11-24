import 'package:equatable/equatable.dart';

class SearchResultModel extends Equatable {
  final String id;
  final String name;
  final String symbol;
  final int? marketCapRank;
  final String? thumb;
  final String? large;

  const SearchResultModel({
    required this.id,
    required this.name,
    required this.symbol,
    this.marketCapRank,
    this.thumb,
    this.large,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      symbol: json['symbol']?.toString().toUpperCase() ?? '',
      marketCapRank: (json['marketCapRank'] as num?)?.toInt(),
      thumb: json['thumb']?.toString(),
      large: json['large']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id, name, symbol, marketCapRank];
}
