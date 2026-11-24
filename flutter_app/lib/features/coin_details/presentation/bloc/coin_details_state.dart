import 'package:equatable/equatable.dart';
import '../../data/models/coin_detail_model.dart';

abstract class CoinDetailsState extends Equatable {
  const CoinDetailsState();

  @override
  List<Object?> get props => [];
}

class CoinDetailsInitial extends CoinDetailsState {}

class CoinDetailsLoading extends CoinDetailsState {}

class CoinDetailsLoaded extends CoinDetailsState {
  final CoinDetailModel coin;
  final bool isInWatchlist;

  const CoinDetailsLoaded({
    required this.coin,
    this.isInWatchlist = false,
  });

  CoinDetailsLoaded copyWith({
    CoinDetailModel? coin,
    bool? isInWatchlist,
  }) {
    return CoinDetailsLoaded(
      coin: coin ?? this.coin,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
    );
  }

  @override
  List<Object?> get props => [coin, isInWatchlist];
}

class CoinDetailsError extends CoinDetailsState {
  final String message;

  const CoinDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
