import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/calculation_results.dart';
import '../../../core/constants/help_texts.dart';

/// 세액공제 결과 카드
class TaxDeductionCard extends StatefulWidget {
  final TaxDeductionResult result;

  const TaxDeductionCard({
    super.key,
    required this.result,
  });

  @override
  State<TaxDeductionCard> createState() => _TaxDeductionCardState();
}

class _TaxDeductionCardState extends State<TaxDeductionCard> {
  bool _showDetailedCalculation = false;

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

            // 5개 메트릭 카드 그리드 (웹 버전과 동일)
            LayoutBuilder(
              builder: (context, constraints) {
                // 화면 크기에 따라 2열 또는 3열로 표시
                final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    _buildMetricCard(
                      context,
                      label: '총 납입액',
                      value: numberFormat.format(widget.result.totalContribution),
                      unit: '원',
                      color: const Color(0xFF3B82F6), // Blue
                      icon: Icons.account_balance_wallet,
                    ),
                    _buildMetricCard(
                      context,
                      label: '🎯 세액공제 대상',
                      value: numberFormat.format(widget.result.deductibleAmount),
                      unit: '원',
                      color: const Color(0xFF10B981), // Green
                      icon: Icons.check_circle,
                    ),
                    _buildMetricCard(
                      context,
                      label: '💰 한도초과 납입',
                      value: numberFormat.format(widget.result.excessAmount),
                      unit: '원 (비과세)',
                      color: const Color(0xFFF59E0B), // Orange
                      icon: Icons.add_circle_outline,
                    ),
                    _buildMetricCard(
                      context,
                      label: '적용 세율',
                      value: percentFormat.format(widget.result.applicableTaxRate * 100),
                      unit: '%',
                      color: const Color(0xFF8B5CF6), // Purple
                      icon: Icons.percent,
                    ),
                    _buildMetricCard(
                      context,
                      label: '예상 환급액',
                      value: numberFormat.format(widget.result.expectedRefund),
                      unit: '원',
                      color: const Color(0xFFEF4444), // Red
                      icon: Icons.monetization_on,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // 계산 상세 (웹 버전의 "계산 상세")
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '📋 계산 상세',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• 총 납입액: 연금저축 + IRP = ${numberFormat.format(widget.result.totalContribution)}원\n'
                    '• 세액공제 대상: ${numberFormat.format(widget.result.deductibleAmount)}원 (한도: 900만원)\n'
                    '• 한도 초과분: ${numberFormat.format(widget.result.excessAmount)}원 (수령시 비과세)\n'
                    '• 적용 세율: ${widget.result.applicableTaxRate == 0.165 ? '16.5% (5,500만원 이하)' : '13.2% (5,500만원 초과)'}\n'
                    '• 환급 세액: ${numberFormat.format(widget.result.deductibleAmount)}원 × ${percentFormat.format(widget.result.applicableTaxRate * 100)}% = ${numberFormat.format(widget.result.expectedRefund)}원',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.6,
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
            const SizedBox(height: 16),

            // EET 과세체계 안내
            _buildExpandableSection(
              context,
              title: '💡 EET 과세체계 안내',
              content: HelpTexts.resultExplanation['세액공제'] ?? '',
              icon: Icons.lightbulb_outline,
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }

  /// 확장 가능한 섹션 빌더
  Widget _buildExpandableSection(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Icon(icon, color: color),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                    ),
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

  /// 메트릭 카드 빌더 (웹 버전의 색상 카드)
  Widget _buildMetricCard(
    BuildContext context, {
    required String label,
    required String value,
    required String unit,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: 20,
                        ),
                  ),
                ),
                Text(
                  unit,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color.withOpacity(0.7),
                        fontSize: 9,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
