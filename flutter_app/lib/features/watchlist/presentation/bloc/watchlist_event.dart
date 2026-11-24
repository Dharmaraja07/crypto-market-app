import 'package:equatable/equatable.dart';
import 'package:crypto_market_app/features/coins/data/models/coin_summary_model.dart';
import '../../data/models/watchlist_item_model.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class FetchWatchlist extends WatchlistEvent {
  final bool isRefresh;

  const FetchWatchlist({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class AddCoinToWatchlist extends WatchlistEvent {
  final CoinSummaryModel coin;

  const AddCoinToWatchlist(this.coin);

  @override
  List<Object?> get props => [coin];
}

class RemoveCoinFromWatchlist extends WatchlistEvent {
  final String coinId;

  const RemoveCoinFromWatchlist(this.coinId);

  @override
  List<Object?> get props => [coinId];
}

class WatchlistUpdated extends WatchlistEvent {
  final List<WatchlistItemModel> items;

  const WatchlistUpdated(this.items);

  @override
  List<Object?> get props => [items];
}
