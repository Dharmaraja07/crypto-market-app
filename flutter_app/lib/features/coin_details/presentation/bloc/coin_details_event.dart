import 'package:equatable/equatable.dart';
import 'package:crypto_market_app/features/watchlist/data/models/watchlist_item_model.dart';
import '../../data/models/coin_detail_model.dart';

abstract class CoinDetailsEvent extends Equatable {
  const CoinDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchCoinDetail extends CoinDetailsEvent {
  final String coinId;

  const FetchCoinDetail(this.coinId);

  @override
  List<Object?> get props => [coinId];
}

class ToggleWatchlistStatus extends CoinDetailsEvent {
  final CoinDetailModel coin;

  const ToggleWatchlistStatus(this.coin);

  @override
  List<Object?> get props => [coin];
}

class WatchlistStatusSync extends CoinDetailsEvent {
  final List<WatchlistItemModel> items;

  const WatchlistStatusSync(this.items);

  @override
  List<Object?> get props => [items];
}
