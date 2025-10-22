import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/calculation_results.dart';

/// 세액공제 결과 카드 (웹 버전 ResultModule1 완전 이식)
class TaxDeductionCardV2 extends StatelessWidget {
  final TaxDeductionResult result;

  const TaxDeductionCardV2({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final percentFormat = NumberFormat('#0.0');

    if (result.totalContribution == 0) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 헤더
            Text(
              '📊 세액공제 계산 결과',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),

            // 5개 메트릭 카드 (Grid Layout)
            LayoutBuilder(
              builder: (context, constraints) {
                // 화면 크기에 따라 열 개수 조정
                final crossAxisCount = constraints.maxWidth > 1200
                    ? 5
                    : constraints.maxWidth > 800
                        ? 3
                        : constraints.maxWidth > 400
                            ? 2
                            : 1;

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    _buildMetricCard(
                      context,
                      label: '총 납입액',
                      value: numberFormat.format(result.totalContribution),
                      unit: '원',
                      color: Colors.blue,
                    ),
                    _buildMetricCard(
                      context,
                      label: '🎯 세액공제 대상',
                      value: numberFormat.format(result.deductibleAmount),
                      unit: '원',
                      color: Colors.green,
                    ),
                    _buildMetricCard(
                      context,
                      label: '💰 한도초과 납입',
                      value: numberFormat.format(result.excessAmount),
                      unit: '원 (비과세)',
                      color: Colors.orange,
                    ),
                    _buildMetricCard(
                      context,
                      label: '적용 세율',
                      value: percentFormat.format(result.applicableTaxRate * 100),
                      unit: '%',
                      color: Colors.purple,
                    ),
                    _buildMetricCard(
                      context,
                      label: '예상 환급액',
                      value: numberFormat.format(result.expectedRefund),
                      unit: '원',
                      color: Colors.red,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // 계산 상세
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('📋', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(
                        '계산 상세',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildDetailBullet(
                    context,
                    '총 납입액: 연금저축 + IRP = ${numberFormat.format(result.totalContribution)}원',
                  ),
                  _buildDetailBullet(
                    context,
                    '세액공제 대상: ${numberFormat.format(result.deductibleAmount)}원 (한도: 900만원)',
                  ),
                  _buildDetailBullet(
                    context,
                    '한도 초과분: ${numberFormat.format(result.excessAmount)}원 (수령시 비과세)',
                  ),
                  _buildDetailBullet(
                    context,
                    '적용 세율: ${result.applicableTaxRate == 0.165 ? "16.5% (5,500만원 이하)" : "13.2% (5,500만원 초과)"}',
                  ),
                  _buildDetailBullet(
                    context,
                    '환급 세액: ${numberFormat.format(result.deductibleAmount)}원 × ${percentFormat.format(result.applicableTaxRate * 100)}% = ${numberFormat.format(result.expectedRefund)}원',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // EET 과세체계 안내
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('💡', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(
                        'EET 과세체계 안내',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildEETBullet(
                    context,
                    '세액공제 대상 원금:',
                    '수령시 전액 과세 대상',
                  ),
                  _buildEETBullet(
                    context,
                    '한도 초과 원금:',
                    '수령시 비과세 (원금 반환)',
                  ),
                  _buildEETBullet(
                    context,
                    '운용 수익:',
                    '수령시 전액 과세 대상',
                  ),
                  _buildEETBullet(
                    context,
                    '연금소득공제:',
                    '수령시 과세 대상 금액에서 차감',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 메트릭 카드 (색상 코딩)
  Widget _buildMetricCard(
    BuildContext context, {
    required String label,
    required String value,
    required String unit,
    required MaterialColor color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color.shade600,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: color.shade800,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            unit,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color.shade500,
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailBullet(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEETBullet(BuildContext context, String label, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.orange.shade600,
                  height: 1.5,
                ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.orange.shade600,
                      height: 1.5,
                    ),
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
