import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiConstants {
  // Production Render cloud endpoint
  static const String liveCloudUrl = 'https://crypto-market-app-2gge.onrender.com/api/v1';

  // Default endpoints
  static String get defaultBaseUrl {
    return liveCloudUrl;
  }

  // Endpoints
  static const String marketOverview = '/market/overview';
  static const String coins = '/coins';
  static const String trending = '/coins/trending';
  static const String topGainers = '/coins/top-gainers';
  static const String topLosers = '/coins/top-losers';
  static const String watchlist = '/watchlist';
  static const String search = '/search';

  static String coinDetail(String coinId) => '/coins/$coinId';
  static String coinChart(String coinId, String range) => '/coins/$coinId/chart?range=$range';
  static String watchlistAdd(String coinId) => '/watchlist/$coinId';
  static String watchlistRemove(String coinId) => '/watchlist/$coinId';
  static String watchlistStatus(String coinId) => '/watchlist/$coinId/status';
}
