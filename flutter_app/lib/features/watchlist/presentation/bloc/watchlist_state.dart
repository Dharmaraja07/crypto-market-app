import 'package:equatable/equatable.dart';
import '../../data/models/watchlist_item_model.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<WatchlistItemModel> items;

  const WatchlistLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class WatchlistEmpty extends WatchlistState {}

class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}
