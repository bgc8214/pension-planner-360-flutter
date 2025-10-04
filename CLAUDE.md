# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

```bash
# Flutter 의존성 설치
flutter pub get

# 코드 생성 (Freezed, Riverpod, Hive 등)
flutter pub run build_runner build --delete-conflicting-outputs

# 코드 생성 (watch 모드)
flutter pub run build_runner watch --delete-conflicting-outputs

# 앱 실행 (iOS)
flutter run -d ios

# 앱 실행 (Android)
flutter run -d android

# 테스트 실행
flutter test

# 린트 체크
flutter analyze

# 빌드 (iOS)
flutter build ios

# 빌드 (Android)
flutter build apk
```

## Project Overview

연금저축 및 IRP 전략 시뮬레이터 Flutter 모바일 앱 (iOS/Android)

**원본 웹 앱**: React 18 + TypeScript로 개발된 웹 버전을 Flutter로 이식
- 웹 버전 경로: `/Users/boss.back/Desktop/cursor/retire`
- GitHub Pages: https://bgc8214.github.io/pension-planner-360
- 웹 소스코드의 계산 로직(`src/utils/calculations.ts`)을 Dart로 변환 필요

## Architecture

### Technology Stack
- **Frontend**: Flutter 3.24+ with Dart 3.6+
- **State Management**: Riverpod 2.x (React Context와 유사)
- **Local Storage**: Hive 2.x (NoSQL embedded database)
- **Charts**: fl_chart (자산 변화 및 비교 그래프)
- **Styling**: Material Design 3 + Google Fonts (Noto Sans)
- **Code Generation**: Freezed (불변 데이터 클래스), json_serializable
- **Testing**: flutter_test, mockito

### Core Architecture Pattern
**Clean Architecture + Riverpod** 조합:

1. **Presentation Layer**: Riverpod으로 상태 관리, 화면 구성
2. **Domain Layer**: 순수 비즈니스 로직 (UseCase)
3. **Data Layer**: Hive로 로컬 저장, Repository 패턴
4. **Reactive Calculations**: 입력 변경 시 실시간 계산 (웹 버전과 동일)

### Key Components Structure

```
lib/
├── main.dart                       # 앱 진입점
├── core/
│   ├── constants/
│   │   ├── app_constants.dart      # 2025년 세법 상수
│   │   └── app_theme.dart          # Material Design 3 테마
│   └── utils/
│       ├── formatters.dart         # 숫자 포맷팅 (intl 사용)
│       └── validators.dart         # 입력 검증
├── data/
│   ├── models/
│   │   ├── pension_input.dart      # 입력값 모델 (Freezed)
│   │   ├── calculation_result.dart # 결과값 모델 (Freezed)
│   │   └── scenario.dart           # 시나리오 모델 (Hive)
│   ├── repositories/
│   │   └── scenario_repository.dart
│   └── datasources/
│       └── local_datasource.dart   # Hive 구현
├── domain/
│   └── usecases/
│       ├── calculate_tax_deduction.dart     # 모듈 1
│       ├── calculate_future_asset.dart      # 모듈 2
│       ├── simulate_pension_receipt.dart    # 모듈 3
│       ├── simulate_asset_change.dart       # 모듈 4
│       └── compare_investment.dart          # 모듈 5
├── presentation/
│   ├── providers/
│   │   ├── pension_input_provider.dart      # 입력 상태 관리
│   │   └── calculation_provider.dart        # 계산 결과 상태
│   ├── screens/
│   │   ├── home_screen.dart                 # 메인 탭 네비게이션
│   │   ├── input_screen.dart                # 입력 화면
│   │   ├── result_screen.dart               # 결과 화면
│   │   └── scenario_list_screen.dart        # 시나리오 목록
│   └── widgets/
│       ├── input/                           # 입력 위젯
│       ├── result/                          # 결과 위젯
│       ├── charts/                          # 차트 위젯
│       └── common/                          # 공통 위젯
└── services/
    └── calculation_service.dart             # 핵심 계산 로직
```

### Calculation Modules (웹 버전과 동일)

1. **Module 1** (`세액공제계산`): 연금저축/IRP 세액공제 계산 (2025년 세법)
2. **Module 2** (`미래자산계산`): 복리 계산으로 미래 자산가치 산출
3. **Module 3** (`연금수령시뮬레이션계산`): 종합과세/분리과세/저율과세 비교
4. **Module 4** (`자산변화시뮬레이션계산`): 연차별 자산 잔액 추이 및 고갈 시점
5. **Module 5** (`투자비교계산`): 일반계좌 vs 연금계좌 세금 비교

### State Management Pattern (Riverpod)

```dart
// Provider 정의 예시
@riverpod
class PensionInput extends _$PensionInput {
  @override
  PensionInputModel build() {
    return const PensionInputModel(
      totalSalary: 50000000,
      pensionContribution: 3000000,
      // ... 기본값
    );
  }

  void updateTotalSalary(int value) {
    state = state.copyWith(totalSalary: value);
  }
}

// 계산 결과는 자동으로 반응
@riverpod
TaxDeductionResult calculateTaxDeduction(CalculateTaxDeductionRef ref) {
  final input = ref.watch(pensionInputProvider);
  return CalculationService.calculateTaxDeduction(input);
}
```

### Korean Variable Naming Convention

웹 버전과 동일하게 **한글 변수명** 사용:
- Dart는 한글 변수명 지원
- `총급여액`, `연금저축납입액`, `세액공제계산` 등
- 도메인 명확성을 위해 한글 유지

```dart
// 예시
class PensionInput {
  final int 총급여액;
  final int 연금저축납입액;
  final int IRP납입액;
  // ...
}
```

## Migration Strategy

### Phase 1: 계산 로직 이식 (우선순위 1) ⭐
웹 버전 `src/utils/calculations.ts`를 Dart로 변환:

1. **TypeScript → Dart 변환 규칙**:
   ```typescript
   // TypeScript
   export function 세액공제계산(입력값: 입력값타입): 세액공제결과 {
     const 적용세율 = (총급여액 <= 55000000) ? 0.165 : 0.132;
     return { 예상환급액, 적용세율 };
   }
   ```

   ```dart
   // Dart
   TaxDeductionResult 세액공제계산(PensionInput 입력값) {
     final 적용세율 = (입력값.총급여액 <= 55000000) ? 0.165 : 0.132;
     return TaxDeductionResult(예상환급액: ..., 적용세율: 적용세율);
   }
   ```

2. **변환 시 주의사항**:
   - `Math.round()` → `.round()`
   - `Math.min()` → `min()` (import 'dart:math')
   - `Math.max()` → `max()`
   - `**` (거듭제곱) → `pow()` 또는 `math.pow()`
   - 배열 → List
   - 객체 리터럴 → Freezed 클래스 인스턴스

3. **계산 정확도 검증**:
   - 웹 버전과 동일한 입력값으로 테스트
   - 모든 모듈의 결과가 정확히 일치해야 함

### Phase 2: UI 구현
웹 버전의 React 컴포넌트를 Flutter Widget으로 변환:

- `src/components/InputModule*.tsx` → `lib/presentation/widgets/input/`
- `src/components/ResultModule*.tsx` → `lib/presentation/widgets/result/`
- `src/components/Tabs.tsx` → Flutter `TabBar` 위젯
- `src/components/Accordion.tsx` → `ExpansionTile` 위젯

### Phase 3: 추가 기능
- **시나리오 저장/관리**: 웹 버전에 없는 새 기능
- **차트 강화**: fl_chart로 자산 변화 시각화
- **공유 기능**: 결과 스크린샷 공유

## Important Implementation Details

1. **Tax Law Compliance**: 2025년 한국 연금저축 세법 준수
   - 세액공제 한도: 연금저축 600만원, 전체 900만원
   - 세액공제율: 총급여 5,500만원 기준
   - 연금 수령 과세: 1,500만원 기준

2. **Precision**: 금융 계산은 정확성이 중요
   - 모든 금액은 `int` (원 단위)로 처리
   - 비율 계산은 `double`
   - `decimal` 패키지 사용 (필요시)

3. **Real-time Updates**: 입력 변경 시 즉�� 재계산
   - Riverpod의 자동 의존성 추적 활용
   - 계산 버튼 없이 실시간 업데이트

4. **Offline First**: 완전한 오프라인 동작
   - 모든 계산 로직 클라이언트 사이드
   - Hive로 로컬 저장

## Development Notes

### Freezed 사용법
불변 데이터 클래스 생성:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pension_input.freezed.dart';
part 'pension_input.g.dart';

@freezed
class PensionInput with _$PensionInput {
  const factory PensionInput({
    required int 총급여액,
    required int 연금저축납입액,
    required int IRP납입액,
    // ...
  }) = _PensionInput;

  factory PensionInput.fromJson(Map<String, dynamic> json) =>
      _$PensionInputFromJson(json);
}
```

코드 생성:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Hive 사용법
로컬 저장소 설정:

```dart
import 'package:hive_flutter/hive_flutter.dart';

// 초기화 (main.dart)
await Hive.initFlutter();
Hive.registerAdapter(ScenarioAdapter());
await Hive.openBox<Scenario>('scenarios');

// 저장
final box = Hive.box<Scenario>('scenarios');
await box.put('scenario1', scenario);

// 불러오기
final scenario = box.get('scenario1');
```

### 테스트 작성
계산 로직은 100% 테스트 커버리지:

```dart
test('세액공제계산 - 총급여 5,500만원 이하', () {
  final input = PensionInput(총급여액: 50000000, ...);
  final result = 세액공제계산(input);
  expect(result.적용세율, 0.165);
});
```

## Code Generation Workflow

1. 모델 정의 후 코드 생성:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. Watch 모드로 자동 생성:
   ```bash
   flutter pub run build_runner watch --delete-conflicting-outputs
   ```

3. 생성된 파일 (`*.freezed.dart`, `*.g.dart`)은 커밋하지 않음
   - `.gitignore`에 추가됨

## Migration Checklist

### 계산 로직 이식
- [ ] `세액공제계산` → `calculate_tax_deduction.dart`
- [ ] `미래자산계산` → `calculate_future_asset.dart`
- [ ] `연금수령시뮬레이션계산` → `simulate_pension_receipt.dart`
- [ ] `자산변화시뮬레이션계산` → `simulate_asset_change.dart`
- [ ] `투자비교계산` → `compare_investment.dart`
- [ ] 단위 테스트 작성 및 웹 버전과 결과 일치 검증

### UI 구현
- [ ] 입력 화면 (Module 1, 2, 3)
- [ ] 결과 화면 (요약 카드 + 상세)
- [ ] 탭 네비게이션
- [ ] 차트 (자산 변화, 세금 비교)
- [ ] 아코디언/확장 가능 섹션

### 추가 기능
- [ ] 시나리오 저장/불러오기
- [ ] 시나리오 비교
- [ ] 결과 공유 (스크린샷)
- [ ] 다크모드 지원

## Reference Files

### 웹 버전 핵심 파일 (참고용)
- `/Users/boss.back/Desktop/cursor/retire/src/utils/calculations.ts` - 계산 로직 ⭐
- `/Users/boss.back/Desktop/cursor/retire/src/types/index.ts` - 타입 정의
- `/Users/boss.back/Desktop/cursor/retire/src/context/PensionContext.tsx` - 상태 관리
- `/Users/boss.back/Desktop/cursor/retire/src/components/` - UI 컴포넌트

### Flutter 프로젝트 문서
- `FLUTTER_MIGRATION.md` - 상세 마이그레이션 계획 및 요구사항
- `README.md` - 프로젝트 개요 및 실행 방법

## Important Instructions

1. **계산 로직 이식이 최우선**: UI보다 계산 정확성이 중요
2. **웹 버전과 결과 일치 필수**: 모든 계산 결과가 정확히 같아야 함
3. **한글 변수명 유지**: 도메인 명확성을 위해 웹 버전과 동일하게 한글 사용
4. **Freezed 적극 활용**: 불변 데이터 클래스로 타입 안전성 확보
5. **테스트 작성 필수**: 특히 계산 로직은 100% 커버리지
6. **코드 생성 자동화**: build_runner watch 모드 활용

## Git Workflow

```bash
# 브랜치 전략 (제안)
git checkout -b feature/calculation-service    # 계산 로직 이식
git checkout -b feature/input-screen          # 입력 화면
git checkout -b feature/result-screen         # 결과 화면
```

---

**작성일**: 2025-10-04
**프로젝트**: 연금 플래너 360 Flutter App
**웹 버전 참조**: `/Users/boss.back/Desktop/cursor/retire`
