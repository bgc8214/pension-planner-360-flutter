import 'package:flutter/material.dart';
import 'pension_income_deduction_help.dart';
import 'personal_deduction_help.dart';
import 'progressive_tax_help.dart';
import 'separate_tax_help.dart';

/// 세금 상세 설명 메인 카드
/// 4가지 세금 관련 설명을 모두 포함하는 컨테이너
class TaxExplanationsCard extends StatelessWidget {
  const TaxExplanationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 헤더
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.blue,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '세금 상세 설명',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '연금 과세 방식을 이해하는데 도움이 됩니다',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 4가지 설명 위젯
            const PensionIncomeDeductionHelp(),
            const SizedBox(height: 8),
            const PersonalDeductionHelp(),
            const SizedBox(height: 8),
            const ProgressiveTaxHelp(),
            const SizedBox(height: 8),
            const SeparateTaxHelp(),
          ],
        ),
      ),
    );
  }
}
