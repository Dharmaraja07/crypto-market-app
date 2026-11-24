import 'package:crypto_market_app/core/constants/api_constants.dart';
import 'package:crypto_market_app/core/network/api_client.dart';
import '../models/coin_summary_model.dart';
import 'package:crypto_market_app/features/coin_details/data/models/coin_detail_model.dart';
import 'package:crypto_market_app/features/charts/data/models/chart_data_model.dart';
import 'package:crypto_market_app/features/search/data/models/search_result_model.dart';

class CoinRepository {
  final ApiClient apiClient;

  CoinRepository({required this.apiClient});

  Future<List<CoinSummaryModel>> getCoins({
    int page = 1,
    int perPage = 20,
    String sortBy = 'market_cap',
    String order = 'desc',
    String? search,
  }) async {
    final Map<String, dynamic> params = {
      'page': page,
      'perPage': perPage,
      'sortBy': sortBy,
      'order': order,
    };
    if (search != null && search.trim().isNotEmpty) {
      params['search'] = search.trim();
    }

    final data = await apiClient.get(
      ApiConstants.coins,
      queryParameters: params,
    );

    if (data is List) {
      return data
          .map((e) => CoinSummaryModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  Future<CoinDetailModel> getCoinDetail(String coinId) async {
    final data = await apiClient.get(ApiConstants.coinDetail(coinId));
    return CoinDetailModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<ChartDataModel> getCoinChart(String coinId, String range) async {
    final data = await apiClient.get(
      ApiConstants.coinDetail(coinId) + '/chart',
      queryParameters: {'range': range},
    );
    return ChartDataModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<List<SearchResultModel>> searchCoins(String query) async {
    final data = await apiClient.get(
      ApiConstants.search,
      queryParameters: {'query': query},
    );
    if (data is List) {
      return data
          .map((e) => SearchResultModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }
}
