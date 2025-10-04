# 연금 플래너 360 - Flutter 앱

연금저축 및 IRP 전략 시뮬레이터 모바일 앱 (iOS/Android)

## 🚀 시작하기

### 요구사항
- Flutter SDK 3.24+
- Dart 3.6+
- iOS: Xcode 15+ (macOS만 해당)
- Android: Android Studio

### 설치 및 실행

```bash
# 의존성 설치
flutter pub get

# iOS 시뮬레이터 실행
flutter run -d ios

# Android 에뮬레이터 실행
flutter run -d android
```

## 📋 개발 현황

### ✅ 완료
- [x] Flutter 프로젝트 초기화
- [x] 의존성 설정 (Riverpod, Hive, fl_chart 등)
- [x] 디렉토리 구조 설정
- [x] 테마 및 디자인 시스템
- [x] 세법 상수 정의
- [x] 기본 홈 화면

### 🔄 진행 예정
- [ ] 계산 로직 이식
- [ ] 입력 화면 구현
- [ ] 결과 화면 구현
- [ ] 차트 구현
- [ ] 시나리오 저장/관리

## 🛠 기술 스택

- **Framework**: Flutter 3.24+
- **상태 관리**: Riverpod 2.x
- **로컬 저장소**: Hive 2.x
- **차트**: fl_chart
- **폰트**: Google Fonts

## 📖 참고 문서

- [FLUTTER_MIGRATION.md](../retire/FLUTTER_MIGRATION.md) - 상세 마이그레이션 계획
- [웹 버전](https://bgc8214.github.io/pension-planner-360)
