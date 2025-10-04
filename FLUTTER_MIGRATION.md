# Flutter 모바일 앱 전환 계획

## 📱 프로젝트 개요

**연금 플래너 360 Flutter 앱**
- 현재 React 웹 앱을 Flutter 네이티브 모바일 앱으로 전환
- iOS/Android 크로스 플랫폼 지원
- 오프라인 계산 기능 (백엔드 불필요)
- 데이터 로컬 저장 및 시나리오 관리

---

## 🛠 기술 스택

### Frontend Framework
- **Flutter 3.24+** (최신 안정 버전)
- **Dart 3.5+**

### 상태 관리
- **Riverpod 2.x** (추천) 또는 **Provider**
  - 이유: React Context와 유사한 패턴, 타입 안전성
  - 대안: Bloc (더 복잡한 상태 관리 필요시)

### UI/UX 라이브러리
- **Material Design 3** (기본)
- **flutter_animate**: 부드러운 애니메이션
- **flutter_svg**: SVG 아이콘 지원
- **google_fonts**: 폰트 커스터마이징

### 데이터 저장
- **shared_preferences**: 사용자 설정 저장
- **hive** 또는 **isar**: 시나리오 및 계산 히스토리 로컬 저장
  - Hive: NoSQL 경량 DB, 빠른 성능
  - Isar: 더 강력한 쿼리, 타입 안전

### 차트 및 시각화
- **fl_chart**: 라인 차트, 바 차트 (자산 변화, 비교 그래프)
- **syncfusion_flutter_charts**: (선택) 더 풍부한 차트 필요시

### 유틸리티
- **intl**: 숫자 포맷팅 (한국 원화 표시)
- **decimal**: 정확한 금융 계산
- **freezed**: 불변 데이터 클래스 생성
- **json_annotation**: JSON 직렬화

### 테스트
- **flutter_test**: 단위 테스트
- **mockito**: 모킹
- **integration_test**: E2E 테스트

---

## 📋 요구사항 명세서

### 1. 기능 요구사항

#### 1.1 핵심 계산 기능
- [ ] **모듈 1**: 세액공제 계산
  - 총급여액, 연금저축/IRP 납입액 입력
  - 2025년 세법 기준 세액공제 계산
  - 실시간 결과 업데이트

- [ ] **모듈 2**: 미래 자산 계산
  - 현재나이, 은퇴나이, 연평균 수익률 입력
  - 복리 계산으로 미래가치 산출
  - 세액공제 대상 vs 비과세 원금 구분

- [ ] **모듈 3**: 연금 수령 시뮬레이션
  - 종합과세/분리과세/저율과세 비교
  - 최적 과세 방식 추천
  - 연금외소득 고려

- [ ] **모듈 4**: 자산 변화 시뮬레이션
  - 연차별 자산 잔액 추이
  - 비과세원금 우선 인출 로직
  - 자산 고갈 시점 예측

- [ ] **모듈 5**: 투자 방식 비교
  - 일반계좌 vs 연금계좌 세금 비교
  - 연차별 누적 세금 차이
  - 절약 효과 시각화

#### 1.2 사용자 경험
- [ ] **입력 화면**
  - 섹션별 입력 폼 (접었다 펼치기 가능)
  - 입력 값 검증 및 가이드 텍스트
  - 슬라이더 + 텍스트 입력 병행

- [ ] **결과 화면**
  - 요약 카드: 4개 핵심 지표
  - 상세 결과: 탭 또는 아코디언
  - 차트 시각화 (자산 변화, 세금 비교)

- [ ] **시나리오 관리**
  - 여러 시나리오 저장/불러오기
  - 시나리오 이름 지정
  - 시나리오 비교 기능

- [ ] **공유 기능**
  - 결과 스크린샷 공유
  - PDF 리포트 생성 (선택)

#### 1.3 설정 및 기타
- [ ] 다크모드 지원
- [ ] 앱 내 튜토리얼 (첫 실행시)
- [ ] 계산 공식 설명 (도움말)

### 2. 비기능 요구사항

#### 2.1 성능
- 입력 변경 후 100ms 이내 계산 완료
- 앱 시작 시간 2초 이내
- 부드러운 60fps 애니메이션

#### 2.2 호환성
- **iOS**: 14.0 이상
- **Android**: API 23 (Android 6.0) 이상
- 화면 크기: 4.7" ~ 6.7" 최적화

#### 2.3 보안 및 개인정보
- 모든 데이터 로컬 저장 (서버 전송 없음)
- 개인정보 수집 없음
- 오프라인 완전 동작

#### 2.4 접근성
- 폰트 크기 조절
- 색상 대비 WCAG AA 준수
- Screen Reader 지원 (기본)

---

## 📐 앱 구조 설계

### 디렉토리 구조
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── app_constants.dart       # 세율, 한도 등 상수
│   │   └── app_theme.dart           # 테마 정의
│   ├── utils/
│   │   ├── formatters.dart          # 숫자 포맷팅
│   │   └── validators.dart          # 입력 검증
│   └── errors/
│       └── exceptions.dart
├── data/
│   ├── models/
│   │   ├── input_model.dart         # 입력값 모델
│   │   ├── result_model.dart        # 결과값 모델
│   │   └── scenario_model.dart      # 시나리오 모델
│   ├── repositories/
│   │   └── scenario_repository.dart # 로컬 저장소
│   └── datasources/
│       └── local_datasource.dart    # Hive/Isar 구현
├── domain/
│   ├── entities/
│   │   └── pension_data.dart
│   └── usecases/
│       ├── calculate_tax_deduction.dart
│       ├── calculate_future_asset.dart
│       ├── simulate_pension_receipt.dart
│       ├── simulate_asset_change.dart
│       └── compare_investment.dart
├── presentation/
│   ├── providers/
│   │   ├── pension_input_provider.dart
│   │   └── pension_result_provider.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── input_screen.dart
│   │   ├── result_screen.dart
│   │   └── scenario_list_screen.dart
│   ├── widgets/
│   │   ├── input/
│   │   │   ├── input_module1.dart
│   │   │   ├── input_module2.dart
│   │   │   └── input_module3.dart
│   │   ├── result/
│   │   │   ├── summary_cards.dart
│   │   │   ├── result_module1.dart
│   │   │   ├── result_module2.dart
│   │   │   ├── result_module3.dart
│   │   │   ├── result_module4.dart
│   │   │   └── result_module5.dart
│   │   ├── charts/
│   │   │   ├── asset_change_chart.dart
│   │   │   └── tax_comparison_chart.dart
│   │   └── common/
│   │       ├── app_button.dart
│   │       ├── app_text_field.dart
│   │       ├── accordion.dart
│   │       └── info_card.dart
│   └── navigation/
│       └── app_router.dart
└── services/
    └── calculation_service.dart     # 계산 로직 (현재 calculations.ts를 Dart로 이식)
```

### 화면 구성

```
┌─────────────────────┐
│   HomeScreen        │  → 탭 네비게이션 (입력/결과/시나리오)
├─────────────────────┤
│  ┌───────────────┐  │
│  │ InputScreen   │  │  → Module 1, 2, 3 입력 폼
│  └───────────────┘  │
│  ┌───────────────┐  │
│  │ ResultScreen  │  │  → 요약 카드 + 상세 결과 + 차트
│  └───────────────┘  │
│  ┌───────────────┐  │
│  │ ScenarioList  │  │  → 저장된 시나리오 목록
│  └───────────────┘  │
└─────────────────────┘
```

---

## 🔄 마이그레이션 전략

### Phase 1: 기반 구축 (1-2주)
1. Flutter 프로젝트 초기화
2. 디렉토리 구조 설정
3. 상태 관리 (Riverpod) 설정
4. 테마 및 디자인 시스템 구축
5. 로컬 저장소 (Hive) 설정

### Phase 2: 계산 로직 이식 (1-2주)
1. `calculations.ts` → `calculation_service.dart` 변환
2. 단위 테스트 작성
3. 계산 정확도 검증 (기존 웹과 비교)

### Phase 3: UI 구현 (2-3주)
1. 입력 화면 구현 (Module 1, 2, 3)
2. 결과 화면 구현 (요약 카드, 상세)
3. 차트 구현 (fl_chart)
4. 시나리오 관리 화면

### Phase 4: 테스트 및 최적화 (1주)
1. 통합 테스트
2. 성능 최적화
3. UI/UX 개선
4. 접근성 검증

### Phase 5: 배포 준비 (1주)
1. 앱 아이콘 및 스플래시 스크린
2. 스토어 리스팅 준비
3. TestFlight / Google Play 베타 테스트
4. 정식 출시

**총 예상 기간: 6-9주**

---

## 📦 의존성 (pubspec.yaml)

```yaml
name: pension_planner_360
description: 연금저축 및 IRP 전략 시뮬레이터
version: 1.0.0+1

environment:
  sdk: '>=3.5.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # 상태 관리
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # 로컬 저장소
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # 유틸리티
  intl: ^0.19.0
  decimal: ^3.0.1
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

  # UI/차트
  fl_chart: ^0.69.0
  flutter_svg: ^2.0.10+1
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0

  # 기타
  share_plus: ^10.0.2
  path_provider: ^2.1.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

  # 코드 생성
  build_runner: ^2.4.12
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  riverpod_generator: ^2.4.3
  hive_generator: ^2.0.1

  # 테스트
  mockito: ^5.4.4
  integration_test:
    sdk: flutter

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/icons/
```

---

## 🎨 디자인 가이드라인

### 색상 팔레트
```dart
// lib/core/constants/app_theme.dart
class AppColors {
  // Primary
  static const primary = Color(0xFF2563EB);      // Blue 600
  static const primaryDark = Color(0xFF1E40AF);  // Blue 700

  // Accent
  static const accent = Color(0xFF10B981);       // Green 500
  static const warning = Color(0xFFF59E0B);      // Amber 500
  static const error = Color(0xFFEF4444);        // Red 500

  // Neutral
  static const background = Color(0xFFF9FAFB);   // Gray 50
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF111827);  // Gray 900
  static const textSecondary = Color(0xFF6B7280); // Gray 500

  // Gradients for Summary Cards
  static const gradient1 = [Color(0xFF3B82F6), Color(0xFF2563EB)];
  static const gradient2 = [Color(0xFF10B981), Color(0xFF059669)];
  static const gradient3 = [Color(0xFFF59E0B), Color(0xFFD97706)];
  static const gradient4 = [Color(0xFF8B5CF6), Color(0xFF7C3AED)];
}
```

### 타이포그래피
```dart
class AppTextStyles {
  static const h1 = TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
  static const h2 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const h3 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static const body = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
  static const caption = TextStyle(fontSize: 14, color: AppColors.textSecondary);
}
```

### 간격 시스템
```dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}
```

---

## 🧮 계산 로직 변환 예시

### TypeScript (현재)
```typescript
export function 세액공제계산(입력값: 입력값타입): 세액공제결과 {
  const { 총급여액, 연금저축납입액, IRP납입액 } = 입력값;
  const 적용세율 = (총급여액 <= 55000000) ? 0.165 : 0.132;
  const 예상환급액 = Math.round(세액공제대상금액 * 적용세율);
  return { 예상환급액, 적용세율 };
}
```

### Dart (변환 후)
```dart
// lib/services/calculation_service.dart
class CalculationService {
  TaxDeductionResult calculateTaxDeduction(PensionInput input) {
    final totalSalary = input.totalSalary;
    final pensionContribution = input.pensionContribution;
    final irpContribution = input.irpContribution;

    final taxRate = (totalSalary <= 55000000) ? 0.165 : 0.132;
    final deductibleAmount = min(
      pensionContribution + irpContribution,
      9000000,
    );
    final expectedRefund = (deductibleAmount * taxRate).round();

    return TaxDeductionResult(
      expectedRefund: expectedRefund,
      taxRate: taxRate,
    );
  }
}

// lib/data/models/result_model.dart
@freezed
class TaxDeductionResult with _$TaxDeductionResult {
  const factory TaxDeductionResult({
    required int expectedRefund,
    required double taxRate,
  }) = _TaxDeductionResult;

  factory TaxDeductionResult.fromJson(Map<String, dynamic> json) =>
      _$TaxDeductionResultFromJson(json);
}
```

---

## ✅ 체크리스트

### 개발 시작 전
- [ ] Flutter SDK 설치 및 환경 설정
- [ ] iOS/Android 개발 환경 구축
- [ ] Git 브랜치 전략 수립 (예: `flutter-dev`)
- [ ] 디자인 목업 검토 (Figma 등)

### 개발 중
- [ ] 계산 로직 단위 테스트 100% 커버리지
- [ ] 기존 웹 앱과 계산 결과 일치 검증
- [ ] 다크모드 UI 확인
- [ ] 다양한 화면 크기 테스트

### 배포 전
- [ ] 앱 아이콘 제작 (1024x1024)
- [ ] 스플래시 스크린 구현
- [ ] 개인정보 처리방침 작성
- [ ] 앱 스토어 스크린샷 준비 (5-8장)
- [ ] 앱 설명 작성 (한글/영문)

---

## 🚀 다음 단계

1. **Flutter 프로젝트 생성**
   ```bash
   flutter create pension_planner_360
   cd pension_planner_360
   ```

2. **의존성 추가**
   - pubspec.yaml 편집
   - `flutter pub get`

3. **계산 로직 변환**
   - `src/utils/calculations.ts` → `lib/services/calculation_service.dart`
   - 단위 테스트 작성

4. **UI 구현**
   - 디자인 시스템 먼저 구축
   - 입력 화면부터 순차 개발

5. **테스트 및 배포**
   - 베타 테스트 진행
   - 피드백 반영
   - 정식 출시

---

## 📞 참고 자료

- [Flutter 공식 문서](https://flutter.dev/docs)
- [Riverpod 문서](https://riverpod.dev)
- [fl_chart 예제](https://github.com/imaNNeo/fl_chart)
- [Hive 문서](https://docs.hivedb.dev)
- [Flutter 앱 배포 가이드](https://flutter.dev/docs/deployment)

---

**작성일**: 2025-10-04
**버전**: 1.0
**작성자**: Claude Code
