import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_market_app/features/coins/data/repositories/coin_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final CoinRepository repository;

  SearchBloc({required this.repository}) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<ClearSearch>((event, emit) => emit(SearchInitial()));
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final q = event.query.trim();
    if (q.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final results = await repository.searchCoins(q);
      if (results.isEmpty) {
        emit(SearchEmpty(q));
      } else {
        emit(SearchLoaded(results: results, query: q));
      }
    } catch (e) {
      emit(SearchError(e.toString().replaceAll('ServerException: ', '')));
    }
  }
}
