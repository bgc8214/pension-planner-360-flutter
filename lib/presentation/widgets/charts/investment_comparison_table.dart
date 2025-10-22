import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/calculation_results.dart';

/// 투자 비교 테이블 (일반계좌 vs 연금계좌)
/// 웹 버전의 ResultModule5 연차별 비교 테이블을 Flutter로 이식
class InvestmentComparisonTable extends StatelessWidget {
  final InvestmentComparisonResult result;
  final double averageReturnRate;

  const InvestmentComparisonTable({
    super.key,
    required this.result,
    required this.averageReturnRate,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final percentFormat = NumberFormat('#0.0');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 요약 정보 카드
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF59E0B), // Amber 500
                Color(0xFFD97706), // Amber 600
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.compare_arrows, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '일반계좌 vs 연금계좌 투자 비교',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💰 총 세금 절약: ${numberFormat.format(result.savingsEffect.taxSavings)}원',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '📊 절약률: ${percentFormat.format(result.savingsEffect.savingsRate)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                    Text(
                      '📈 추가 수익률: ${percentFormat.format(result.savingsEffect.additionalReturnRate)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 설명
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '비교 조건',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '• 일반계좌 세금: 매년 배당금에 15.4% 배당세 + 매도시 양도차익에 22% 양도소득세\n'
                '• 연금계좌 세금: 운용 중 비과세, 수령 시 과세대상 수익에만 연금소득세\n'
                '• 공정한 비교: 두 계좌 모두 동일한 수익률(연 ${percentFormat.format(averageReturnRate)}%)로 계속 운용',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue.shade800,
                      height: 1.5,
                      fontSize: 11,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 테이블
        if (result.yearlyComparisonData.isNotEmpty) _buildDataTable(context, numberFormat),
      ],
    );
  }

  Widget _buildDataTable(BuildContext context, NumberFormat numberFormat) {
    // 최대 10개 행만 표시
    final displayData = result.yearlyComparisonData.take(10).toList();
    final hasMore = result.yearlyComparisonData.length > 10;

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
                0: FlexColumnWidth(1.0),   // 연차
                1: FlexColumnWidth(1.3),   // 일반계좌 잔액
                2: FlexColumnWidth(1.2),   // 일반계좌 세금
                3: FlexColumnWidth(1.3),   // 연금계좌 잔액
                4: FlexColumnWidth(1.2),   // 연금계좌 세금
                5: FlexColumnWidth(1.3),   // 누적 세금 차이
              },
              children: [
                TableRow(
                  children: [
                    _buildHeaderCell(context, '연차\n(나이)'),
                    _buildHeaderCell(context, '일반계좌\n잔액'),
                    _buildHeaderCell(context, '일반계좌\n연간세금'),
                    _buildHeaderCell(context, '연금계좌\n잔액'),
                    _buildHeaderCell(context, '연금계좌\n연간세금'),
                    _buildHeaderCell(context, '누적 세금\n차이'),
                  ],
                ),
              ],
            ),
          ),

          // 데이터 행들
          ...displayData.asMap().entries.map((entry) {
            final index = entry.key;
            final yearData = entry.value;
            final isFirst = index == 0;

            return Container(
              color: isFirst
                  ? Colors.yellow.shade50
                  : index % 2 == 0
                      ? null
                      : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.0),
                  1: FlexColumnWidth(1.3),
                  2: FlexColumnWidth(1.2),
                  3: FlexColumnWidth(1.3),
                  4: FlexColumnWidth(1.2),
                  5: FlexColumnWidth(1.3),
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
                        numberFormat.format(yearData.regularAccountBalance),
                      ),
                      _buildDataCell(
                        context,
                        yearData.regularAccountAnnualTax > 0
                            ? '-${numberFormat.format(yearData.regularAccountAnnualTax)}'
                            : '-',
                        color: yearData.regularAccountAnnualTax > 0 ? Colors.red : Colors.grey,
                      ),
                      _buildDataCell(
                        context,
                        numberFormat.format(yearData.pensionAccountBalance),
                      ),
                      _buildDataCell(
                        context,
                        yearData.pensionAccountAnnualTax > 0
                            ? '-${numberFormat.format(yearData.pensionAccountAnnualTax)}'
                            : '0',
                        color: yearData.pensionAccountAnnualTax > 0 ? Colors.orange : Colors.blue,
                        isBold: yearData.pensionAccountAnnualTax == 0,
                      ),
                      _buildDataCell(
                        context,
                        '+${numberFormat.format(yearData.cumulativeTaxDifference)}',
                        color: Colors.green,
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
                        '전체 ${result.yearlyComparisonData.length}개 행 보기',
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
                        '투자 비교 상세 (전체 ${result.yearlyComparisonData.length}년)',
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
                1: FlexColumnWidth(1.3),
                2: FlexColumnWidth(1.2),
                3: FlexColumnWidth(1.3),
                4: FlexColumnWidth(1.2),
                5: FlexColumnWidth(1.3),
              },
              children: [
                TableRow(
                  children: [
                    _buildHeaderCell(context, '연차\n(나이)'),
                    _buildHeaderCell(context, '일반계좌\n잔액'),
                    _buildHeaderCell(context, '일반계좌\n연간세금'),
                    _buildHeaderCell(context, '연금계좌\n잔액'),
                    _buildHeaderCell(context, '연금계좌\n연간세금'),
                    _buildHeaderCell(context, '누적 세금\n차이'),
                  ],
                ),
              ],
            ),
          ),

          // 모든 데이터 행들
          ...result.yearlyComparisonData.asMap().entries.map((entry) {
            final index = entry.key;
            final yearData = entry.value;
            final isFirst = index == 0;

            return Container(
              color: isFirst
                  ? Colors.yellow.shade50
                  : index % 2 == 0
                      ? null
                      : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.0),
                  1: FlexColumnWidth(1.3),
                  2: FlexColumnWidth(1.2),
                  3: FlexColumnWidth(1.3),
                  4: FlexColumnWidth(1.2),
                  5: FlexColumnWidth(1.3),
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
                        numberFormat.format(yearData.regularAccountBalance),
                      ),
                      _buildDataCell(
                        context,
                        yearData.regularAccountAnnualTax > 0
                            ? '-${numberFormat.format(yearData.regularAccountAnnualTax)}'
                            : '-',
                        color: yearData.regularAccountAnnualTax > 0 ? Colors.red : Colors.grey,
                      ),
                      _buildDataCell(
                        context,
                        numberFormat.format(yearData.pensionAccountBalance),
                      ),
                      _buildDataCell(
                        context,
                        yearData.pensionAccountAnnualTax > 0
                            ? '-${numberFormat.format(yearData.pensionAccountAnnualTax)}'
                            : '0',
                        color: yearData.pensionAccountAnnualTax > 0 ? Colors.orange : Colors.blue,
                        isBold: yearData.pensionAccountAnnualTax == 0,
                      ),
                      _buildDataCell(
                        context,
                        '+${numberFormat.format(yearData.cumulativeTaxDifference)}',
                        color: Colors.green,
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
