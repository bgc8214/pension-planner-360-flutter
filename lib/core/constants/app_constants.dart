/// 2025년 연금저축 및 IRP 세법 상수
class TaxConstants {
  // 세액공제 한도
  static const int pensionDeductionLimit = 6000000; // 연금저축 한도 600만원
  static const int totalDeductionLimit = 9000000; // 전체 한도 900만원

  // 세액공제율
  static const double highIncomeTaxRate = 0.132; // 총급여 5,500만원 초과
  static const double lowIncomeTaxRate = 0.165; // 총급여 5,500만원 이하
  static const int incomeThreshold = 55000000; // 기준 총급여액

  // 연금 수령 과세 기준
  static const int pensionReceiptThreshold = 15000000; // 1,500만원

  // 분리과세율
  static const double separateTaxRate = 0.165; // 16.5%

  // 저율과세율
  static const double lowTaxRateUnder70 = 0.055; // 70세 미만 5.5%
  static const double lowTaxRateUnder80 = 0.044; // 70~80세 미만 4.4%
  static const double lowTaxRateOver80 = 0.033; // 80세 이상 3.3%

  // 지방소득세율
  static const double localTaxRate = 0.1; // 10%

  // 인적공제
  static const int personalDeduction = 1500000; // 본인 기본공제 150만원

  // 일반계좌 해외주식 세율
  static const double dividendTaxRate = 0.154; // 배당소득세 15.4%
  static const double capitalGainsTaxRate = 0.22; // 양도소득세 22%

  // QQQ ETF 배당수익률
  static const double qqqDividendYield = 0.0047; // 0.47%
}

/// 앱 설정 상수
class AppSettings {
  static const int defaultCurrentAge = 35;
  static const int defaultRetirementAge = 60;
  static const double defaultReturnRate = 7.0; // 7%
  static const int defaultAnnualAmount = 3000000; // 300만원
  static const int maxAge = 100;
  static const int minAge = 20;
  static const double minReturnRate = 0.0;
  static const double maxReturnRate = 30.0;
}
