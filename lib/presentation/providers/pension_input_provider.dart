import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/pension_input.dart';

part 'pension_input_provider.g.dart';

/// 연금 입력값 상태 관리 Provider
@riverpod
class PensionInputNotifier extends _$PensionInputNotifier {
  @override
  PensionInput build() {
    // 기본값 설정 (웹 버전과 동일)
    return const PensionInput(
      totalSalary: 50000000,
      pensionContribution: 3000000,
      pensionExcessContribution: 0,
      irpContribution: 0,
      irpExcessContribution: 0,
      isOver50: false,
      currentAge: 35,
      retirementAge: 60,
      averageReturnRate: 5.0,
      annualPensionAmount: 12000000,
      otherIncome: 0,
    );
  }

  // 입력값 업데이트 메서드들
  void updateTotalSalary(int value) {
    state = state.copyWith(totalSalary: value);
  }

  void updatePensionContribution(int value) {
    state = state.copyWith(pensionContribution: value);
  }

  void updatePensionExcessContribution(int value) {
    state = state.copyWith(pensionExcessContribution: value);
  }

  void updateIRPContribution(int value) {
    state = state.copyWith(irpContribution: value);
  }

  void updateIRPExcessContribution(int value) {
    state = state.copyWith(irpExcessContribution: value);
  }

  void updateIsOver50(bool value) {
    state = state.copyWith(isOver50: value);
  }

  void updateCurrentAge(int value) {
    state = state.copyWith(currentAge: value);
  }

  void updateRetirementAge(int value) {
    state = state.copyWith(retirementAge: value);
  }

  void updateAverageReturnRate(double value) {
    state = state.copyWith(averageReturnRate: value);
  }

  void updateAnnualPensionAmount(int value) {
    state = state.copyWith(annualPensionAmount: value);
  }

  void updateOtherIncome(int value) {
    state = state.copyWith(otherIncome: value);
  }

  // 전체 입력값 업데이트
  void updateAll(PensionInput input) {
    state = input;
  }

  // 초기화
  void reset() {
    state = build();
  }
}