import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/watchlist_item_model.dart';

class WatchlistLocalDataSource {
  final SharedPreferences prefs;
  static const String _key = 'user_watchlist_items';

  WatchlistLocalDataSource({required this.prefs});

  Future<List<WatchlistItemModel>> getCachedWatchlist() async {
    final jsonString = prefs.getString(_key);
    if (jsonString != null && jsonString.isNotEmpty) {
      final List decoded = jsonDecode(jsonString);
      return decoded.map((e) => WatchlistItemModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }

  Future<void> cacheWatchlist(List<WatchlistItemModel> items) async {
    final list = items.map((e) => e.toJson()).toList();
    await prefs.setString(_key, jsonEncode(list));
  }

  Future<void> addToCache(WatchlistItemModel item) async {
    final current = await getCachedWatchlist();
    current.removeWhere((e) => e.coinId == item.coinId);
    current.insert(0, item);
    await cacheWatchlist(current);
  }

  Future<void> removeFromCache(String coinId) async {
    final current = await getCachedWatchlist();
    current.removeWhere((e) => e.coinId == coinId);
    await cacheWatchlist(current);
  }

  Future<bool> isInCache(String coinId) async {
    final current = await getCachedWatchlist();
    return current.any((e) => e.coinId == coinId);
  }
}
