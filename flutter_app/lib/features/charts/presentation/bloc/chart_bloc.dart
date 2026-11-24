import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_market_app/features/coins/data/repositories/coin_repository.dart';
import 'chart_event.dart';
import 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final CoinRepository repository;
  String _currentCoinId = '';

  ChartBloc({required this.repository}) : super(ChartInitial()) {
    on<FetchChartData>(_onFetchChartData);
    on<ChangeTimeRange>(_onChangeTimeRange);
  }

  Future<void> _onFetchChartData(
    FetchChartData event,
    Emitter<ChartState> emit,
  ) async {
    _currentCoinId = event.coinId;
    emit(ChartLoading(activeRange: event.range));

    try {
      final chart = await repository.getCoinChart(event.coinId, event.range);
      emit(ChartLoaded(
        chartData: chart,
        activeRange: event.range,
      ));
    } catch (e) {
      emit(ChartError(
        e.toString().replaceAll('ServerException: ', ''),
        activeRange: event.range,
      ));
    }
  }

  Future<void> _onChangeTimeRange(
    ChangeTimeRange event,
    Emitter<ChartState> emit,
  ) async {
    if (_currentCoinId.isEmpty) return;

    emit(ChartLoading(activeRange: event.range));

    try {
      final chart = await repository.getCoinChart(_currentCoinId, event.range);
      emit(ChartLoaded(
        chartData: chart,
        activeRange: event.range,
      ));
    } catch (e) {
      emit(ChartError(
        e.toString().replaceAll('ServerException: ', ''),
        activeRange: event.range,
      ));
    }
  }
}
