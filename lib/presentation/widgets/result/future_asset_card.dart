import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/calculation_results.dart';

/// 미래자산 결과 카드
class FutureAssetCard extends StatelessWidget {
  final FutureAssetResult result;

  const FutureAssetCard({
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

            // 은퇴 시점 예상 자산 (메인 결과)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF06B6D4), // Cyan 500
                    Color(0xFF3B82F6), // Blue 500
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF06B6D4).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '은퇴 시점 예상 자산',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${numberFormat.format(result.retirementAsset)}원',
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
              label: '총 납입 원금',
              value: '${numberFormat.format(result.totalPrincipal)}원',
            ),
            const Divider(),
            _buildDetailRow(
              context,
              label: '총 수익금',
              value: '${numberFormat.format(result.totalReturn)}원',
              valueColor: Theme.of(context).colorScheme.secondary,
            ),
            const Divider(),
            _buildDetailRow(
              context,
              label: '납입 기간',
              value: '25년', // TODO: Calculate from input
            ),
            const Divider(),
            _buildDetailRow(
              context,
              label: '연평균 수익률',
              value: '5.0%', // TODO: Get from input
            ),
            const SizedBox(height: 16),

            // 수익률 정보
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '복리 효과로 시간이 지날수록 수익이 증가합니다.\n'
                      '납입금의 ${((result.totalReturn / result.totalPrincipal) * 100).toStringAsFixed(1)}% 수익이 예상됩니다.',
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
}
