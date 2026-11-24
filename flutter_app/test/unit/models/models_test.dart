import 'package:flutter_test/flutter_test.dart';
import 'package:crypto_market_app/core/utils/formatters.dart';
import 'package:crypto_market_app/features/coins/data/models/coin_summary_model.dart';
import 'package:crypto_market_app/features/market/data/models/market_overview_model.dart';
import 'package:crypto_market_app/features/charts/data/models/chart_data_model.dart';
import 'package:crypto_market_app/features/watchlist/data/models/watchlist_item_model.dart';
import 'package:crypto_market_app/features/search/data/models/search_result_model.dart';

void main() {
  group('Model Serialization Tests', () {
    test('CoinSummaryModel fromJson and toJson', () {
      final json = {
        'id': 'bitcoin',
        'symbol': 'btc',
        'name': 'Bitcoin',
        'image': 'https://image.png',
        'currentPrice': 68500.0,
        'marketCap': 1350000000000.0,
        'marketCapRank': 1,
        'totalVolume': 35000000000.0,
        'high24h': 69000.0,
        'low24h': 67500.0,
        'priceChange24h': 1000.0,
        'priceChangePercentage24h': 2.5,
        'sparklineIn7d': [67000.0, 68000.0, 68500.0],
        'lastUpdated': '2024-11-01T00:00:00Z',
      };

      final model = CoinSummaryModel.fromJson(json);

      expect(model.id, 'bitcoin');
      expect(model.symbol, 'BTC');
      expect(model.name, 'Bitcoin');
      expect(model.currentPrice, 68500.0);
      expect(model.isPositive, true);
      expect(model.sparklineIn7d.length, 3);

      final encoded = model.toJson();
      expect(encoded['id'], 'bitcoin');
      expect(encoded['currentPrice'], 68500.0);
    });

    test('MarketOverviewModel fromJson and toJson', () {
      final json = {
        'totalMarketCapUsd': 2600000000000.0,
        'totalVolume24hUsd': 85000000000.0,
        'marketCapChange24hPercentage': 1.85,
        'btcDominancePercentage': 56.2,
        'ethDominancePercentage': 15.1,
        'activeCryptocurrencies': 14500,
        'ongoingIcos': 30,
        'marketsCount': 1050,
        'updatedAt': '2024-11-01',
      };

      final model = MarketOverviewModel.fromJson(json);

      expect(model.totalMarketCapUsd, 2600000000000.0);
      expect(model.btcDominancePercentage, 56.2);
      expect(model.activeCryptocurrencies, 14500);

      final encoded = model.toJson();
      expect(encoded['btcDominancePercentage'], 56.2);
    });

    test('ChartDataModel fromJson', () {
      final json = {
        'coinId': 'ethereum',
        'range': '24h',
        'minPrice': 3400.0,
        'maxPrice': 3550.0,
        'changePercentage': 3.12,
        'points': [
          {'timestamp': 1700000000000, 'price': 3400.0},
          {'timestamp': 1700003600000, 'price': 3550.0},
        ],
      };

      final model = ChartDataModel.fromJson(json);

      expect(model.coinId, 'ethereum');
      expect(model.range, '24h');
      expect(model.points.length, 2);
      expect(model.isPositive, true);
    });

    test('WatchlistItemModel fromJson and toJson', () {
      final json = {
        'id': 1,
        'userId': 'default_user',
        'coinId': 'solana',
        'coinSymbol': 'sol',
        'coinName': 'Solana',
        'coinImage': 'https://sol.png',
        'currentPrice': 185.0,
        'priceChangePercentage24h': 5.5,
        'marketCap': 85000000000.0,
        'marketCapRank': 3,
        'addedAt': '2024-11-01',
      };

      final model = WatchlistItemModel.fromJson(json);

      expect(model.coinId, 'solana');
      expect(model.coinSymbol, 'SOL');
      expect(model.isPositive, true);

      final encoded = model.toJson();
      expect(encoded['coinId'], 'solana');
    });

    test('SearchResultModel fromJson', () {
      final json = {
        'id': 'cardano',
        'name': 'Cardano',
        'symbol': 'ada',
        'marketCapRank': 8,
        'thumb': 'https://ada.png',
        'large': 'https://ada_large.png',
      };

      final model = SearchResultModel.fromJson(json);

      expect(model.id, 'cardano');
      expect(model.symbol, 'ADA');
      expect(model.marketCapRank, 8);
    });
  });

  group('Formatters Tests', () {
    test('formatCurrency handles billions and trillions', () {
      expect(Formatters.formatCurrency(2600000000000.0), '\$2.60T');
      expect(Formatters.formatCurrency(85400000000.0), '\$85.40B');
      expect(Formatters.formatCurrency(1500000.0), '\$1.50M');
      expect(Formatters.formatCurrency(68500.50), '\$68,500.50');
      expect(Formatters.formatCurrency(0.5842), '\$0.5842');
    });

    test('formatPercentage formats sign and decimals', () {
      expect(Formatters.formatPercentage(2.456), '+2.46%');
      expect(Formatters.formatPercentage(-1.182), '-1.18%');
      expect(Formatters.formatPercentage(0.0), '0.00%');
    });

    test('formatSupply formats compact with symbol', () {
      expect(Formatters.formatSupply(19700000.0, 'btc'), '19.7M BTC');
    });
  });
}
