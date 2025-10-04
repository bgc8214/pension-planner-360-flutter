import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/calculation_results.dart';
import '../../services/calculation_service.dart';
import 'pension_input_provider.dart';

part 'calculation_provider.g.dart';

/// 세액공제 계산 결과 Provider (입력값 변경 시 자동 재계산)
@riverpod
TaxDeductionResult taxDeductionResult(TaxDeductionResultRef ref) {
  final input = ref.watch(pensionInputNotifierProvider);
  return CalculationService.calculateTaxDeduction(input);
}

/// 미래자산 계산 결과 Provider (입력값 변경 시 자동 재계산)
@riverpod
FutureAssetResult futureAssetResult(FutureAssetResultRef ref) {
  final input = ref.watch(pensionInputNotifierProvider);
  final taxDeduction = ref.watch(taxDeductionResultProvider);
  return CalculationService.calculateFutureAsset(input, taxDeduction);
}

/// 연금수령 시뮬레이션 결과 Provider (입력값 변경 시 자동 재계산)
@riverpod
PensionReceiptSimulationResult pensionReceiptResult(PensionReceiptResultRef ref) {
  final input = ref.watch(pensionInputNotifierProvider);
  final futureAsset = ref.watch(futureAssetResultProvider);
  final receiptStartAge = input.retirementAge; // 은퇴 나이부터 수령 시작
  return CalculationService.simulatePensionReceipt(
    input,
    futureAsset,
    receiptStartAge,
  );
}

/// 자산변화 시뮬레이션 결과 Provider (입력값 변경 시 자동 재계산)
@riverpod
AssetChangeSimulationResult assetChangeResult(AssetChangeResultRef ref) {
  final input = ref.watch(pensionInputNotifierProvider);
  final futureAsset = ref.watch(futureAssetResultProvider);
  final retirementAge = input.retirementAge;
  final lifeExpectancy = 90; // TODO: Add to input model
  final pensionDuration = lifeExpectancy - retirementAge;

  return CalculationService.simulateAssetChange(
    futureAsset.totalFutureValue,
    input.averageReturnRate,
    input.annualPensionAmount,
    retirementAge,
    pensionDuration.toInt(),
    futureAsset.nonDeductiblePrincipal,
  );
}

/// 투자비교 결과 Provider (입력값 변경 시 자동 재계산)
@riverpod
InvestmentComparisonResult investmentComparisonResult(InvestmentComparisonResultRef ref) {
  final input = ref.watch(pensionInputNotifierProvider);
  final futureAsset = ref.watch(futureAssetResultProvider);
  final pensionReceipt = ref.watch(pensionReceiptResultProvider);
  return CalculationService.compareInvestment(
    input,
    futureAsset,
    pensionReceipt,
  );
}
