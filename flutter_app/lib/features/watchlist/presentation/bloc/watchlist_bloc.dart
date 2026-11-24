import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/watchlist_repository.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistRepository repository;

  WatchlistBloc({required this.repository}) : super(WatchlistInitial()) {
    on<FetchWatchlist>(_onFetchWatchlist);
    on<AddCoinToWatchlist>(_onAddCoin);
    on<RemoveCoinFromWatchlist>(_onRemoveCoin);
  }

  Future<void> _onFetchWatchlist(
    FetchWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(WatchlistLoading());
    }

    try {
      final items = await repository.getWatchlist();
      if (items.isEmpty) {
        emit(WatchlistEmpty());
      } else {
        emit(WatchlistLoaded(items));
      }
    } catch (e) {
      emit(WatchlistError(e.toString().replaceAll('ServerException: ', '')));
    }
  }

  Future<void> _onAddCoin(
    AddCoinToWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    try {
      await repository.addToWatchlist(coinId: event.coin.id, coin: event.coin);
      add(const FetchWatchlist(isRefresh: true));
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  Future<void> _onRemoveCoin(
    RemoveCoinFromWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    try {
      await repository.removeFromWatchlist(coinId: event.coinId);
      add(const FetchWatchlist(isRefresh: true));
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }
}
