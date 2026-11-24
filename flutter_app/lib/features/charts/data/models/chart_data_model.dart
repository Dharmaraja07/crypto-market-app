import 'package:equatable/equatable.dart';

class ChartPointModel extends Equatable {
  final int timestamp;
  final double price;

  const ChartPointModel({
    required this.timestamp,
    required this.price,
  });

  factory ChartPointModel.fromJson(Map<String, dynamic> json) {
    return ChartPointModel(
      timestamp: (json['timestamp'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'price': price,
      };

  @override
  List<Object?> get props => [timestamp, price];
}

class ChartDataModel extends Equatable {
  final String coinId;
  final String range;
  final List<ChartPointModel> points;
  final double minPrice;
  final double maxPrice;
  final double changePercentage;

  const ChartDataModel({
    required this.coinId,
    required this.range,
    required this.points,
    required this.minPrice,
    required this.maxPrice,
    required this.changePercentage,
  });

  bool get isPositive => changePercentage >= 0;

  factory ChartDataModel.fromJson(Map<String, dynamic> json) {
    List<ChartPointModel> points = [];
    if (json['points'] is List) {
      points = (json['points'] as List)
          .map((e) => ChartPointModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return ChartDataModel(
      coinId: json['coinId']?.toString() ?? '',
      range: json['range']?.toString() ?? '7d',
      points: points,
      minPrice: (json['minPrice'] as num?)?.toDouble() ?? 0.0,
      maxPrice: (json['maxPrice'] as num?)?.toDouble() ?? 0.0,
      changePercentage: (json['changePercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [coinId, range, points.length, changePercentage];
}
