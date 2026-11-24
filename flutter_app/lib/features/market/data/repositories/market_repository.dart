import 'package:crypto_market_app/core/constants/api_constants.dart';
import 'package:crypto_market_app/core/network/api_client.dart';
import '../models/market_overview_model.dart';
import 'package:crypto_market_app/features/coins/data/models/coin_summary_model.dart';

class MarketRepository {
  final ApiClient apiClient;

  MarketRepository({required this.apiClient});

  Future<MarketOverviewModel> getMarketOverview() async {
    final data = await apiClient.get(ApiConstants.marketOverview);
    return MarketOverviewModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<List<CoinSummaryModel>> getTrendingCoins() async {
    final data = await apiClient.get(ApiConstants.trending);
    if (data is List) {
      return data
          .map((e) => CoinSummaryModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  Future<List<CoinSummaryModel>> getTopGainers({int limit = 5}) async {
    final data = await apiClient.get(
      ApiConstants.topGainers,
      queryParameters: {'limit': limit},
    );
    if (data is List) {
      return data
          .map((e) => CoinSummaryModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  Future<List<CoinSummaryModel>> getTopLosers({int limit = 5}) async {
    final data = await apiClient.get(
      ApiConstants.topLosers,
      queryParameters: {'limit': limit},
    );
    if (data is List) {
      return data
          .map((e) => CoinSummaryModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }
}
