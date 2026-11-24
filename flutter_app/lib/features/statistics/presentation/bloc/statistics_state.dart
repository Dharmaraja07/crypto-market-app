import 'package:equatable/equatable.dart';
import 'package:crypto_market_app/features/market/data/models/market_overview_model.dart';
import 'package:crypto_market_app/features/coins/data/models/coin_summary_model.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object?> get props => [];
}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final MarketOverviewModel overview;
  final List<CoinSummaryModel> topGainers;
  final List<CoinSummaryModel> topLosers;

  const StatisticsLoaded({
    required this.overview,
    required this.topGainers,
    required this.topLosers,
  });

  @override
  List<Object?> get props => [overview, topGainers, topLosers];
}

class StatisticsError extends StatisticsState {
  final String message;

  const StatisticsError(this.message);

  @override
  List<Object?> get props => [message];
}
