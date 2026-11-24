import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_market_app/features/market/data/repositories/market_repository.dart';
import 'statistics_event.dart';
import 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final MarketRepository repository;

  StatisticsBloc({required this.repository}) : super(StatisticsInitial()) {
    on<FetchStatistics>(_onFetchStatistics);
  }

  Future<void> _onFetchStatistics(
    FetchStatistics event,
    Emitter<StatisticsState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(StatisticsLoading());
    }

    try {
      final results = await Future.wait([
        repository.getMarketOverview(),
        repository.getTopGainers(limit: 5),
        repository.getTopLosers(limit: 5),
      ]);

      emit(StatisticsLoaded(
        overview: results[0] as dynamic,
        topGainers: results[1] as dynamic,
        topLosers: results[2] as dynamic,
      ));
    } catch (e) {
      emit(StatisticsError(e.toString().replaceAll('ServerException: ', '')));
    }
  }
}
