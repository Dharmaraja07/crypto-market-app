import 'package:equatable/equatable.dart';
import '../../data/models/coin_summary_model.dart';

abstract class CoinsState extends Equatable {
  const CoinsState();

  @override
  List<Object?> get props => [];
}

class CoinsInitial extends CoinsState {}

class CoinsLoading extends CoinsState {}

class CoinsLoaded extends CoinsState {
  final List<CoinSummaryModel> coins;
  final int currentPage;
  final bool hasReachedMax;
  final bool isFetchingMore;
  final String sortBy;
  final String order;
  final String? searchQuery;

  const CoinsLoaded({
    required this.coins,
    required this.currentPage,
    this.hasReachedMax = false,
    this.isFetchingMore = false,
    this.sortBy = 'market_cap',
    this.order = 'desc',
    this.searchQuery,
  });

  CoinsLoaded copyWith({
    List<CoinSummaryModel>? coins,
    int? currentPage,
    bool? hasReachedMax,
    bool? isFetchingMore,
    String? sortBy,
    String? order,
    String? searchQuery,
  }) {
    return CoinsLoaded(
      coins: coins ?? this.coins,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      sortBy: sortBy ?? this.sortBy,
      order: order ?? this.order,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        coins,
        currentPage,
        hasReachedMax,
        isFetchingMore,
        sortBy,
        order,
        searchQuery,
      ];
}

class CoinsEmpty extends CoinsState {
  final String message;

  const CoinsEmpty([this.message = 'No cryptocurrencies found matching your criteria.']);

  @override
  List<Object?> get props => [message];
}

class CoinsError extends CoinsState {
  final String message;

  const CoinsError(this.message);

  @override
  List<Object?> get props => [message];
}
