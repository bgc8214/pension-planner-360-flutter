import 'dart:math' as math;
import '../data/models/pension_input.dart';
import '../data/models/calculation_results.dart';

/// 연금 플래너 계산 서비스
///
/// 웹 버전의 calculations.ts를 Dart로 변환
/// 모든 계산 로직을 포함하는 통합 서비스 클래스
class CalculationService {
  /// 모듈 1: 세액공제 계산 (세제혜택 구분 반영)
  ///
  /// 웹 버전: 세액공제계산 함수
  static TaxDeductionResult calculateTaxDeduction(PensionInput input) {
    final totalSalary = input.totalSalary;
    final pensionContribution = input.pensionContribution;
    final pensionExcessContribution = input.pensionExcessContribution;
    final irpContribution = input.irpContribution;
    final irpExcessContribution = input.irpExcessContribution;

    // 1. 총 납입액 계산 (세액공제 대상 + 한도 초과분)
    final totalContribution = pensionContribution +
        pensionExcessContribution +
        irpContribution +
        irpExcessContribution;

    // 2. 세액공제 대상금액 계산 (한도 적용)
    const pensionLimit = 6000000; // 연금저축 한도 600만원
    const totalLimit = 9000000; // 전체 한도 900만원

    final pensionDeductible = math.min(pensionContribution, pensionLimit);
    final irpAvailableLimit = totalLimit - pensionDeductible;
    final irpDeductible = math.min(irpContribution, irpAvailableLimit);

    final deductibleAmount = pensionDeductible + irpDeductible;
    final excessAmount = pensionExcessContribution +
        irpExcessContribution +
        math.max(0, pensionContribution - pensionDeductible) +
        math.max(0, irpContribution - irpAvailableLimit);

    // 3. 세액공제율 결정 (지방소득세 포함)
    final applicableTaxRate = (totalSalary <= 55000000) ? 0.165 : 0.132;

    // 4. 최종 예상 환급 세액 계산
    final expectedRefund = (deductibleAmount * applicableTaxRate).round();

    return TaxDeductionResult(
      totalContribution: totalContribution,
      deductibleAmount: deductibleAmount.toInt(),
      excessAmount: excessAmount.toInt(),
      applicableTaxRate: applicableTaxRate,
      expectedRefund: expectedRefund,
    );
  }

  /// 모듈 2: 미래 자산 계산 (세제혜택 구분 반영)
  ///
  /// 웹 버전: 미래자산계산 함수
  static FutureAssetResult calculateFutureAsset(
    PensionInput input,
    TaxDeductionResult taxDeductionResult,
  ) {
    final currentAge = input.currentAge;
    final retirementAge = input.retirementAge;
    final averageReturnRate = input.averageReturnRate;

    final totalContribution = taxDeductionResult.totalContribution;
    final deductibleAmount = taxDeductionResult.deductibleAmount;
    final excessAmount = taxDeductionResult.excessAmount;

    // 1. 납입 기간 계산
    final contributionPeriod = retirementAge - currentAge;

    // 2. 연간 납입액 구분 (정확한 계산)
    final annualDeductibleAmount = deductibleAmount;
    final annualExcessAmount = excessAmount;
    final annualTotalContribution = totalContribution;

    // 3. 미래가치 계산 함수 (연금 적립식)
    double calculateFutureValue(int annualContribution) {
      final returnRate = averageReturnRate / 100;

      if (returnRate == 0) {
        return annualContribution * contributionPeriod.toDouble();
      } else {
        return annualContribution *
            ((math.pow(1 + returnRate, contributionPeriod) - 1) / returnRate);
      }
    }

    // 4. 구분별 미래가치 계산
    final deductiblePrincipalFutureValue =
        calculateFutureValue(annualDeductibleAmount).round();
    final nonDeductiblePrincipalFutureValue =
        calculateFutureValue(annualExcessAmount).round();
    final totalFutureValue =
        deductiblePrincipalFutureValue + nonDeductiblePrincipalFutureValue;

    // 5. 원금과 수익 구분
    final totalPrincipal = annualTotalContribution * contributionPeriod;
    // PRD v2.4: 비과세원금은 세액공제 한도를 초과하는 실제 납입 원금
    final nonDeductiblePrincipal =
        math.max(annualTotalContribution - 9000000, 0) * contributionPeriod;
    final totalExpectedReturn = totalFutureValue - totalPrincipal;

    return FutureAssetResult(
      totalPrincipal: totalPrincipal,
      deductiblePrincipal: deductiblePrincipalFutureValue,
      nonDeductiblePrincipal: nonDeductiblePrincipal,
      totalExpectedReturn: totalExpectedReturn,
      totalFutureValue: totalFutureValue,
    );
  }

  /// 연금소득공제 계산 함수
  static int _calculatePensionIncomeDeduction(int amount) {
    int deduction;

    if (amount <= 3500000) {
      deduction = amount;
    } else if (amount <= 7000000) {
      deduction = (3500000 + (amount - 3500000) * 0.4).round();
    } else if (amount <= 14000000) {
      deduction = (4900000 + (amount - 7000000) * 0.2).round();
    } else {
      deduction = (6300000 + (amount - 14000000) * 0.1).round();
    }

    return math.min(deduction, 9000000);
  }

  /// 누진세율표 계산 함수
  static int _calculateIncomeTax(int taxBase) {
    const brackets = [
      {'limit': 14000000, 'rate': 0.06, 'deduction': 0},
      {'limit': 50000000, 'rate': 0.15, 'deduction': 1260000},
      {'limit': 88000000, 'rate': 0.24, 'deduction': 5760000},
      {'limit': 150000000, 'rate': 0.35, 'deduction': 15440000},
      {'limit': 300000000, 'rate': 0.38, 'deduction': 19940000},
      {'limit': 500000000, 'rate': 0.40, 'deduction': 25940000},
      {'limit': 1000000000, 'rate': 0.42, 'deduction': 35940000},
      {'limit': double.infinity, 'rate': 0.45, 'deduction': 65940000},
    ];

    for (final bracket in brackets) {
      if (taxBase <= (bracket['limit'] as num)) {
        return math.max(
            0,
            (taxBase * (bracket['rate'] as double) -
                    (bracket['deduction'] as int))
                .round());
      }
    }

    return 0;
  }

  /// 저율과세 세율 결정 함수
  static double _determineLowRateTax(int startAge) {
    if (startAge < 70) {
      return 0.055;
    } else if (startAge < 80) {
      return 0.044;
    } else {
      return 0.033;
    }
  }

  /// 모듈 3: 연금 수령 시뮬레이션 (세제혜택 구분 과세 반영)
  ///
  /// 웹 버전: 연금수령시뮬레이션계산 함수
  static PensionReceiptSimulationResult simulatePensionReceipt(
    PensionInput input,
    FutureAssetResult futureAssetResult,
    int receiptStartAge,
  ) {
    final annualPensionAmount = input.annualPensionAmount;
    final otherIncome = input.otherIncome;

    // 1. 모듈 3은 "비과세원금 소진 후" 가정이므로 연간수령액 전액이 과세대상
    final annualTaxableAmount = annualPensionAmount;

    // 2. 1,500만원 기준 판별 (연간 수령액 기준)
    final exceedsThreshold = annualPensionAmount > 15000000;

    // 저율과세 계산
    final lowRateapplicableTaxRate = _determineLowRateTax(receiptStartAge);
    final lowRateTotalTax =
        (annualPensionAmount * lowRateapplicableTaxRate).round();
    final lowRateNetAmount = annualPensionAmount - lowRateTotalTax;

    final lowRateTax = LowRateTaxResult(
      applicableTaxRate: lowRateapplicableTaxRate,
      totalTaxPayment: lowRateTotalTax,
      netReceivableAmount: lowRateNetAmount,
    );

    // 종합과세 계산
    final pensionIncomeDeduction =
        _calculatePensionIncomeDeduction(annualTaxableAmount);
    final pensionIncomeAmount =
        math.max(0, annualTaxableAmount - pensionIncomeDeduction);
    final totalIncomeAmount = pensionIncomeAmount + otherIncome;

    const personalDeduction = 1500000; // 본인 기본공제 150만원
    final taxBase = math.max(0, totalIncomeAmount - personalDeduction);
    final calculatedIncomeTax = _calculateIncomeTax(taxBase);
    final localIncomeTax = (calculatedIncomeTax * 0.1).round();
    final comprehensiveTotalTax = calculatedIncomeTax + localIncomeTax;
    final comprehensiveNetAmount = annualPensionAmount - comprehensiveTotalTax;

    final comprehensiveTax = ComprehensiveTaxResult(
      pensionIncomeDeduction: pensionIncomeDeduction,
      pensionIncomeAmount: pensionIncomeAmount,
      totalIncomeAmount: totalIncomeAmount,
      personalDeduction: personalDeduction,
      taxBase: taxBase,
      calculatedIncomeTax: calculatedIncomeTax,
      localIncomeTax: localIncomeTax,
      totalTaxPayment: comprehensiveTotalTax,
      netReceivableAmount: comprehensiveNetAmount,
    );

    // 분리과세 계산
    const separateapplicableTaxRate = 0.165;
    final separateTotalTax =
        (annualTaxableAmount * separateapplicableTaxRate).round();
    final separateNetAmount = annualPensionAmount - separateTotalTax;

    final separateTax = SeparateTaxResult(
      applicableTaxRate: separateapplicableTaxRate,
      totalTaxPayment: separateTotalTax,
      netReceivableAmount: separateNetAmount,
    );

    return PensionReceiptSimulationResult(
      exceedsThreshold: exceedsThreshold,
      comprehensiveTax: comprehensiveTax,
      separateTax: separateTax,
      lowRateTax: lowRateTax,
    );
  }

  /// 모듈 4: 자산 변화 시뮬레이션 계산 (PRD v2.4: 비과세원금 우선 인출 로직)
  ///
  /// 웹 버전: 자산변화시뮬레이션계산 함수
  static AssetChangeSimulationResult simulateAssetChange(
    int startingAsset,
    double averageReturnRate,
    int annualRequestedAmount,
    int retirementAge,
    int nonDeductiblePrincipal,
    int comprehensiveTaxPayment,
  ) {
    final yearlyData = <AssetChangeYearData>[];
    var currentAsset = startingAsset;
    var nonDeductiblePrincipalBalance = nonDeductiblePrincipal;
    var year = 1;
    var currentAge = retirementAge;

    const maxAge = 100;
    final maxYears = maxAge - retirementAge;

    while (currentAsset >= annualRequestedAmount && year <= maxYears) {
      final beginningAsset = currentAsset;
      final annualOperatingIncome =
          (beginningAsset * (averageReturnRate / 100)).round();

      // PRD v2.4: 비과세원금 우선 인출 로직 (부분 과세 적용)
      int taxPayment;
      int aftertaxWithdrawal;
      final pretaxWithdrawal = annualRequestedAmount;

      if (nonDeductiblePrincipalBalance >= annualRequestedAmount) {
        // 비과세원금이 연간수령액 이상인 경우: 전액 비과세
        taxPayment = 0;
        aftertaxWithdrawal = annualRequestedAmount;
        nonDeductiblePrincipalBalance -= annualRequestedAmount;
      } else if (nonDeductiblePrincipalBalance > 0) {
        // 비과세원금이 일부 남아있는 경우: 부분 과세
        final nonDeductibleWithdrawal = nonDeductiblePrincipalBalance;
        final taxableWithdrawal =
            annualRequestedAmount - nonDeductibleWithdrawal;

        // 과세 부분에만 세금 적용 (비율 계산)
        final taxableRatio = taxableWithdrawal / annualRequestedAmount;
        taxPayment = (comprehensiveTaxPayment * taxableRatio).round();
        aftertaxWithdrawal = annualRequestedAmount - taxPayment;
        nonDeductiblePrincipalBalance = 0;
      } else {
        // 비과세원금 완전 소진된 경우: 전액 과세
        taxPayment = comprehensiveTaxPayment;
        aftertaxWithdrawal = annualRequestedAmount - taxPayment;
      }

      final endingAsset =
          beginningAsset + annualOperatingIncome - pretaxWithdrawal;

      yearlyData.add(AssetChangeYearData(
        year: year,
        age: currentAge,
        beginningAsset: beginningAsset,
        annualOperatingIncome: annualOperatingIncome,
        pretaxWithdrawal: pretaxWithdrawal,
        taxPayment: taxPayment,
        aftertaxWithdrawal: aftertaxWithdrawal,
        endingAsset: endingAsset,
        nonDeductiblePrincipalBalance: nonDeductiblePrincipalBalance,
      ));

      currentAsset = endingAsset;
      year++;
      currentAge++;
    }

    final sustainableYears = yearlyData.length;
    final expectedDepletionAge = retirementAge + sustainableYears;

    return AssetChangeSimulationResult(
      startingAsset: startingAsset,
      averageReturnRate: averageReturnRate,
      annualRequestedAmount: annualRequestedAmount,
      expectedDepletionAge: expectedDepletionAge,
      sustainableYears: sustainableYears,
      yearlyData: yearlyData,
    );
  }

  /// 모듈 5: 투자 방식 비교 (일반계좌 해외주식 vs 연금계좌 해외주식 ETF)
  ///
  /// 웹 버전: 투자비교계산 함수
  static InvestmentComparisonResult compareInvestment(
    PensionInput input,
    FutureAssetResult futureAssetResult,
    PensionReceiptSimulationResult pensionReceiptResult,
  ) {
    final currentAge = input.currentAge;
    final retirementAge = input.retirementAge;
    final averageReturnRate = input.averageReturnRate;
    final annualPensionAmount = input.annualPensionAmount;

    final totalPrincipal = futureAssetResult.totalPrincipal;
    final nonDeductiblePrincipal = futureAssetResult.nonDeductiblePrincipal;

    // 투자 기간 및 수령 기간
    final investmentPeriod = retirementAge - currentAge;
    const maxReceiptAge = 100;
    final maxReceiptPeriod = maxReceiptAge - retirementAge;

    // QQQ ETF 기준: 배당수익률 0.47%
    const dividendYield = 0.0047;

    // 미래가치 계산 함수 (연금 적립식)
    double calculateFutureValue(int annualContribution) {
      final returnRate = averageReturnRate / 100;

      if (returnRate == 0) {
        return annualContribution * investmentPeriod.toDouble();
      } else {
        return annualContribution *
            ((math.pow(1 + returnRate, investmentPeriod) - 1) / returnRate);
      }
    }

    // === 일반계좌 해외주식 투자 ===
    final regularAnnualContribution = totalPrincipal ~/ investmentPeriod;
    final regularTotalPrincipal = totalPrincipal;
    final regularInitialAsset =
        calculateFutureValue(regularAnnualContribution).round();

    // 적립 기간 동안의 배당세 계산
    var accumulatedDividendTax = 0.0;
    var cumulativeInvestment = 0;

    for (var y = 1; y <= investmentPeriod; y++) {
      cumulativeInvestment += regularAnnualContribution;
      final annualDividend = cumulativeInvestment * dividendYield;
      final annualDividendTax = annualDividend * 0.154;
      accumulatedDividendTax += annualDividendTax;
    }

    // === 연금계좌 해외주식 ETF 투자 ===
    final pensionInitialAsset = regularInitialAsset; // 동일한 수익률 가정
    var pensionCurrentAsset = pensionInitialAsset;
    var pensionNonDeductibleBalance = nonDeductiblePrincipal;
    var pensionTotalTax = 0.0;

    final comprehensiveTaxPayment =
        pensionReceiptResult.comprehensiveTax.totalTaxPayment;

    // 연차별 비교 데이터 배열
    final yearlyComparisonData = <InvestmentComparisonYearData>[];

    // 일반계좌 시뮬레이션 변수
    var regularCurrentAsset = regularInitialAsset;
    var regularCurrentPrincipal = regularTotalPrincipal; // 평균 취득가 추적용
    var regularTotalDividendTax = accumulatedDividendTax;
    var regularTotalCapitalGainsTax = 0.0;

    // 연금 수령 시뮬레이션 (두 계좌 동시 진행)
    for (var y = 1; y <= maxReceiptPeriod; y++) {
      // 두 계좌 모두 자산이 부족하면 종료
      if (regularCurrentAsset < annualPensionAmount &&
          pensionCurrentAsset < annualPensionAmount) {
        break;
      }

      // === 일반계좌 처리 ===
      var regularAnnualTax = 0.0;

      if (regularCurrentAsset >= annualPensionAmount) {
        // 1. 배당금 수령 및 배당세
        final annualDividend =
            (regularCurrentAsset * dividendYield).round();
        final annualDividendTax = (annualDividend * 0.154).round();
        regularTotalDividendTax += annualDividendTax;
        regularAnnualTax += annualDividendTax;

        // 2. 자본 수익 (운용 수익)
        final capitalReturnRate = averageReturnRate / 100 - dividendYield;
        final annualCapitalReturn =
            (regularCurrentAsset * capitalReturnRate).round();

        // 3. 인출 금액만큼 매도 → 양도소득세 계산
        final sellAmount = annualPensionAmount;
        final sellRatio = sellAmount / regularCurrentAsset;
        final sellCost = (regularCurrentPrincipal * sellRatio).round();
        final capitalGain = math.max(0, sellAmount - sellCost);
        final annualCapitalGainsTax = (capitalGain * 0.22).round();
        regularTotalCapitalGainsTax += annualCapitalGainsTax;
        regularAnnualTax += annualCapitalGainsTax;

        // 4. 자산 업데이트
        regularCurrentAsset =
            regularCurrentAsset + annualCapitalReturn - sellAmount;
        regularCurrentPrincipal = regularCurrentPrincipal - sellCost;
      }

      // === 연금계좌 처리 ===
      var pensionAnnualTax = 0.0;

      if (pensionCurrentAsset >= annualPensionAmount) {
        final annualOperatingIncome =
            (pensionCurrentAsset * (averageReturnRate / 100)).round();

        // 비과세원금 우선 인출 로직
        if (pensionNonDeductibleBalance >= annualPensionAmount) {
          pensionAnnualTax = 0;
          pensionNonDeductibleBalance -= annualPensionAmount;
        } else if (pensionNonDeductibleBalance > 0) {
          final taxableWithdrawal =
              annualPensionAmount - pensionNonDeductibleBalance;
          final taxableRatio = taxableWithdrawal / annualPensionAmount;
          pensionAnnualTax =
              (comprehensiveTaxPayment * taxableRatio).round().toDouble();
          pensionNonDeductibleBalance = 0;
        } else {
          pensionAnnualTax = comprehensiveTaxPayment.toDouble();
        }

        pensionTotalTax += pensionAnnualTax;
        pensionCurrentAsset =
            pensionCurrentAsset + annualOperatingIncome - annualPensionAmount;
      }

      // 누적 세금 계산
      final regularCumulativeTax =
          regularTotalDividendTax + regularTotalCapitalGainsTax;
      final cumulativeTaxDifference =
          regularCumulativeTax - pensionTotalTax;

      yearlyComparisonData.add(InvestmentComparisonYearData(
        year: y,
        age: retirementAge + y,
        regularAccountBalance: regularCurrentAsset.round(),
        regularAccountAnnualTax: regularAnnualTax.round(),
        pensionAccountBalance: pensionCurrentAsset.round(),
        pensionAccountAnnualTax: pensionAnnualTax.round(),
        cumulativeTaxDifference: cumulativeTaxDifference.round(),
      ));
    }

    final regularTotalTax =
        regularTotalDividendTax + regularTotalCapitalGainsTax;
    final pensionTotalTaxInt = pensionTotalTax.round();
    final regularNetAmount = regularInitialAsset - regularTotalTax.round();
    final pensionNetAmount = pensionInitialAsset - pensionTotalTaxInt;

    // === 절약 효과 계산 ===
    final taxSavings = regularTotalTax - pensionTotalTax;
    final savingsRate = regularTotalTax > 0
        ? (taxSavings / regularTotalTax) * 100
        : 0.0;
    final additionalReturnRate = regularTotalPrincipal > 0
        ? (taxSavings / regularTotalPrincipal) * 100
        : 0.0;

    return InvestmentComparisonResult(
      regularAccountInvestment: RegularAccountInvestmentResult(
        totalInvestmentPrincipal: regularTotalPrincipal,
        pretaxTotalValue: regularInitialAsset,
        cumulativeDividendTax: regularTotalDividendTax.round(),
        capitalGainsTax: regularTotalCapitalGainsTax.round(),
        totalTax: regularTotalTax.round(),
        netReceivableAmount: regularNetAmount,
      ),
      pensionAccountInvestment: PensionAccountInvestmentResult(
        totalInvestmentPrincipal: regularTotalPrincipal,
        pretaxTotalValue: pensionInitialAsset,
        nonDeductiblePrincipal: nonDeductiblePrincipal,
        taxableReturn: pensionInitialAsset - regularTotalPrincipal,
        pensionIncomeTax: pensionTotalTaxInt,
        totalTax: pensionTotalTaxInt,
        netReceivableAmount: pensionNetAmount,
      ),
      savingsEffect: SavingsEffect(
        taxSavings: taxSavings.round(),
        savingsRate: (savingsRate * 10).round() / 10,
        additionalReturnRate: (additionalReturnRate * 10).round() / 10,
      ),
      yearlyComparisonData: yearlyComparisonData,
    );
  }
}
