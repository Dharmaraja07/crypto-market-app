import 'package:equatable/equatable.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();

  @override
  List<Object?> get props => [];
}

class FetchChartData extends ChartEvent {
  final String coinId;
  final String range;

  const FetchChartData({required this.coinId, this.range = '7d'});

  @override
  List<Object?> get props => [coinId, range];
}

class ChangeTimeRange extends ChartEvent {
  final String range;

  const ChangeTimeRange(this.range);

  @override
  List<Object?> get props => [range];
}
