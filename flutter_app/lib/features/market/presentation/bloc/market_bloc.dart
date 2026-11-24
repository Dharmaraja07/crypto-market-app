import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/market_repository.dart';
import 'market_event.dart';
import 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final MarketRepository repository;

  MarketBloc({required this.repository}) : super(MarketInitial()) {
    on<FetchMarketData>(_onFetchMarketData);
    on<RefreshMarketData>((event, emit) => add(const FetchMarketData(isRefresh: true)));
  }

  Future<void> _onFetchMarketData(
    FetchMarketData event,
    Emitter<MarketState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(MarketLoading());
    }

    try {
      final results = await Future.wait([
        repository.getMarketOverview(),
        repository.getTrendingCoins(),
        repository.getTopGainers(limit: 5),
        repository.getTopLosers(limit: 5),
      ]);

      emit(MarketLoaded(
        overview: results[0] as dynamic,
        trendingCoins: results[1] as dynamic,
        topGainers: results[2] as dynamic,
        topLosers: results[3] as dynamic,
      ));
    } catch (e) {
      emit(MarketError(e.toString().replaceAll('ServerException: ', '')));
    }
  }
}
