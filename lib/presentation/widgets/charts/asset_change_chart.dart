import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/calculation_results.dart';

/// 자산 변화 차트
class AssetChangeChart extends StatelessWidget {
  final AssetChangeSimulationResult result;

  const AssetChangeChart({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.compact(locale: 'ko_KR');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 차트
        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: _calculateInterval(result.yearlyAssetData),
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Theme.of(context).dividerColor,
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: _calculateYearInterval(result.yearlyAssetData.length),
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < result.yearlyAssetData.length) {
                        final yearData = result.yearlyAssetData[value.toInt()];
                        return Text(
                          '${yearData.age}세',
                          style: Theme.of(context).textTheme.bodySmall,
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        numberFormat.format(value),
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: _generateSpots(result.yearlyAssetData),
                  isCurved: true,
                  color: Theme.of(context).colorScheme.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: result.yearlyAssetData.length <= 20,
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final index = spot.x.toInt();
                      if (index >= 0 && index < result.yearlyAssetData.length) {
                        final yearData = result.yearlyAssetData[index];
                        return LineTooltipItem(
                          '${yearData.age}세\n'
                          '${NumberFormat('#,###').format(yearData.balance.toInt())}원',
                          TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return null;
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 자산 고갈 정보
        if (result.isDepleted) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${result.depletionAge}세에 자산이 고갈될 예정입니다.\n'
                    '납입액을 늘리거나 수령 기간을 조정해보세요.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '기대수명까지 자산이 유지됩니다.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  List<FlSpot> _generateSpots(List<AssetChangeYearData> data) {
    return List.generate(
      data.length,
      (index) => FlSpot(
        index.toDouble(),
        data[index].balance,
      ),
    );
  }

  double _calculateInterval(List<AssetChangeYearData> data) {
    final maxValue = data.map((e) => e.balance).reduce((a, b) => a > b ? a : b);
    return (maxValue / 5).ceilToDouble();
  }

  double _calculateYearInterval(int length) {
    if (length <= 10) return 1;
    if (length <= 20) return 2;
    if (length <= 40) return 5;
    return 10;
  }
}
