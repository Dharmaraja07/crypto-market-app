import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crypto_market_app/core/widgets/empty_state_view.dart';
import 'package:crypto_market_app/features/coins/data/models/coin_summary_model.dart';
import 'package:crypto_market_app/features/coins/presentation/widgets/coin_list_item.dart';
import 'package:crypto_market_app/features/market/data/models/market_overview_model.dart';
import 'package:crypto_market_app/features/market/presentation/widgets/market_overview_card.dart';
import 'package:crypto_market_app/features/charts/presentation/widgets/time_range_selector.dart';

void main() {
  testWidgets('EmptyStateView renders title, description, and icon', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyStateView(
            title: 'No Items Found',
            description: 'Please try another search',
            icon: Icons.search_off,
          ),
        ),
      ),
    );

    expect(find.text('No Items Found'), findsOneWidget);
    expect(find.text('Please try another search'), findsOneWidget);
    expect(find.byIcon(Icons.search_off), findsOneWidget);
  });

  testWidgets('MarketOverviewCard displays global market cap and volume', (WidgetTester tester) async {
    const overview = MarketOverviewModel(
      totalMarketCapUsd: 2650000000000.0,
      totalVolume24hUsd: 88500000000.0,
      marketCapChange24hPercentage: 2.45,
      btcDominancePercentage: 56.4,
      ethDominancePercentage: 15.2,
      activeCryptocurrencies: 14500,
      ongoingIcos: 40,
      marketsCount: 1100,
      updatedAt: '2024-11-01',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MarketOverviewCard(overview: overview),
        ),
      ),
    );

    expect(find.text('Global Market Cap'), findsOneWidget);
    expect(find.text('\$2.65T'), findsOneWidget);
    expect(find.text('+2.45%'), findsOneWidget);
    expect(find.text('56.4%'), findsOneWidget);
  });

  testWidgets('CoinListItem displays name, symbol, and triggers onTap', (WidgetTester tester) async {
    bool tapped = false;
    const coin = CoinSummaryModel(
      id: 'bitcoin',
      symbol: 'BTC',
      name: 'Bitcoin',
      currentPrice: 68420.0,
      priceChangePercentage24h: 3.5,
      marketCapRank: 1,
      marketCap: 1350000000000.0,
      sparklineIn7d: [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CoinListItem(
            coin: coin,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('BTC'), findsNWidgets(2));
    expect(find.text('\$68,420.00'), findsOneWidget);
    expect(find.text('+3.50%'), findsOneWidget);

    await tester.tap(find.byType(CoinListItem));
    expect(tapped, true);
  });

  testWidgets('TimeRangeSelector renders all options and handles selection', (WidgetTester tester) async {
    String selected = '7d';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimeRangeSelector(
            selectedRange: selected,
            onRangeSelected: (range) {
              selected = range;
            },
          ),
        ),
      ),
    );

    expect(find.text('1H'), findsOneWidget);
    expect(find.text('24H'), findsOneWidget);
    expect(find.text('7D'), findsOneWidget);
    expect(find.text('30D'), findsOneWidget);
    expect(find.text('90D'), findsOneWidget);
    expect(find.text('1Y'), findsOneWidget);

    await tester.tap(find.text('30D'));
    expect(selected, '30d');
  });
}
