import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/calculation_results.dart';

/// 건강보험료 계산 결과 카드
class HealthInsuranceCard extends StatelessWidget {
  final int annualPensionAmount; // 연간 연금액
  final int annualTax; // 연간 세금
  final HealthInsuranceResult insuranceResult; // 건강보험료 계산 결과

  const HealthInsuranceCard({
    super.key,
    required this.annualPensionAmount,
    required this.annualTax,
    required this.insuranceResult,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');

    final isDependentEligible = insuranceResult.isDependentEligible;
    final monthlyHealthInsurance = insuranceResult.monthlyTotalInsurance;
    final annualHealthInsurance = insuranceResult.annualTotalInsurance;
    final dependentIncomeLimit = insuranceResult.dependentIncomeLimit;

    final netAmountWithDependent = annualPensionAmount - annualTax;
    final netAmountAsLocal = annualPensionAmount - annualTax - annualHealthInsurance;
    final finalNetAmount = isDependentEligible ? netAmountWithDependent : netAmountAsLocal;

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
            '🏥 건강보험료 및 실수령액',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // 피부양자 자격 여부
          _buildDependentStatusCard(
            context,
            isDependentEligible,
            dependentIncomeLimit,
            numberFormat,
          ),
          const SizedBox(height: 16),

          // 건강보험료 계산 (지역가입자인 경우만)
          if (!isDependentEligible) ...[
            _buildInsuranceCard(context, insuranceResult, numberFormat),
            const SizedBox(height: 16),
          ],

          // 실수령액 요약
          _buildNetAmountSummary(
            context,
            isDependentEligible,
            netAmountWithDependent,
            netAmountAsLocal,
            finalNetAmount,
            numberFormat,
          ),
        ],
      ),
    );
  }

  /// 피부양자 자격 여부 카드
  Widget _buildDependentStatusCard(
    BuildContext context,
    bool isDependentEligible,
    int incomeLimit,
    NumberFormat numberFormat,
  ) {
    final statusColor = isDependentEligible ? Colors.green : Colors.orange;
    final statusBgColor = isDependentEligible
        ? const Color(0xFFD1FAE5)
        : const Color(0xFFFED7AA);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: statusColor, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isDependentEligible ? Icons.check_circle : Icons.warning,
                color: statusColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isDependentEligible ? '✅ 피부양자 자격 유지 가능' : '⚠️ 피부양자 자격 탈락',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: statusColor.shade800,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: statusColor.shade700,
                    height: 1.5,
                  ),
              children: [
                const TextSpan(
                  text: '📋 피부양자 자격 기준\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '• 연간 소득: ${numberFormat.format(incomeLimit)}원 이하\n',
                ),
                TextSpan(
                  text: '• 현재 연금액: ${numberFormat.format(annualPensionAmount)}원\n',
                ),
                if (!isDependentEligible)
                  TextSpan(
                    text: '\n→ 지역가입자로 전환되어 건강보험료 납부 필요',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusColor.shade900,
                    ),
                  )
                else
                  TextSpan(
                    text: '\n→ 건강보험료 납부 없음 (0원)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusColor.shade900,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 건강보험료 계산 카드
  Widget _buildInsuranceCard(
    BuildContext context,
    HealthInsuranceResult result,
    NumberFormat numberFormat,
  ) {
    final monthlyHealth = result.monthlyHealthInsurance;
    final monthlyLongTerm = result.monthlyLongTermCare;
    final monthlyTotal = result.monthlyTotalInsurance;
    final annualTotal = result.annualTotalInsurance;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💰 지역가입자 건강보험료',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF92400E),
                ),
          ),
          const SizedBox(height: 12),

          _buildInsuranceRow(
            context,
            '건강보험료 (월)',
            numberFormat.format(monthlyHealth),
            '소득의 약 7.78%',
          ),
          const Divider(height: 20),
          _buildInsuranceRow(
            context,
            '장기요양보험료 (월)',
            numberFormat.format(monthlyLongTerm),
            '건강보험료의 12.95%',
          ),
          const Divider(height: 20),
          _buildInsuranceRow(
            context,
            '월 총 보험료',
            numberFormat.format(monthlyTotal),
            null,
            isBold: true,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '연간 총 보험료',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    '${numberFormat.format(annualTotal)}원',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFDC2626),
                        ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsuranceRow(
    BuildContext context,
    String label,
    String value,
    String? hint, {
    bool isBold = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '$value원',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isBold ? const Color(0xFFDC2626) : null,
                    ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        if (hint != null) ...[
          const SizedBox(height: 4),
          Text(
            hint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                ),
          ),
        ],
      ],
    );
  }

  /// 실수령액 요약 카드
  Widget _buildNetAmountSummary(
    BuildContext context,
    bool isDependentEligible,
    int netWithDependent,
    int netAsLocal,
    int finalNet,
    NumberFormat numberFormat,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3B82F6),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet, color: Color(0xFF3B82F6), size: 24),
              const SizedBox(width: 8),
              Text(
                '💸 실수령액 요약',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E40AF),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 연간 연금액
          _buildSummaryRow(
            context,
            '연간 연금액',
            numberFormat.format(annualPensionAmount),
            null,
          ),
          const Divider(height: 20),

          // 연간 세금
          _buildSummaryRow(
            context,
            '(-) 연간 세금',
            numberFormat.format(annualTax),
            const Color(0xFFDC2626),
          ),

          // 연간 건강보험료 (지역가입자인 경우만)
          if (!isDependentEligible) ...[
            const Divider(height: 20),
            _buildSummaryRow(
              context,
              '(-) 연간 건강보험료',
              numberFormat.format(annualPensionAmount - annualTax - netAsLocal),
              const Color(0xFFF97316),
            ),
          ],

          const Divider(height: 20, thickness: 2),

          // 최종 실수령액
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        '🎯 연간 실수령액',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E40AF),
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${numberFormat.format(finalNet)}원',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2563EB),
                            ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '월 실수령액',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '약 ${numberFormat.format((finalNet / 12).round())}원',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2563EB),
                            ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 비교 (피부양자 탈락 시)
          if (!isDependentEligible) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📊 피부양자 유지 시와 비교',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF92400E),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '피부양자 유지 시: ${numberFormat.format(netWithDependent)}원',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF92400E),
                        ),
                  ),
                  Text(
                    '지역가입자 전환 시: ${numberFormat.format(netAsLocal)}원',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF92400E),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '→ 차이: ${numberFormat.format(netWithDependent - netAsLocal)}원 감소',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFDC2626),
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

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    Color? valueColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            '$value원',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
