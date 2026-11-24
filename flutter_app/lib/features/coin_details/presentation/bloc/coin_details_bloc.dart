import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_market_app/features/coins/data/repositories/coin_repository.dart';
import 'package:crypto_market_app/features/watchlist/data/repositories/watchlist_repository.dart';
import 'package:crypto_market_app/features/coins/data/models/coin_summary_model.dart';
import 'coin_details_event.dart';
import 'coin_details_state.dart';

class CoinDetailsBloc extends Bloc<CoinDetailsEvent, CoinDetailsState> {
  final CoinRepository coinRepository;
  final WatchlistRepository watchlistRepository;

  CoinDetailsBloc({
    required this.coinRepository,
    required this.watchlistRepository,
  }) : super(CoinDetailsInitial()) {
    on<FetchCoinDetail>(_onFetchCoinDetail);
    on<ToggleWatchlistStatus>(_onToggleWatchlist);
  }

  Future<void> _onFetchCoinDetail(
    FetchCoinDetail event,
    Emitter<CoinDetailsState> emit,
  ) async {
    emit(CoinDetailsLoading());
    try {
      final coin = await coinRepository.getCoinDetail(event.coinId);
      final inWatchlist = await watchlistRepository.isInWatchlist(coin.id);

      emit(CoinDetailsLoaded(
        coin: coin,
        isInWatchlist: inWatchlist,
      ));
    } catch (e) {
      emit(CoinDetailsError(e.toString().replaceAll('ServerException: ', '')));
    }
  }

  Future<void> _onToggleWatchlist(
    ToggleWatchlistStatus event,
    Emitter<CoinDetailsState> emit,
  ) async {
    final current = state;
    if (current is! CoinDetailsLoaded) return;

    final newStatus = !current.isInWatchlist;
    emit(current.copyWith(isInWatchlist: newStatus));

    try {
      if (newStatus) {
        final summary = CoinSummaryModel(
          id: event.coin.id,
          symbol: event.coin.symbol,
          name: event.coin.name,
          image: event.coin.image,
          currentPrice: event.coin.currentPrice,
          priceChangePercentage24h: event.coin.priceChangePercentage24h,
          marketCap: event.coin.marketCap,
          marketCapRank: event.coin.marketCapRank,
        );
        await watchlistRepository.addToWatchlist(coinId: event.coin.id, coin: summary);
      } else {
        await watchlistRepository.removeFromWatchlist(coinId: event.coin.id);
      }
    } catch (_) {
      // Revert if failed
      emit(current.copyWith(isInWatchlist: !newStatus));
    }
  }
}
