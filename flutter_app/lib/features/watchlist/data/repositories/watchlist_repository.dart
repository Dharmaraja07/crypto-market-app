import 'dart:async';
import 'package:crypto_market_app/core/constants/api_constants.dart';
import 'package:crypto_market_app/core/network/api_client.dart';
import '../datasources/watchlist_local_data_source.dart';
import '../models/watchlist_item_model.dart';
import 'package:crypto_market_app/features/coins/data/models/coin_summary_model.dart';

class WatchlistRepository {
  final ApiClient apiClient;
  final WatchlistLocalDataSource localDataSource;
  final StreamController<List<WatchlistItemModel>> _watchlistController =
      StreamController<List<WatchlistItemModel>>.broadcast();

  Stream<List<WatchlistItemModel>> get watchlistStream => _watchlistController.stream;

  WatchlistRepository({
    required this.apiClient,
    required this.localDataSource,
  });

  void dispose() {
    _watchlistController.close();
  }

  Future<List<WatchlistItemModel>> getWatchlist({String userId = 'default_user'}) async {
    try {
      final data = await apiClient.get(
        ApiConstants.watchlist,
        queryParameters: {'userId': userId},
      );

      if (data is List) {
        final items = data
            .map((e) => WatchlistItemModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        await localDataSource.cacheWatchlist(items);
        _watchlistController.add(items);
        return items;
      }
    } catch (_) {
      // Fallback to local cache if network/backend fails
    }
    final cached = await localDataSource.getCachedWatchlist();
    _watchlistController.add(cached);
    return cached;
  }

  Future<WatchlistItemModel> addToWatchlist({
    required String coinId,
    required CoinSummaryModel coin,
    String userId = 'default_user',
  }) async {
    final localItem = WatchlistItemModel(
      userId: userId,
      coinId: coin.id,
      coinSymbol: coin.symbol,
      coinName: coin.name,
      coinImage: coin.image,
      currentPrice: coin.currentPrice,
      priceChangePercentage24h: coin.priceChangePercentage24h,
      marketCap: coin.marketCap,
      marketCapRank: coin.marketCapRank,
      addedAt: DateTime.now().toIso8601String(),
    );

    // Save locally first and notify stream immediately
    await localDataSource.addToCache(localItem);
    final currentList = await localDataSource.getCachedWatchlist();
    _watchlistController.add(currentList);

    // Sync with backend asynchronously
    try {
      final data = await apiClient.post(
        ApiConstants.watchlistAdd(coinId),
        queryParameters: {'userId': userId},
      );
      if (data != null && data is Map<String, dynamic>) {
        final serverItem = WatchlistItemModel.fromJson(data);
        await localDataSource.addToCache(serverItem);
        final updatedList = await localDataSource.getCachedWatchlist();
        _watchlistController.add(updatedList);
        return serverItem;
      }
    } catch (_) {}

    return localItem;
  }

  Future<void> removeFromWatchlist({
    required String coinId,
    String userId = 'default_user',
  }) async {
    // Remove locally and notify stream immediately
    await localDataSource.removeFromCache(coinId);
    final currentList = await localDataSource.getCachedWatchlist();
    _watchlistController.add(currentList);

    try {
      await apiClient.delete(
        ApiConstants.watchlistRemove(coinId),
        queryParameters: {'userId': userId},
      );
    } catch (_) {}
  }

  Future<bool> isInWatchlist(String coinId) async {
    return localDataSource.isInCache(coinId);
  }
}
