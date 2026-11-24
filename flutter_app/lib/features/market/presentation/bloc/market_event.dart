import 'package:equatable/equatable.dart';

abstract class MarketEvent extends Equatable {
  const MarketEvent();

  @override
  List<Object?> get props => [];
}

class FetchMarketData extends MarketEvent {
  final bool isRefresh;

  const FetchMarketData({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class RefreshMarketData extends MarketEvent {}
