import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculation_provider.dart';
import '../widgets/result/tax_deduction_card.dart';
import '../widgets/result/future_asset_card.dart';
import '../widgets/result/pension_receipt_card.dart';
import '../widgets/charts/asset_change_chart.dart';

/// 결과 화면
class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taxDeduction = ref.watch(taxDeductionResultProvider);
    final futureAsset = ref.watch(futureAssetResultProvider);
    final pensionReceipt = ref.watch(pensionReceiptResultProvider);
    final assetChange = ref.watch(assetChangeResultProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 요약 안내
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '입력값 변경 시 자동으로 재계산됩니다',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 세액공제 결과
          TaxDeductionCard(result: taxDeduction),
          const SizedBox(height: 16),

          // 미래자산 결과
          FutureAssetCard(result: futureAsset),
          const SizedBox(height: 16),

          // 연금수령 시뮬레이션 결과
          PensionReceiptCard(result: pensionReceipt),
          const SizedBox(height: 16),

          // 자산변화 차트
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.show_chart,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '자산 변화 시뮬레이션',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AssetChangeChart(result: assetChange),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
