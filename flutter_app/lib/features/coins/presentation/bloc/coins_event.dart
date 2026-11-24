import 'package:equatable/equatable.dart';

abstract class CoinsEvent extends Equatable {
  const CoinsEvent();

  @override
  List<Object?> get props => [];
}

class FetchCoins extends CoinsEvent {
  final bool isRefresh;

  const FetchCoins({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class LoadMoreCoins extends CoinsEvent {}

class SortCoinsChanged extends CoinsEvent {
  final String sortBy;
  final String order;

  const SortCoinsChanged({required this.sortBy, required this.order});

  @override
  List<Object?> get props => [sortBy, order];
}

class SearchFilterChanged extends CoinsEvent {
  final String? query;

  const SearchFilterChanged(this.query);

  @override
  List<Object?> get props => [query];
}
