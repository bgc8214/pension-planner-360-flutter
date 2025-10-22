import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/calculation_results.dart';

/// 결과 요약 카드 (웹 버전과 동일)
class SummaryCards extends StatelessWidget {
  final TaxDeductionResult taxDeduction;
  final FutureAssetResult futureAsset;
  final AssetChangeSimulationResult assetChange;
  final InvestmentComparisonResult investmentComparison;

  const SummaryCards({
    super.key,
    required this.taxDeduction,
    required this.futureAsset,
    required this.assetChange,
    required this.investmentComparison,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final percentFormat = NumberFormat('#0.0');

    final cards = [
      _CardData(
        title: '💰 연간 세액공제',
        value: '${numberFormat.format(taxDeduction.expectedRefund)}원',
        subtitle: '총 납입액 ${numberFormat.format(taxDeduction.totalContribution)}원',
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _CardData(
        title: '📈 예상 총 자산',
        value: '${numberFormat.format(futureAsset.totalFutureValue)}원',
        subtitle: '원금 ${numberFormat.format(futureAsset.totalPrincipal)}원 + '
            '수익 ${numberFormat.format(futureAsset.totalExpectedReturn)}원',
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _CardData(
        title: '🎯 연금 지속 기간',
        value: assetChange.sustainableYears > 0
            ? '약 ${assetChange.sustainableYears}년'
            : '-',
        subtitle: assetChange.expectedDepletionAge > 0
            ? '${assetChange.expectedDepletionAge}세까지 수령 가능'
            : '데이터를 입력해주세요',
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _CardData(
        title: '✨ 연금계좌 세금 절약',
        value: '${numberFormat.format(investmentComparison.savingsEffect.taxSavings)}원',
        subtitle: '일반계좌 대비 ${percentFormat.format(investmentComparison.savingsEffect.savingsRate)}% 절약',
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
        childAspectRatio: MediaQuery.of(context).size.width > 600 ? 2.8 : 3.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return Container(
          decoration: BoxDecoration(
            gradient: card.gradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                card.title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    card.value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                card.subtitle,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 10,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CardData {
  final String title;
  final String value;
  final String subtitle;
  final Gradient gradient;

  _CardData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.gradient,
  });
}
