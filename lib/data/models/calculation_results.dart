import 'package:freezed_annotation/freezed_annotation.dart';

part 'calculation_results.freezed.dart';
part 'calculation_results.g.dart';

/// 세액공제 계산 결과
@freezed
class TaxDeductionResult with _$TaxDeductionResult {
  const factory TaxDeductionResult({
    required int totalContribution, // 총납입액
    required int deductibleAmount, // 세액공제대상금액
    required int excessAmount, // 세액공제한도초과금액
    required double applicableTaxRate, // 적용세율
    required int expectedRefund, // 예상환급액
  }) = _TaxDeductionResult;

  factory TaxDeductionResult.fromJson(Map<String, dynamic> json) =>
      _$TaxDeductionResultFromJson(json);
}

/// 미래 자산 계산 결과
@freezed
class FutureAssetResult with _$FutureAssetResult {
  const factory FutureAssetResult({
    required int totalPrincipal, // 총납입원금
    required int deductiblePrincipal, // 세액공제대상원금 (미래가치)
    required int nonDeductiblePrincipal, // 비과세원금
    required int totalExpectedReturn, // 총예상수익
    required int totalFutureValue, // 총미래가치
  }) = _FutureAssetResult;

  factory FutureAssetResult.fromJson(Map<String, dynamic> json) =>
      _$FutureAssetResultFromJson(json);
}

/// 종합과세 결과
@freezed
class ComprehensiveTaxResult with _$ComprehensiveTaxResult {
  const factory ComprehensiveTaxResult({
    required int pensionIncomeDeduction, // 연금소득공제액
    required int pensionIncomeAmount, // 연금소득금액
    required int totalIncomeAmount, // 총소득금액
    required int personalDeduction, // 인적공제
    required int taxBase, // 과세표준
    required int calculatedIncomeTax, // 산출소득세
    required int localIncomeTax, // 지방소득세
    required int totalTaxPayment, // 총납부세액
    required int netReceivableAmount, // 세후실수령액
  }) = _ComprehensiveTaxResult;

  factory ComprehensiveTaxResult.fromJson(Map<String, dynamic> json) =>
      _$ComprehensiveTaxResultFromJson(json);
}

/// 분리과세 결과
@freezed
class SeparateTaxResult with _$SeparateTaxResult {
  const factory SeparateTaxResult({
    required double applicableTaxRate, // 적용세율
    required int totalTaxPayment, // 총납부세액
    required int netReceivableAmount, // 세후실수령액
  }) = _SeparateTaxResult;

  factory SeparateTaxResult.fromJson(Map<String, dynamic> json) =>
      _$SeparateTaxResultFromJson(json);
}

/// 저율과세 결과
@freezed
class LowRateTaxResult with _$LowRateTaxResult {
  const factory LowRateTaxResult({
    required double applicableTaxRate, // 적용세율
    required int totalTaxPayment, // 총납부세액
    required int netReceivableAmount, // 세후실수령액
  }) = _LowRateTaxResult;

  factory LowRateTaxResult.fromJson(Map<String, dynamic> json) =>
      _$LowRateTaxResultFromJson(json);
}

/// 연금 수령 시뮬레이션 결과
@freezed
class PensionReceiptSimulationResult with _$PensionReceiptSimulationResult {
  const factory PensionReceiptSimulationResult({
    required bool exceedsThreshold, // 기준금액초과여부
    required ComprehensiveTaxResult comprehensiveTax, // 종합과세
    required SeparateTaxResult separateTax, // 분리과세
    required LowRateTaxResult lowRateTax, // 저율과세
  }) = _PensionReceiptSimulationResult;

  factory PensionReceiptSimulationResult.fromJson(Map<String, dynamic> json) =>
      _$PensionReceiptSimulationResultFromJson(json);
}

/// 자산 변화 연차 데이터
@freezed
class AssetChangeYearData with _$AssetChangeYearData {
  const factory AssetChangeYearData({
    required int year, // 연차
    required int age, // 나이
    required int beginningAsset, // 기초자산
    required int annualOperatingIncome, // 연간운용수익
    required int pretaxWithdrawal, // 세전인출액
    required int taxPayment, // 납부세액
    required int aftertaxWithdrawal, // 세후인출액
    required int endingAsset, // 기말자산
    required int nonDeductiblePrincipalBalance, // 비과세원금잔액
  }) = _AssetChangeYearData;

  factory AssetChangeYearData.fromJson(Map<String, dynamic> json) =>
      _$AssetChangeYearDataFromJson(json);
}

/// 자산 변화 시뮬레이션 결과
@freezed
class AssetChangeSimulationResult with _$AssetChangeSimulationResult {
  const factory AssetChangeSimulationResult({
    required int startingAsset, // 시작자산
    required double averageReturnRate, // 연평균수익률
    required int annualRequestedAmount, // 연간수령요청액
    required int expectedDepletionAge, // 예상고갈나이
    required int sustainableYears, // 지속가능년수
    required List<AssetChangeYearData> yearlyData, // 연차별데이터
  }) = _AssetChangeSimulationResult;

  factory AssetChangeSimulationResult.fromJson(Map<String, dynamic> json) =>
      _$AssetChangeSimulationResultFromJson(json);
}

/// 투자 비교 연차 데이터
@freezed
class InvestmentComparisonYearData with _$InvestmentComparisonYearData {
  const factory InvestmentComparisonYearData({
    required int year, // 연차
    required int age, // 나이
    required int regularAccountBalance, // 일반계좌잔액
    required int regularAccountAnnualTax, // 일반계좌연간세금
    required int pensionAccountBalance, // 연금계좌잔액
    required int pensionAccountAnnualTax, // 연금계좌연간세금
    required int cumulativeTaxDifference, // 누적세금차이
  }) = _InvestmentComparisonYearData;

  factory InvestmentComparisonYearData.fromJson(Map<String, dynamic> json) =>
      _$InvestmentComparisonYearDataFromJson(json);
}

/// 일반계좌 투자 결과
@freezed
class RegularAccountInvestmentResult with _$RegularAccountInvestmentResult {
  const factory RegularAccountInvestmentResult({
    required int totalInvestmentPrincipal, // 총투자원금
    required int pretaxTotalValue, // 세전총평가액
    required int cumulativeDividendTax, // 배당세누적
    required int capitalGainsTax, // 양도소득세
    required int totalTax, // 총세금
    required int netReceivableAmount, // 세후수령액
  }) = _RegularAccountInvestmentResult;

  factory RegularAccountInvestmentResult.fromJson(Map<String, dynamic> json) =>
      _$RegularAccountInvestmentResultFromJson(json);
}

/// 연금계좌 투자 결과
@freezed
class PensionAccountInvestmentResult with _$PensionAccountInvestmentResult {
  const factory PensionAccountInvestmentResult({
    required int totalInvestmentPrincipal, // 총투자원금
    required int pretaxTotalValue, // 세전총평가액
    required int nonDeductiblePrincipal, // 비과세원금
    required int taxableReturn, // 과세대상수익
    required int pensionIncomeTax, // 연금소득세
    required int totalTax, // 총세금
    required int netReceivableAmount, // 세후수령액
  }) = _PensionAccountInvestmentResult;

  factory PensionAccountInvestmentResult.fromJson(Map<String, dynamic> json) =>
      _$PensionAccountInvestmentResultFromJson(json);
}

/// 절약 효과
@freezed
class SavingsEffect with _$SavingsEffect {
  const factory SavingsEffect({
    required int taxSavings, // 세금절약액
    required double savingsRate, // 절약률
    required double additionalReturnRate, // 추가수익률
  }) = _SavingsEffect;

  factory SavingsEffect.fromJson(Map<String, dynamic> json) =>
      _$SavingsEffectFromJson(json);
}

/// 투자 비교 결과
@freezed
class InvestmentComparisonResult with _$InvestmentComparisonResult {
  const factory InvestmentComparisonResult({
    required RegularAccountInvestmentResult regularAccountInvestment, // 일반계좌투자
    required PensionAccountInvestmentResult pensionAccountInvestment, // 연금계좌투자
    required SavingsEffect savingsEffect, // 절약효과
    required List<InvestmentComparisonYearData> yearlyComparisonData, // 연차별비교데이터
  }) = _InvestmentComparisonResult;

  factory InvestmentComparisonResult.fromJson(Map<String, dynamic> json) =>
      _$InvestmentComparisonResultFromJson(json);
}

// Extensions for convenient access
extension TaxDeductionResultExtensions on TaxDeductionResult {
  int get pensionSavingsDeduction => deductibleAmount >= 6000000 ? 6000000 : deductibleAmount;
  int get irpDeduction => deductibleAmount > 6000000 ? (deductibleAmount - 6000000).clamp(0, 3000000) : 0;
  int get totalDeductibleAmount => deductibleAmount;
}

extension FutureAssetResultExtensions on FutureAssetResult {
  int get retirementAsset => totalFutureValue;
  int get totalReturn => totalExpectedReturn;
}

extension PensionReceiptSimulationResultExtensions on PensionReceiptSimulationResult {
  int get monthlyAmount => comprehensiveTax.netReceivableAmount;
  int get comprehensiveTaxMonthlyAmount => comprehensiveTax.netReceivableAmount;
  int get comprehensiveTaxAmount => comprehensiveTax.totalTaxPayment;
  int get separateTaxMonthlyAmount => separateTax.netReceivableAmount;
  int get separateTaxAmount => separateTax.totalTaxPayment;
  int get lowRateTaxMonthlyAmount => lowRateTax.netReceivableAmount;
  int get lowRateTaxAmount => lowRateTax.totalTaxPayment;
  String get recommendedTaxType {
    final amounts = [
      (comprehensiveTax.netReceivableAmount, '종합과세'),
      (separateTax.netReceivableAmount, '분리과세'),
      (lowRateTax.netReceivableAmount, '저율과세'),
    ];
    amounts.sort((a, b) => b.$1.compareTo(a.$1));
    return amounts.first.$2;
  }
}

extension AssetChangeSimulationResultExtensions on AssetChangeSimulationResult {
  List<AssetChangeYearData> get yearlyAssetData => yearlyData;
  bool get isDepleted => expectedDepletionAge > 0;
  int get depletionAge => expectedDepletionAge;
}

extension AssetChangeYearDataExtensions on AssetChangeYearData {
  double get balance => endingAsset.toDouble();
}
