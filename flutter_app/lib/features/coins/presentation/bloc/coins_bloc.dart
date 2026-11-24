import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/coin_repository.dart';
import 'coins_event.dart';
import 'coins_state.dart';

class CoinsBloc extends Bloc<CoinsEvent, CoinsState> {
  final CoinRepository repository;
  static const int _perPage = 20;

  CoinsBloc({required this.repository}) : super(CoinsInitial()) {
    on<FetchCoins>(_onFetchCoins);
    on<LoadMoreCoins>(_onLoadMoreCoins);
    on<SortCoinsChanged>(_onSortCoinsChanged);
    on<SearchFilterChanged>(_onSearchFilterChanged);
  }

  Future<void> _onFetchCoins(
    FetchCoins event,
    Emitter<CoinsState> emit,
  ) async {
    final current = state;
    String sortBy = 'market_cap';
    String order = 'desc';
    String? search;

    if (current is CoinsLoaded) {
      sortBy = current.sortBy;
      order = current.order;
      search = current.searchQuery;
    }

    if (!event.isRefresh) {
      emit(CoinsLoading());
    }

    try {
      final coins = await repository.getCoins(
        page: 1,
        perPage: _perPage,
        sortBy: sortBy,
        order: order,
        search: search,
      );

      if (coins.isEmpty) {
        emit(const CoinsEmpty());
      } else {
        emit(CoinsLoaded(
          coins: coins,
          currentPage: 1,
          hasReachedMax: coins.length < _perPage,
          sortBy: sortBy,
          order: order,
          searchQuery: search,
        ));
      }
    } catch (e) {
      emit(CoinsError(e.toString().replaceAll('ServerException: ', '')));
    }
  }

  Future<void> _onLoadMoreCoins(
    LoadMoreCoins event,
    Emitter<CoinsState> emit,
  ) async {
    final current = state;
    if (current is! CoinsLoaded || current.hasReachedMax || current.isFetchingMore) {
      return;
    }

    emit(current.copyWith(isFetchingMore: true));

    try {
      final nextPage = current.currentPage + 1;
      final newCoins = await repository.getCoins(
        page: nextPage,
        perPage: _perPage,
        sortBy: current.sortBy,
        order: current.order,
        search: current.searchQuery,
      );

      if (newCoins.isEmpty) {
        emit(current.copyWith(hasReachedMax: true, isFetchingMore: false));
      } else {
        emit(current.copyWith(
          coins: List.of(current.coins)..addAll(newCoins),
          currentPage: nextPage,
          hasReachedMax: newCoins.length < _perPage,
          isFetchingMore: false,
        ));
      }
    } catch (e) {
      emit(current.copyWith(isFetchingMore: false));
    }
  }

  Future<void> _onSortCoinsChanged(
    SortCoinsChanged event,
    Emitter<CoinsState> emit,
  ) async {
    final current = state;
    String? search;
    if (current is CoinsLoaded) {
      search = current.searchQuery;
    }

    emit(CoinsLoading());
    try {
      final coins = await repository.getCoins(
        page: 1,
        perPage: _perPage,
        sortBy: event.sortBy,
        order: event.order,
        search: search,
      );

      if (coins.isEmpty) {
        emit(const CoinsEmpty());
      } else {
        emit(CoinsLoaded(
          coins: coins,
          currentPage: 1,
          hasReachedMax: coins.length < _perPage,
          sortBy: event.sortBy,
          order: event.order,
          searchQuery: search,
        ));
      }
    } catch (e) {
      emit(CoinsError(e.toString().replaceAll('ServerException: ', '')));
    }
  }

  Future<void> _onSearchFilterChanged(
    SearchFilterChanged event,
    Emitter<CoinsState> emit,
  ) async {
    final current = state;
    String sortBy = 'market_cap';
    String order = 'desc';
    if (current is CoinsLoaded) {
      sortBy = current.sortBy;
      order = current.order;
    }

    emit(CoinsLoading());
    try {
      final coins = await repository.getCoins(
        page: 1,
        perPage: _perPage,
        sortBy: sortBy,
        order: order,
        search: event.query,
      );

      if (coins.isEmpty) {
        emit(CoinsEmpty(event.query != null && event.query!.isNotEmpty
            ? 'No coins matching "${event.query}"'
            : 'No cryptocurrencies found.'));
      } else {
        emit(CoinsLoaded(
          coins: coins,
          currentPage: 1,
          hasReachedMax: coins.length < _perPage,
          sortBy: sortBy,
          order: order,
          searchQuery: event.query,
        ));
      }
    } catch (e) {
      emit(CoinsError(e.toString().replaceAll('ServerException: ', '')));
    }
  }
}
