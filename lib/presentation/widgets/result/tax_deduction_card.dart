import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/calculation_results.dart';

/// 세액공제 결과 카드
class TaxDeductionCard extends StatelessWidget {
  final TaxDeductionResult result;

  const TaxDeductionCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final percentFormat = NumberFormat('#0.0');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  '세액공제 혜택',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 예상 환급액 (메인 결과)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '연간 예상 환급액',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${numberFormat.format(result.expectedRefund)}원',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 36,
                          letterSpacing: -1,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 상세 정보
            _buildDetailRow(
              context,
              label: '적용 세액공제율',
              value: '${percentFormat.format(result.applicableTaxRate * 100)}%',
            ),
            const Divider(),
            _buildDetailRow(
              context,
              label: '연금저축 공제액',
              value: '${numberFormat.format(result.pensionSavingsDeduction)}원',
            ),
            const Divider(),
            _buildDetailRow(
              context,
              label: 'IRP 공제액',
              value: '${numberFormat.format(result.irpDeduction)}원',
            ),
            const Divider(),
            _buildDetailRow(
              context,
              label: '총 공제대상 납입액',
              value: '${numberFormat.format(result.totalDeductibleAmount)}원',
            ),
            const SizedBox(height: 16),

            // 설명
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '2025년 세법 기준\n'
                      '• 연금저축 한도: 600만원\n'
                      '• 전체 한도 (연금저축 + IRP): 900만원\n'
                      '• 총급여 5,500만원 이하: 16.5%\n'
                      '• 총급여 5,500만원 초과: 13.2%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, {required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
