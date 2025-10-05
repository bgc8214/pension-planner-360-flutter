# 연금 플래너 360 📱

> 연금저축 및 IRP 전략 시뮬레이터 - Flutter 모바일 앱

[![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.6+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[웹 버전](https://bgc8214.github.io/pension-planner-360) | [GitHub](https://github.com/bgc8214/pension-planner-360-flutter)

## 📱 소개

**연금 플래너 360**은 한국의 연금저축 및 IRP(개인형 퇴직연금) 투자 전략을 시뮬레이션하고, 세액공제 혜택을 계산하는 모바일 앱입니다. 2025년 세법 기준을 적용하여 정확한 계산 결과를 제공합니다.

### 주요 기능

- ✅ **세액공제 계산** - 연금저축/IRP 세액공제 (16.5% or 13.2%)
- 📈 **미래 자산 시뮬레이션** - 복리 효과를 고려한 은퇴 자산 예측
- 💰 **연금 수령 시뮬레이션** - 종합과세/분리과세/저율과세 비교
- 📊 **자산 변화 차트** - 연차별 자산 추이 시각화
- 🔄 **투자 전략 비교** - 일반계좌 vs 연금계좌 세금 비교
- 💾 **시나리오 관리** - 여러 투자 전략 저장 및 비교
- 🌓 **다크모드 지원** - 라이트/다크/시스템 설정
- 🔒 **완전 오프라인** - 네트워크 불필요, 개인정보 안전

## 🎬 스크린샷

| 온보딩 | 입력 화면 | 결과 화면 | 차트 |
|--------|----------|----------|------|
| ![Onboarding](docs/screenshots/onboarding.png) | ![Input](docs/screenshots/input.png) | ![Result](docs/screenshots/result.png) | ![Chart](docs/screenshots/chart.png) |

## 🚀 빠른 시작

### 필요 환경

- Flutter 3.24 이상
- Dart 3.6 이상
- Android Studio / Xcode
- Android 6.0+ / iOS 12.0+

### 설치 및 실행

```bash
# 저장소 클론
git clone https://github.com/bgc8214/pension-planner-360-flutter.git
cd pension_planner_360_flutter

# 의존성 설치
flutter pub get

# 코드 생성 (Freezed, Riverpod, Hive)
flutter pub run build_runner build --delete-conflicting-outputs

# Android 실행
flutter run -d android

# iOS 실행
flutter run -d ios
```

## 🏗️ 기술 스택

### 프레임워크 & 언어
- **Flutter 3.24+** - UI 프레임워크
- **Dart 3.6+** - 프로그래밍 언어

### 상태 관리 & 아키텍처
- **Riverpod 2.x** - 상태 관리
- **Freezed** - 불변 데이터 클래스
- **Clean Architecture** - 계층 분리

### 로컬 저장소
- **Hive 2.x** - NoSQL 임베디드 DB
- **SharedPreferences** - 설정 저장

### UI & 차트
- **Material Design 3** - 디자인 시스템
- **fl_chart** - 차트 라이브러리
- **Google Fonts** - Noto Sans

### 기타
- **share_plus** - 결과 공유
- **flutter_launcher_icons** - 앱 아이콘
- **flutter_native_splash** - 스플래시 스크린

## 📂 프로젝트 구조

```
lib/
├── core/
│   ├── constants/        # 상수 (테마, 접근성)
│   └── utils/            # 유틸리티 함수
├── data/
│   ├── models/           # 데이터 모델 (Freezed)
│   └── repositories/     # 저장소 (Hive)
├── domain/
│   └── usecases/         # 비즈니스 로직
├── presentation/
│   ├── providers/        # Riverpod Provider
│   ├── screens/          # 화면
│   └── widgets/          # 재사용 위젯
└── services/
    └── calculation_service.dart  # 계산 로직
```

## 💡 사용법

### 1. 기본 정보 입력
- 총급여액
- 연금저축 납입액
- IRP 납입액
- 나이 및 은퇴 계획

### 2. 결과 확인
- 연간 예상 환급액
- 미래 예상 자산
- 연금 수령 시뮬레이션
- 자산 변화 차트

### 3. 시나리오 저장
- 여러 투자 전략 비교
- 즐겨찾기 기능
- 검색 및 필터링

### 4. 결과 공유
- 전체 결과를 이미지로 캡처
- 다른 앱으로 공유 또는 저장

## 🔒 개인정보 보호

- **로컬 저장만** - 모든 데이터는 기기 내에서만 저장
- **네트워크 미사용** - 서버 전송 없음
- **익명 사용** - 개인 식별 정보 수집 안 함

## 📊 계산 로직

### 세액공제 계산
```
총급여 ≤ 5,500만원: 16.5%
총급여 > 5,500만원: 13.2%
한도: 연금저축 600만원 + IRP 300만원 = 900만원
```

### 미래 자산 계산
```
복리 공식: FV = PV × (1 + r)^n
PV: 현재 가치 (납입액 + 세액공제 환급액)
r: 예상 수익률
n: 투자 기간 (년)
```

## 🧪 테스트

```bash
# 단위 테스트
flutter test

# 통합 테스트
flutter test integration_test/app_test.dart
```

## 🤝 기여하기

이슈 및 PR을 환영합니다!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 라이선스

MIT License - 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## 👨‍💻 개발자

**bgc8214**
- GitHub: [@bgc8214](https://github.com/bgc8214)
- 웹 버전: [pension-planner-360](https://github.com/bgc8214/pension-planner-360)

## 🙏 감사의 말

- Flutter 팀
- Riverpod 커뮤니티
- Material Design 팀

## 📧 문의

프로젝트에 대한 문의사항은 [Issues](https://github.com/bgc8214/pension-planner-360-flutter/issues)를 이용해주세요.

---

**Made with ❤️ using Flutter**
