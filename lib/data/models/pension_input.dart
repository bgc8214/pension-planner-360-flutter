import 'package:freezed_annotation/freezed_annotation.dart';

part 'pension_input.freezed.dart';
part 'pension_input.g.dart';

/// 연금 플래너 입력값 모델
///
/// 웹 버전의 한글 변수명을 영문으로 변환하여 사용
/// (Dart는 한글 식별자를 공식 지원하지 않음)
@freezed
class PensionInput with _$PensionInput {
  const factory PensionInput({
    // 모듈 1 입력 (세액공제 계산)
    @Default(90000000) int totalSalary, // 총급여액
    @Default(6000000) int pensionContribution, // 연금저축납입액
    @Default(0) int pensionExcessContribution, // 연금저축한도초과납입액
    @Default(3000000) int irpContribution, // IRP납입액
    @Default(0) int irpExcessContribution, // IRP한도초과납입액
    @Default(true) bool isOver50, // 만50세이상

    // 모듈 2 입력 (미래 자산 계산)
    @Default(35) int currentAge, // 현재나이
    @Default(60) int retirementAge, // 은퇴나이
    @Default(5.0) double averageReturnRate, // 연평균수익률 (% 단위)

    // 모듈 3 입력 (연금 수령 시뮬레이션)
    @Default(50000000) int annualPensionAmount, // 연간수령액
    @Default(0) int otherIncome, // 연금외소득
  }) = _PensionInput;

  factory PensionInput.fromJson(Map<String, dynamic> json) =>
      _$PensionInputFromJson(json);
}
