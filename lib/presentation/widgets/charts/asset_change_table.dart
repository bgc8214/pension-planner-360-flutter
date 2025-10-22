import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/calculation_results.dart';

/// 자산 변화 테이블
/// 웹 버전과 동일한 표 형식으로 연차별 상세 데이터 표시
class AssetChangeTable extends StatelessWidget {
  final AssetChangeSimulationResult result;

  const AssetChangeTable({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final percentFormat = NumberFormat('#0.0');

    // 연평균 수익률 표시
    final returnRateText = '${percentFormat.format(result.averageReturnRate)}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 요약 정보 카드
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF8B5CF6), // Purple 500
                Color(0xFF7C3AED), // Purple 600
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '은퇴 시점의 총 ${numberFormat.format(result.startingAsset)}원을 '
                '연 $returnRateText로 운용하며, 매년 ${numberFormat.format(result.annualRequestedAmount)}원을 인출할 경우,',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.95),
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '(단, 비과세 재원은 세금 없이 먼저 인출됩니다)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      result.sustainableYears < 40
                          ? Icons.warning_amber
                          : Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '고객님의 연금은 약 ${result.expectedDepletionAge}세까지 수령 가능할 것으로 예상됩니다.'
                        '(총 ${result.sustainableYears}년간 지속 가능)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 테이블
        _buildDataTable(context, numberFormat),
      ],
    );
  }

  Widget _buildDataTable(BuildContext context, NumberFormat numberFormat) {
    final percentFormat = NumberFormat('#0.0');
    final returnRateText = '${percentFormat.format(result.averageReturnRate)}%';

    // 최대 10개 행만 표시 (스크롤 가능하게)
    final displayData = result.yearlyData.take(10).toList();
    final hasMore = result.yearlyData.length > 10;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 헤더
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.0), // 연차 (나이)
                1: FlexColumnWidth(1.5), // 기초자산
                2: FlexColumnWidth(1.3), // 연간 운용수익
                3: FlexColumnWidth(1.3), // 세전 인출액
                4: FlexColumnWidth(1.2), // 납부세액
                5: FlexColumnWidth(1.3), // 세후 인출액
                6: FlexColumnWidth(1.5), // 기말자산
              },
              children: [
                TableRow(
                  children: [
                    _buildHeaderCell(context, '연차\n(나이)'),
                    _buildHeaderCell(context, '기초자산'),
                    _buildHeaderCell(context, '연간 운용수익\n($returnRateText)'),
                    _buildHeaderCell(context, '세전 인출액'),
                    _buildHeaderCell(context, '납부세액'),
                    _buildHeaderCell(context, '세후 인출액'),
                    _buildHeaderCell(context, '기말자산'),
                  ],
                ),
              ],
            ),
          ),

          // 데이터 행들
          ...displayData.asMap().entries.map((entry) {
            final index = entry.key;
            final yearData = entry.value;
            final isEven = index % 2 == 0;

            return Container(
              color: isEven
                  ? null
                  : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.0),
                  1: FlexColumnWidth(1.5),
                  2: FlexColumnWidth(1.3),
                  3: FlexColumnWidth(1.3),
                  4: FlexColumnWidth(1.2),
                  5: FlexColumnWidth(1.3),
                  6: FlexColumnWidth(1.5),
                },
                children: [
                  TableRow(
                    children: [
                      _buildDataCell(
                        context,
                        '${yearData.year}년차\n(${yearData.age}세)',
                        isLabel: true,
                      ),
                      _buildDataCell(
                        context,
                        numberFormat.format(yearData.beginningAsset),
                      ),
                      _buildDataCell(
                        context,
                        '+ ${numberFormat.format(yearData.annualOperatingIncome)}',
                        color: Colors.green,
                      ),
                      _buildDataCell(
                        context,
                        '- ${numberFormat.format(yearData.pretaxWithdrawal)}',
                      ),
                      _buildDataCell(
                        context,
                        yearData.taxPayment > 0
                            ? '-${numberFormat.format(yearData.taxPayment)}'
                            : '0',
                        color: yearData.taxPayment > 0 ? Colors.red : null,
                      ),
                      _buildDataCell(
                        context,
                        numberFormat.format(yearData.aftertaxWithdrawal),
                      ),
                      _buildDataCell(
                        context,
                        numberFormat.format(yearData.endingAsset),
                        isBold: true,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

          // "더보기" 버튼
          if (hasMore)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: InkWell(
                onTap: () {
                  _showFullTable(context, numberFormat);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.expand_more,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '전체 ${result.yearlyData.length}개 행 보기',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              height: 1.3,
            ),
      ),
    );
  }

  Widget _buildDataCell(
    BuildContext context,
    String text, {
    bool isLabel = false,
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Text(
        text,
        textAlign: isLabel ? TextAlign.center : TextAlign.right,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 11,
              color: color,
              height: 1.3,
            ),
      ),
    );
  }

  /// 전체 테이블 모달로 표시
  void _showFullTable(BuildContext context, NumberFormat numberFormat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // 핸들
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // 제목
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '자산 변화 상세 (전체 ${result.yearlyData.length}년)',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // 스크롤 가능한 테이블
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: _buildFullDataTable(context, numberFormat),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFullDataTable(BuildContext context, NumberFormat numberFormat) {
    final percentFormat = NumberFormat('#0.0');
    final returnRateText = '${percentFormat.format(result.averageReturnRate)}%';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 헤더
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.0),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1.3),
                3: FlexColumnWidth(1.3),
                4: FlexColumnWidth(1.2),
                5: FlexColumnWidth(1.3),
                6: FlexColumnWidth(1.5),
              },
              children: [
                TableRow(
                  children: [
                    _buildHeaderCell(context, '연차\n(나이)'),
                    _buildHeaderCell(context, '기초자산'),
                    _buildHeaderCell(context, '연간 운용수익'),
                    _buildHeaderCell(context, '세전 인출액'),
                    _buildHeaderCell(context, '납부세액'),
                    _buildHeaderCell(context, '세후 인출액'),
                    _buildHeaderCell(context, '기말자산'),
                  ],
                ),
              ],
            ),
          ),

          // 모든 데이터 행들
          ...result.yearlyData.asMap().entries.map((entry) {
            final index = entry.key;
            final yearData = entry.value;
            final isEven = index % 2 == 0;

            return Container(
              color: isEven
                  ? null
                  : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.0),
                  1: FlexColumnWidth(1.5),
                  2: FlexColumnWidth(1.3),
                  3: FlexColumnWidth(1.3),
                  4: FlexColumnWidth(1.2),
                  5: FlexColumnWidth(1.3),
                  6: FlexColumnWidth(1.5),
                },
                children: [
                  TableRow(
                    children: [
                      _buildDataCell(
                        context,
                        '${yearData.year}년차\n(${yearData.age}세)',
                        isLabel: true,
                      ),
                      _buildDataCell(
                        context,
                        numberFormat.format(yearData.beginningAsset),
                      ),
                      _buildDataCell(
                        context,
                        '+ ${numberFormat.format(yearData.annualOperatingIncome)}',
                        color: Colors.green,
                      ),
                      _buildDataCell(
                        context,
                        '- ${numberFormat.format(yearData.pretaxWithdrawal)}',
                      ),
                      _buildDataCell(
                        context,
                        yearData.taxPayment > 0
                            ? '-${numberFormat.format(yearData.taxPayment)}'
                            : '0',
                        color: yearData.taxPayment > 0 ? Colors.red : null,
                      ),
                      _buildDataCell(
                        context,
                        numberFormat.format(yearData.aftertaxWithdrawal),
                      ),
                      _buildDataCell(
                        context,
                        numberFormat.format(yearData.endingAsset),
                        isBold: true,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
