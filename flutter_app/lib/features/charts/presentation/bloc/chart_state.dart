import 'package:equatable/equatable.dart';
import '../../data/models/chart_data_model.dart';

abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object?> get props => [];
}

class ChartInitial extends ChartState {}

class ChartLoading extends ChartState {
  final String activeRange;

  const ChartLoading({this.activeRange = '7d'});

  @override
  List<Object?> get props => [activeRange];
}

class ChartLoaded extends ChartState {
  final ChartDataModel chartData;
  final String activeRange;
  final ChartPointModel? touchedPoint;

  const ChartLoaded({
    required this.chartData,
    required this.activeRange,
    this.touchedPoint,
  });

  ChartLoaded copyWith({
    ChartDataModel? chartData,
    String? activeRange,
    ChartPointModel? touchedPoint,
    bool clearTouched = false,
  }) {
    return ChartLoaded(
      chartData: chartData ?? this.chartData,
      activeRange: activeRange ?? this.activeRange,
      touchedPoint: clearTouched ? null : (touchedPoint ?? this.touchedPoint),
    );
  }

  @override
  List<Object?> get props => [chartData, activeRange, touchedPoint];
}

class ChartError extends ChartState {
  final String message;
  final String activeRange;

  const ChartError(this.message, {this.activeRange = '7d'});

  @override
  List<Object?> get props => [message, activeRange];
}
