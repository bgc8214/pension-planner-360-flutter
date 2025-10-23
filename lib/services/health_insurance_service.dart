/// Health Insurance Service
///
/// Calculate health insurance premiums based on 2025 standards
/// - Local subscriber premium calculation
/// - Dependent eligibility determination
/// - Long-term care insurance included

import '../data/models/calculation_results.dart';

class HealthInsuranceService {
  /// 2025 Health Insurance Constants
  static const double healthInsuranceRate = 0.0778; // 7.78% (2025 standard)
  static const double longTermCareRate = 0.1295; // 12.95% of health insurance

  /// Dependent disqualification criteria
  static const int dependentIncomeLimit = 20000000; // 20 million won (2025 standard)
  static const int dependentIncomeLimitMonthly = 1660000; // ~1.66 million won
  static const int dependentAssetLimit = 540000000; // 540 million won

  /// Calculate health insurance for pension income
  ///
  /// [annualPensionIncome]: Annual pension amount
  /// [assetValue]: Asset value (optional, for dependent eligibility)
  /// Returns: HealthInsuranceResult
  static HealthInsuranceResult calculateHealthInsurance({
    required int annualPensionIncome,
    int assetValue = 0,
  }) {
    final isDependentEligible = _checkDependentEligibility(
      annualPensionIncome: annualPensionIncome,
      assetValue: assetValue,
    );

    final localMemberPremium = _calculateLocalMemberPremium(
      annualPensionIncome: annualPensionIncome,
    );

    return HealthInsuranceResult(
      monthlyHealthInsurance: isDependentEligible ? 0 : localMemberPremium['monthlyHealthInsurance'] as int,
      monthlyLongTermCare: isDependentEligible ? 0 : localMemberPremium['monthlyLongTermCare'] as int,
      monthlyTotalInsurance: isDependentEligible ? 0 : localMemberPremium['monthlyTotal'] as int,
      annualTotalInsurance: isDependentEligible ? 0 : localMemberPremium['annualTotal'] as int,
      isDependentEligible: isDependentEligible,
      dependentIncomeLimit: dependentIncomeLimit,
      dependentAssetLimit: dependentAssetLimit,
    );
  }

  /// Check dependent eligibility
  ///
  /// [annualPensionIncome]: Annual pension amount
  /// [assetValue]: Asset value (optional, default 0)
  /// Returns: true if dependent eligibility can be maintained
  static bool _checkDependentEligibility({
    required int annualPensionIncome,
    int assetValue = 0,
  }) {
    // Income criteria check
    if (annualPensionIncome > dependentIncomeLimit) {
      return false;
    }

    // Asset criteria check
    if (assetValue > dependentAssetLimit) {
      return false;
    }

    return true;
  }

  /// Calculate local subscriber health insurance premium (pension income only)
  ///
  /// [annualPensionIncome]: Annual pension amount
  /// Returns: Map with monthly/annual premiums
  static Map<String, dynamic> _calculateLocalMemberPremium({
    required int annualPensionIncome,
  }) {
    // Monthly average pension income
    final monthlyAverageIncome = annualPensionIncome / 12;

    // Income-based premium calculation
    // Simplified calculation using a fixed rate (actual is complex point system)
    final monthlyIncomePremium = (monthlyAverageIncome * healthInsuranceRate).round();

    // Property premium assumed 0 (actual requires property information)
    final monthlyPropertyPremium = 0;

    // Car premium assumed 0
    final monthlyCarPremium = 0;

    // Health insurance premium (income + property + car)
    final monthlyHealthInsurance = monthlyIncomePremium + monthlyPropertyPremium + monthlyCarPremium;

    // Long-term care insurance (12.95% of health insurance)
    final monthlyLongTermCare = (monthlyHealthInsurance * longTermCareRate).round();

    // Total premium
    final monthlyTotal = monthlyHealthInsurance + monthlyLongTermCare;
    final annualTotal = monthlyTotal * 12;

    return {
      'monthlyHealthInsurance': monthlyHealthInsurance,
      'monthlyLongTermCare': monthlyLongTermCare,
      'monthlyTotal': monthlyTotal,
      'annualTotal': annualTotal,
      'monthlyAverageIncome': monthlyAverageIncome.round(),
      'monthlyIncomePremium': monthlyIncomePremium,
    };
  }
}
