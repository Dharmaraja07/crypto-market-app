import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/watchlist_item_model.dart';
import '../../data/repositories/watchlist_repository.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistRepository repository;
  StreamSubscription<List<WatchlistItemModel>>? _subscription;

  WatchlistBloc({required this.repository}) : super(WatchlistInitial()) {
    on<FetchWatchlist>(_onFetchWatchlist);
    on<AddCoinToWatchlist>(_onAddCoin);
    on<RemoveCoinFromWatchlist>(_onRemoveCoin);
    on<WatchlistUpdated>(_onWatchlistUpdated);

    _subscription = repository.watchlistStream.listen((items) {
      add(WatchlistUpdated(items));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void _onWatchlistUpdated(
    WatchlistUpdated event,
    Emitter<WatchlistState> emit,
  ) {
    if (event.items.isEmpty) {
      emit(WatchlistEmpty());
    } else {
      emit(WatchlistLoaded(List.unmodifiable(event.items)));
    }
  }

  Future<void> _onFetchWatchlist(
    FetchWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    if (!event.isRefresh && state is! WatchlistLoaded) {
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
      if (state is! WatchlistLoaded) {
        emit(WatchlistError(e.toString().replaceAll('ServerException: ', '')));
      }
    }
  }

  Future<void> _onAddCoin(
    AddCoinToWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    // Optimistic UI update immediately
    final localItem = WatchlistItemModel(
      userId: 'default_user',
      coinId: event.coin.id,
      coinSymbol: event.coin.symbol,
      coinName: event.coin.name,
      coinImage: event.coin.image,
      currentPrice: event.coin.currentPrice,
      priceChangePercentage24h: event.coin.priceChangePercentage24h,
      marketCap: event.coin.marketCap,
      marketCapRank: event.coin.marketCapRank,
      addedAt: DateTime.now().toIso8601String(),
    );

    List<WatchlistItemModel> currentItems = [];
    if (state is WatchlistLoaded) {
      currentItems = List.from((state as WatchlistLoaded).items);
    }
    if (!currentItems.any((e) => e.coinId == localItem.coinId)) {
      currentItems.insert(0, localItem);
      emit(WatchlistLoaded(currentItems));
    }

    try {
      await repository.addToWatchlist(coinId: event.coin.id, coin: event.coin);
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  Future<void> _onRemoveCoin(
    RemoveCoinFromWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    // Optimistic UI update immediately
    if (state is WatchlistLoaded) {
      final currentItems = (state as WatchlistLoaded).items;
      final updated = currentItems.where((e) => e.coinId != event.coinId).toList();
      if (updated.isEmpty) {
        emit(WatchlistEmpty());
      } else {
        emit(WatchlistLoaded(updated));
      }
    }

    try {
      await repository.removeFromWatchlist(coinId: event.coinId);
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }
}
