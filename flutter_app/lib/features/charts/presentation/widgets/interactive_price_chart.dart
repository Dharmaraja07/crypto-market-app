import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_market_app/core/constants/app_colors.dart';
import 'package:crypto_market_app/core/utils/formatters.dart';
import 'package:crypto_market_app/core/widgets/custom_shimmer.dart';
import 'package:crypto_market_app/core/widgets/error_view.dart';
import '../bloc/chart_bloc.dart';
import '../bloc/chart_event.dart';
import '../bloc/chart_state.dart';
import 'time_range_selector.dart';

class InteractivePriceChart extends StatefulWidget {
  final String coinId;

  const InteractivePriceChart({
    super.key,
    required this.coinId,
  });

  @override
  State<InteractivePriceChart> createState() => _InteractivePriceChartState();
}

class _InteractivePriceChartState extends State<InteractivePriceChart> {
  FlSpot? _touchedSpot;
  DateTime? _touchedDate;

  @override
  void initState() {
    super.initState();
    context.read<ChartBloc>().add(FetchChartData(coinId: widget.coinId, range: '7d'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      builder: (context, state) {
        String activeRange = '7d';
        if (state is ChartLoading) activeRange = state.activeRange;
        if (state is ChartLoaded) activeRange = state.activeRange;
        if (state is ChartError) activeRange = state.activeRange;

        return Column(
          children: [
            TimeRangeSelector(
              selectedRange: activeRange,
              onRangeSelected: (range) {
                setState(() {
                  _touchedSpot = null;
                  _touchedDate = null;
                });
                context.read<ChartBloc>().add(ChangeTimeRange(range));
              },
            ),
            const SizedBox(height: 8),
            Container(
              height: 280,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: _buildContent(context, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ChartState state) {
    if (state is ChartLoading || state is ChartInitial) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          CustomShimmer(width: 120, height: 24),
          SizedBox(height: 8),
          CustomShimmer(width: 80, height: 16),
          Spacer(),
          CustomShimmer(width: double.infinity, height: 160),
        ],
      );
    }

    if (state is ChartError) {
      return ErrorView(
        message: state.message,
        onRetry: () => context.read<ChartBloc>().add(ChangeTimeRange(state.activeRange)),
      );
    }

    if (state is ChartLoaded) {
      final chartData = state.chartData;
      if (chartData.points.isEmpty) {
        return const Center(
          child: Text('No chart data available', style: TextStyle(color: AppColors.textMuted)),
        );
      }

      final isPositive = chartData.isPositive;
      final lineColor = isPositive ? AppColors.gain : AppColors.loss;

      final spots = <FlSpot>[];
      for (int i = 0; i < chartData.points.length; i++) {
        spots.add(FlSpot(i.toDouble(), chartData.points[i].price));
      }

      final double displayedPrice = _touchedSpot != null
          ? _touchedSpot!.y
          : chartData.points.last.price;

      final String displayedTime = _touchedDate != null
          ? Formatters.formatDateTime(_touchedDate!)
          : 'Latest';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with touched or current price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Formatters.formatPrice(displayedPrice),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    displayedTime,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive ? AppColors.gainLight : AppColors.lossLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  Formatters.formatPercentage(chartData.changePercentage),
                  style: TextStyle(
                    color: lineColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // FL Chart
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (chartData.points.length - 1).toDouble(),
                minY: chartData.minPrice * 0.998,
                maxY: chartData.maxPrice * 1.002,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (chartData.maxPrice - chartData.minPrice) / 3 > 0
                      ? (chartData.maxPrice - chartData.minPrice) / 3
                      : 1,
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: AppColors.divider,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                titlesData: const FlTitlesData(
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) => AppColors.surface,
                    tooltipRoundedRadius: 8,
                    tooltipBorder: const BorderSide(color: AppColors.border),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((barSpot) {
                        return LineTooltipItem(
                          Formatters.formatPrice(barSpot.y),
                          const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                    if (touchResponse != null && touchResponse.lineBarSpots != null && touchResponse.lineBarSpots!.isNotEmpty) {
                      final spot = touchResponse.lineBarSpots!.first;
                      final index = spot.x.toInt();
                      if (index >= 0 && index < chartData.points.length) {
                        setState(() {
                          _touchedSpot = spot;
                          _touchedDate = DateTime.fromMillisecondsSinceEpoch(
                            chartData.points[index].timestamp,
                          );
                        });
                      }
                    } else if (event is FlPanEndEvent || event is FlTapUpEvent) {
                      setState(() {
                        _touchedSpot = null;
                        _touchedDate = null;
                      });
                    }
                  },
                  handleBuiltInTouches: true,
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.2,
                    color: lineColor,
                    barWidth: 2.2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          lineColor.withAlpha(70),
                          lineColor.withAlpha(0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Low: ${Formatters.formatPrice(chartData.minPrice)}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
              Text(
                'High: ${Formatters.formatPrice(chartData.maxPrice)}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
