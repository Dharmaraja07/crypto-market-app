import 'package:equatable/equatable.dart';
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
