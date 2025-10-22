import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/calculation_results.dart';
import '../../../core/constants/help_texts.dart';

/// 미래자산 결과 카드
class FutureAssetCard extends StatefulWidget {
  final FutureAssetResult result;
  final double averageReturnRate;
  final int currentAge;
  final int retirementAge;

  const FutureAssetCard({
    super.key,
    required this.result,
    required this.averageReturnRate,
    required this.currentAge,
    required this.retirementAge,
  });

  @override
  State<FutureAssetCard> createState() => _FutureAssetCardState();
}

class _FutureAssetCardState extends State<FutureAssetCard> {

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final percentFormat = NumberFormat('#0.0');
    final contributionPeriod = widget.retirementAge - widget.currentAge;
    final totalReturnRate = ((widget.result.totalFutureValue / widget.result.totalPrincipal) - 1) * 100;

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
                    color: const Color(0xFF06B6D4).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: Color(0xFF06B6D4),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  '미래 자산 가치',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 요약 정보 박스 (웹 버전과 동일)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF3B82F6).withOpacity(0.1),
                    const Color(0xFF4F46E5).withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  children: [
                    TextSpan(
                      text: '$contributionPeriod년간',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                    const TextSpan(text: ' 연 '),
                    TextSpan(
                      text: '${percentFormat.format(widget.averageReturnRate)}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                    const TextSpan(text: '로 운용할 경우,\n총 납입원금 '),
                    TextSpan(
                      text: '${numberFormat.format(widget.result.totalPrincipal)}원',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                    const TextSpan(text: '이\n은퇴 시점에 '),
                    TextSpan(
                      text: '${numberFormat.format(widget.result.totalFutureValue)}원',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                    const TextSpan(text: '으로 성장할 것으로 예상됩니다.\n'),
                    TextSpan(
                      text: '(총 수익률: ${totalReturnRate.toStringAsFixed(1)}%)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 4개 메트릭 카드 그리드 (웹 버전과 동일)
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    _buildMetricCard(
                      context,
                      label: '총 납입원금',
                      value: numberFormat.format(widget.result.totalPrincipal),
                      unit: '원 ($contributionPeriod년간 납입)',
                      color: const Color(0xFF3B82F6), // Blue
                      icon: Icons.savings,
                    ),
                    _buildMetricCard(
                      context,
                      label: '🎯 세액공제 대상 원금',
                      value: numberFormat.format(widget.result.deductiblePrincipal),
                      unit: '원 (수령시 과세)',
                      color: const Color(0xFF10B981), // Green
                      icon: Icons.check_circle,
                    ),
                    _buildMetricCard(
                      context,
                      label: '💰 비과세 원금',
                      value: numberFormat.format(widget.result.nonDeductiblePrincipal),
                      unit: '원 (수령시 비과세)',
                      color: const Color(0xFFF59E0B), // Orange
                      icon: Icons.shield,
                    ),
                    _buildMetricCard(
                      context,
                      label: '📈 운용 수익',
                      value: numberFormat.format(widget.result.totalExpectedReturn),
                      unit: '원 (수령시 과세)',
                      color: const Color(0xFF8B5CF6), // Purple
                      icon: Icons.trending_up,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // 총 미래가치 박스 (웹 버전과 동일)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF10B981).withOpacity(0.1),
                    const Color(0xFF059669).withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '🏆 은퇴 시점 총 자산',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF10B981),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${numberFormat.format(widget.result.totalFutureValue)}원',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                          fontSize: 36,
                          letterSpacing: -1,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '납입원금 대비 ${totalReturnRate.toStringAsFixed(1)}% 성장 예상',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF10B981),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 자산 구성 비율 프로그레스 바 (웹 버전과 동일)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📊 은퇴 시점 자산 구성',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildProgressBar(
                    context,
                    label: '세액공제 대상 원금',
                    amount: widget.result.deductiblePrincipal,
                    total: widget.result.totalFutureValue,
                    color: const Color(0xFF10B981),
                    numberFormat: numberFormat,
                  ),
                  const SizedBox(height: 12),
                  _buildProgressBar(
                    context,
                    label: '비과세 원금',
                    amount: widget.result.nonDeductiblePrincipal,
                    total: widget.result.totalFutureValue,
                    color: const Color(0xFFF59E0B),
                    numberFormat: numberFormat,
                  ),
                  const SizedBox(height: 12),
                  _buildProgressBar(
                    context,
                    label: '운용 수익',
                    amount: widget.result.totalExpectedReturn,
                    total: widget.result.totalFutureValue,
                    color: const Color(0xFF8B5CF6),
                    numberFormat: numberFormat,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 계산 상세 (웹 버전과 동일)
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
                    '• 납입 기간: ${widget.currentAge}세 ~ ${widget.retirementAge}세 ($contributionPeriod년간)\n'
                    '• 연평균 수익률: ${percentFormat.format(widget.averageReturnRate)}% (복리 적용)\n'
                    '• 세액공제 대상 원금: 수령 시 연금소득세 부과\n'
                    '• 비과세 원금: 수령 시 원금 반환 (비과세)\n'
                    '• 운용 수익: 수령 시 연금소득세 부과',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 미래 자산 활용 전략 (웹 버전과 동일)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.lightbulb,
                        size: 20,
                        color: Color(0xFF3B82F6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '💡 미래 자산 활용 전략',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF3B82F6),
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• 세액공제 최대화: 연간 한도(900만원) 내에서 납입\n'
                    '• 장기 투자: $contributionPeriod년간 꾸준한 납입으로 복리 효과 극대화\n'
                    '• 수익률 관리: 목표 수익률 달성을 위한 포트폴리오 관리\n'
                    '• 세금 최적화: 수령 방식에 따른 세금 부담 고려',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                          color: const Color(0xFF3B82F6),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 미래자산 상세 설명
            _buildExpandableSection(
              context,
              title: '📈 미래자산 계산 방법',
              content: HelpTexts.resultExplanation['미래자산'] ?? '',
              icon: Icons.trending_up,
              color: const Color(0xFF06B6D4),
            ),
            const SizedBox(height: 12),

            // 복리 계산 공식
            _buildExpandableSection(
              context,
              title: '🧮 복리 계산 공식',
              content: HelpTexts.formulas['복리계산'] ?? '',
              icon: Icons.calculate,
              color: const Color(0xFF3B82F6),
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

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
  }) {
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
                  color: valueColor,
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
                          fontSize: 18,
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

  /// 프로그레스 바 빌더 (웹 버전의 자산 구성 비율)
  Widget _buildProgressBar(
    BuildContext context, {
    required String label,
    required int amount,
    required int total,
    required Color color,
    required NumberFormat numberFormat,
  }) {
    final percentage = total > 0 ? (amount / total * 100) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(6),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
