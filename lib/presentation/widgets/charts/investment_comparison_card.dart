import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/calculation_results.dart';
import 'investment_comparison_table.dart';

/// 투자 비교 분석 메인 카드 (웹 버전 ResultModule5 완전 이식)
class InvestmentComparisonCard extends StatelessWidget {
  final InvestmentComparisonResult result;
  final double averageReturnRate;
  final int currentAge;
  final int retirementAge;
  final int annualPensionAmount;

  const InvestmentComparisonCard({
    super.key,
    required this.result,
    required this.averageReturnRate,
    required this.currentAge,
    required this.retirementAge,
    required this.annualPensionAmount,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final percentFormat = NumberFormat('#0.0');
    final investmentPeriod = retirementAge - currentAge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 비교 기준 설명
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: Colors.blue.shade400, width: 4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('📋', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    '비교 기준',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '동일한 금액을 $investmentPeriod년간 투자 후, 은퇴 시점부터 매년 ${numberFormat.format(annualPensionAmount)}원씩 수령\n'
                '• QQQ ETF 기준: 배당수익률 0.47%, 연평균 수익률 ${percentFormat.format(averageReturnRate)}%\n'
                '• 일반계좌: 은퇴 후에도 계속 보유하며, 매년 필요한 만큼만 매도 (배당세 15.4% + 양도소득세 22%)\n'
                '• 연금계좌: 운용 중 비과세, 매년 연금 수령 시 세금 납부 (비과세원금 우선 인출)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue.shade800,
                      height: 1.5,
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 일반계좌 vs 연금계좌 비교 카드 (세로 배치)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 일반계좌
            _buildRegularAccountCard(context, numberFormat),
            const SizedBox(height: 12),
            // 연금계좌
            _buildPensionAccountCard(context, numberFormat),
          ],
        ),
        const SizedBox(height: 16),

        // 절약 효과 요약
        _buildSavingsEffectCard(context, numberFormat, percentFormat),
        const SizedBox(height: 16),

        // 연차별 비교 테이블
        InvestmentComparisonTable(
          result: result,
          averageReturnRate: averageReturnRate,
        ),
      ],
    );
  }

  /// 일반계좌 상세 카드
  Widget _buildRegularAccountCard(BuildContext context, NumberFormat numberFormat) {
    final regular = result.regularAccountInvestment;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🏦', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '일반계좌 해외주식\n직접투자',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade900,
                        height: 1.3,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDetailRow(context, '총 투자원금', numberFormat.format(regular.totalInvestmentPrincipal), null),
          _buildDetailRow(context, '세전 총 평가액', numberFormat.format(regular.pretaxTotalValue), null),
          const Divider(height: 16),
          _buildDetailRow(context, '배당세 (15.4%)', '-${numberFormat.format(regular.cumulativeDividendTax)}', Colors.red,
              hint: 'QQQ 배당수익률 0.47% 기준'),
          _buildDetailRow(context, '양도소득세 (22%)', '-${numberFormat.format(regular.capitalGainsTax)}', Colors.red,
              hint: '자본이득에 대해서만 적용'),
          const Divider(height: 16),
          _buildDetailRow(context, '총 세금', '-${numberFormat.format(regular.totalTax)}', Colors.red.shade700,
              isBold: true),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildDetailRow(context, '세후 수령액', numberFormat.format(regular.netReceivableAmount), Colors.red.shade900,
                isBold: true, isLarge: true),
          ),
        ],
      ),
    );
  }

  /// 연금계좌 상세 카드
  Widget _buildPensionAccountCard(BuildContext context, NumberFormat numberFormat) {
    final pension = result.pensionAccountInvestment;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🏛️', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '연금계좌 해외주식\nETF',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                        height: 1.3,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDetailRow(context, '총 투자원금', numberFormat.format(pension.totalInvestmentPrincipal), null),
          _buildDetailRow(context, '세전 총 평가액', numberFormat.format(pension.pretaxTotalValue), null),
          const Divider(height: 16),
          _buildDetailRow(context, '비과세 원금', numberFormat.format(pension.nonDeductiblePrincipal), Colors.green),
          _buildDetailRow(context, '과세대상 수익', numberFormat.format(pension.taxableReturn), null),
          _buildDetailRow(context, '연금소득세', '-${numberFormat.format(pension.pensionIncomeTax)}', Colors.orange,
              hint: '과세대상 수익에 대해 적용\n연간 수령액 1,500만원 이하 시 5.5%'),
          const Divider(height: 16),
          _buildDetailRow(context, '총 세금', '-${numberFormat.format(pension.totalTax)}', Colors.blue.shade700,
              isBold: true),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildDetailRow(context, '세후 수령액', numberFormat.format(pension.netReceivableAmount), Colors.blue.shade900,
                isBold: true, isLarge: true),
          ),
        ],
      ),
    );
  }

  /// 절약 효과 카드
  Widget _buildSavingsEffectCard(BuildContext context, NumberFormat numberFormat, NumberFormat percentFormat) {
    final savings = result.savingsEffect;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💰', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                '연금계좌 투자의 세제혜택',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildSavingsBox(
                context,
                '${numberFormat.format(savings.taxSavings)}원',
                '세금 절약 금액',
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildSavingsBox(
                      context,
                      '${percentFormat.format(savings.savingsRate)}%',
                      '세금 절약률',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSavingsBox(
                      context,
                      '+${percentFormat.format(savings.additionalReturnRate)}%',
                      '추가 수익률 효과',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsBox(BuildContext context, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                  fontSize: 22,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    Color? color, {
    String? hint,
    bool isBold = false,
    bool isLarge = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                        fontSize: isLarge ? 17 : 14,
                        color: color,
                        height: 1.3,
                      ),
                  maxLines: 2,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 6,
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                        fontSize: isLarge ? 20 : 15,
                        color: color,
                      ),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (hint != null) ...[
                const SizedBox(height: 4),
                Text(
                  hint,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                ),
              ],
        ],
      ),
    );
  }
}
