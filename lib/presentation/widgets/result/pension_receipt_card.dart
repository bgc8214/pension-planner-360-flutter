import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/calculation_results.dart';

/// 연금수령 시뮬레이션 결과 카드
class PensionReceiptCard extends StatelessWidget {
  final PensionReceiptSimulationResult result;

  const PensionReceiptCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');

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
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.payments_rounded,
                    color: Color(0xFF10B981),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  '연금 수령 시뮬레이션',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 월 수령액 (메인 결과)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF10B981), // Green 500
                    Color(0xFF059669), // Green 600
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '월 예상 수령액',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${numberFormat.format(result.monthlyAmount)}원',
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

            // 과세 방식별 비교
            Text(
              '과세 방식별 실수령액',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            _buildTaxMethodCard(
              context,
              title: '종합과세',
              monthlyAmount: result.comprehensiveTaxMonthlyAmount,
              tax: result.comprehensiveTaxAmount,
              isRecommended: result.recommendedTaxType == '종합과세',
            ),
            const SizedBox(height: 8),
            _buildTaxMethodCard(
              context,
              title: '분리과세',
              monthlyAmount: result.separateTaxMonthlyAmount,
              tax: result.separateTaxAmount,
              isRecommended: result.recommendedTaxType == '분리과세',
            ),
            const SizedBox(height: 8),
            _buildTaxMethodCard(
              context,
              title: '저율과세 (3~5%)',
              monthlyAmount: result.lowRateTaxMonthlyAmount,
              tax: result.lowRateTaxAmount,
              isRecommended: result.recommendedTaxType == '저율과세',
            ),
            const SizedBox(height: 16),

            // 추천 정보
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '추천: ${result.recommendedTaxType}\n'
                      '${_getRecommendationReason(result)}',
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

  Widget _buildTaxMethodCard(
    BuildContext context, {
    required String title,
    required int monthlyAmount,
    required int tax,
    required bool isRecommended,
  }) {
    final numberFormat = NumberFormat('#,###');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isRecommended
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).dividerColor,
          width: isRecommended ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isRecommended
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (isRecommended) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '추천',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                '${numberFormat.format(monthlyAmount)}원',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isRecommended
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '세금: ${numberFormat.format(tax)}원',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  String _getRecommendationReason(PensionReceiptSimulationResult result) {
    switch (result.recommendedTaxType) {
      case '저율과세':
        return '10년 이상 유지 시 저율과세가 가장 유리합니다.';
      case '분리과세':
        return '연금 외 소득이 많은 경우 분리과세가 유리합니다.';
      case '종합과세':
        return '연금 외 소득이 적은 경우 종합과세가 유리합니다.';
      default:
        return '';
    }
  }
}
