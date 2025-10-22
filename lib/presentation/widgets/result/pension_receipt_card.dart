import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/calculation_results.dart';
import '../help/tax_detail_dialogs.dart';

/// 연금수령 시뮬레이션 결과 카드 (웹 버전과 100% 동일)
class PensionReceiptCard extends StatelessWidget {
  final PensionReceiptSimulationResult result;
  final int annualAmount; // 연간 수령액
  final int retirementAge; // 은퇴나이

  const PensionReceiptCard({
    super.key,
    required this.result,
    required this.annualAmount,
    required this.retirementAge,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');

    // 최적 옵션 결정 (세후 실수령액이 가장 높은 방식)
    String recommendedOption = '저율과세';
    int maxNetAmount = result.lowRateTax.netReceivableAmount;

    if (result.exceedsThreshold) {
      if (result.comprehensiveTax.netReceivableAmount > result.separateTax.netReceivableAmount) {
        recommendedOption = '종합과세';
        maxNetAmount = result.comprehensiveTax.netReceivableAmount;
      } else {
        recommendedOption = '분리과세';
        maxNetAmount = result.separateTax.netReceivableAmount;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 제목
          Text(
            '💰 연금 수령 시뮬레이션 결과',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // 비과세원금 소진 후 계산 안내
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
              border: Border(
                left: BorderSide(
                  color: const Color(0xFF60A5FA),
                  width: 4,
                ),
              ),
            ),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF1E3A8A),
                      height: 1.5,
                    ),
                children: const [
                  TextSpan(
                    text: '📋 계산 기준: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '아래 세금 계산은 ',
                  ),
                  TextSpan(
                    text: '비과세 원금이 모두 소진된 후',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '의 상황을 가정합니다.\n'
                        '실제로는 비과세 원금이 있는 동안 해당 부분에 대해서는 세금이 부과되지 않습니다.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 권장 수령 방식
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(8),
              border: Border(
                left: BorderSide(
                  color: const Color(0xFFFBBF24),
                  width: 4,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🏆 권장 수령 방식',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF92400E),
                            ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF92400E),
                              ),
                          children: [
                            TextSpan(
                              text: recommendedOption,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: ' - 세후 실수령액: '),
                            TextSpan(
                              text: '${numberFormat.format(maxNetAmount)}원',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '연간 수령액',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: const Color(0xFFD97706),
                          ),
                    ),
                    Text(
                      '${numberFormat.format(annualAmount)}원',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD97706),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 1,500만원 이하 - 저율과세
          if (!result.exceedsThreshold) ...[
            Text(
              '💡 저율 분리과세 (1,500만원 이하)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF374151),
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildInfoColumn(
                      context,
                      '적용 세율',
                      '${(result.lowRateTax.applicableTaxRate * 100).toStringAsFixed(1)}%',
                      '($retirementAge세 수령 시작 기준)',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoColumn(
                      context,
                      '납부 세액',
                      '${numberFormat.format(result.lowRateTax.totalTaxPayment)}원',
                      null,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoColumn(
                      context,
                      '세후 실수령액',
                      '${numberFormat.format(result.lowRateTax.netReceivableAmount)}원',
                      null,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 1,500만원 초과 - 두 가지 옵션 비교
          if (result.exceedsThreshold) ...[
            Text(
              '📊 과세 방식 비교 (1,500만원 초과)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF374151),
                  ),
            ),
            const SizedBox(height: 16),

            // 상세 설명 토글들 (2x2 그리드)
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 3.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildDetailToggle(
                      context,
                      '연금소득공제란?',
                      const Color(0xFF10B981),
                      () => showPensionIncomeDeductionDetail(context),
                    ),
                    _buildDetailToggle(
                      context,
                      '인적공제란?',
                      const Color(0xFF8B5CF6),
                      () => showPersonalDeductionDetail(context),
                    ),
                    _buildDetailToggle(
                      context,
                      '누진세율표란?',
                      const Color(0xFFEF4444),
                      () => showProgressiveTaxDetail(context),
                    ),
                    _buildDetailToggle(
                      context,
                      '16.5% 분리과세란?',
                      const Color(0xFFF97316),
                      () => showSeparateTaxDetail(context),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // 종합과세
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: recommendedOption == '종합과세'
                    ? const Color(0xFFEFF6FF)
                    : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: recommendedOption == '종합과세'
                      ? const Color(0xFF60A5FA)
                      : const Color(0xFFE5E7EB),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '🏛️ 옵션 1: 종합과세',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (recommendedOption == '종합과세')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '권장',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildComprehensiveTaxTable(context, numberFormat),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 분리과세
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: recommendedOption == '분리과세'
                    ? const Color(0xFFD1FAE5)
                    : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: recommendedOption == '분리과세'
                      ? const Color(0xFF10B981)
                      : const Color(0xFFE5E7EB),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '🏦 옵션 2: 16.5% 분리과세',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (recommendedOption == '분리과세')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '권장',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSeparateTaxTable(context, numberFormat),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 비교 요약
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📋 비교 요약',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF374151),
                        ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF6B7280),
                          ),
                      children: [
                        const TextSpan(
                          text: '실효세율: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '종합과세 ${((result.comprehensiveTax.totalTaxPayment / annualAmount) * 100).toStringAsFixed(2)}% vs 분리과세 16.50%',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF6B7280),
                          ),
                      children: [
                        const TextSpan(
                          text: '세후 실수령액 차이: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '${numberFormat.format((result.comprehensiveTax.netReceivableAmount - result.separateTax.netReceivableAmount).abs())}원 '
                              '(${result.comprehensiveTax.netReceivableAmount > result.separateTax.netReceivableAmount ? '종합과세' : '분리과세'}가 유리)',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoColumn(BuildContext context, String label, String value, String? hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: const Color(0xFF047857),
              ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF065F46),
                ),
          ),
        ),
        if (hint != null) ...[
          const SizedBox(height: 2),
          Text(
            hint,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF10B981),
                  fontSize: 10,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailToggle(BuildContext context, String title, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text('❓', style: TextStyle(color: color)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7280), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComprehensiveTaxTable(BuildContext context, NumberFormat numberFormat) {
    return Column(
      children: [
        _buildTableRow(context, '연간 수령액', '', '${numberFormat.format(annualAmount)}원', isBold: true),
        const Divider(height: 1),
        _buildTableRow(context, '(-) 연금소득공제', '(최대 한도 적용)', '${numberFormat.format(result.comprehensiveTax.pensionIncomeDeduction)}원', isGray: true),
        const Divider(height: 1),
        _buildTableRow(context, '(=) 연금소득금액', '', '${numberFormat.format(result.comprehensiveTax.pensionIncomeAmount)}원', isBold: true),
        const Divider(height: 1),
        _buildTableRow(context, '(-) 인적공제 (기본)', '', '1,500,000원', isGray: true),
        const Divider(height: 1),
        _buildTableRow(context, '(=) 과세표준', '', '${numberFormat.format(result.comprehensiveTax.taxBase)}원', isBold: true),
        const Divider(height: 1),
        _buildTableRow(context, '(→) 산출세액', '누진세율표 적용', '${numberFormat.format(result.comprehensiveTax.calculatedIncomeTax)}원', isGray: true),
        const Divider(height: 1),
        _buildTableRow(context, '(+) 지방소득세', '산출세액 × 10%', '${numberFormat.format(result.comprehensiveTax.localIncomeTax)}원'),
        const Divider(height: 2),
        _buildTableRow(context, '(=) 총 납부세액', '', '${numberFormat.format(result.comprehensiveTax.totalTaxPayment)}원', isBold: true, valueColor: const Color(0xFFDC2626)),
        const Divider(height: 1),
        _buildTableRow(context, '세후 실수령액', '연간수령액 - 총납부세액', '${numberFormat.format(result.comprehensiveTax.netReceivableAmount)}원', isBold: true, valueColor: const Color(0xFF3B82F6), isHighlight: true, highlightColor: const Color(0xFFEFF6FF)),
        const Divider(height: 2, color: Color(0xFF818CF8)),
        _buildTableRow(
          context,
          '💡 실효세율',
          '총납부세액 ÷ 연간수령액 × 100',
          '${((result.comprehensiveTax.totalTaxPayment / annualAmount) * 100).toStringAsFixed(2)}%',
          isBold: true,
          valueColor: const Color(0xFF6366F1),
          isHighlight: true,
          highlightColor: const Color(0xFFEEF2FF)),
      ],
    );
  }

  Widget _buildSeparateTaxTable(BuildContext context, NumberFormat numberFormat) {
    return Column(
      children: [
        _buildTableRow(context, '연간 수령액', '', '${numberFormat.format(annualAmount)}원', isBold: true),
        const Divider(height: 1),
        _buildTableRow(context, '(×) 적용 세율', '(분리과세 단일세율)', '16.5%', isBold: true, isGray: true),
        const Divider(height: 2),
        _buildTableRow(context, '(=) 총 납부세액', '${numberFormat.format(annualAmount)}원 × 16.5%', '${numberFormat.format(result.separateTax.totalTaxPayment)}원', isBold: true, valueColor: const Color(0xFFDC2626)),
        const Divider(height: 1),
        _buildTableRow(context, '세후 실수령액', '연간수령액 - 총납부세액', '${numberFormat.format(result.separateTax.netReceivableAmount)}원', isBold: true, valueColor: const Color(0xFF10B981), isHighlight: true, highlightColor: const Color(0xFFD1FAE5)),
        const Divider(height: 2, color: Color(0xFFF97316)),
        _buildTableRow(
          context,
          '💡 실효세율',
          '분리과세 고정세율',
          '16.50%',
          isBold: true,
          valueColor: const Color(0xFFF97316),
          isHighlight: true,
          highlightColor: const Color(0xFFFFF7ED),
        ),
      ],
    );
  }

  Widget _buildTableRow(
    BuildContext context,
    String label,
    String description,
    String value, {
    bool isBold = false,
    bool isGray = false,
    bool isHighlight = false,
    Color? valueColor,
    Color? highlightColor,
  }) {
    return Container(
      color: isHighlight
          ? highlightColor
          : (isGray ? const Color(0xFFF9FAFB) : null),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF6B7280),
                          fontSize: 10,
                        ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                    color: valueColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
