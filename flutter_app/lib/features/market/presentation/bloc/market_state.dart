import 'package:equatable/equatable.dart';
import '../../data/models/market_overview_model.dart';
import 'package:crypto_market_app/features/coins/data/models/coin_summary_model.dart';

abstract class MarketState extends Equatable {
  const MarketState();

  @override
  List<Object?> get props => [];
}

class MarketInitial extends MarketState {}

class MarketLoading extends MarketState {}

class MarketLoaded extends MarketState {
  final MarketOverviewModel overview;
  final List<CoinSummaryModel> trendingCoins;
  final List<CoinSummaryModel> topGainers;
  final List<CoinSummaryModel> topLosers;

  const MarketLoaded({
    required this.overview,
    required this.trendingCoins,
    required this.topGainers,
    required this.topLosers,
  });

  @override
  List<Object?> get props => [overview, trendingCoins, topGainers, topLosers];
}

class MarketError extends MarketState {
  final String message;

  const MarketError(this.message);

  @override
  List<Object?> get props => [message];
}
