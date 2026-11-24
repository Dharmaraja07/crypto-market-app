import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiConstants {
  // Default development endpoints
  static String get defaultBaseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api/v1';
    }
    return 'http://localhost:8080/api/v1';
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
