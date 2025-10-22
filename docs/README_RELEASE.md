# 🚀 스마트 연금계산기 출시 가이드

## 📚 문서 구성

앱 스토어 출시를 위한 모든 문서와 자료가 준비되었습니다.

### 1. 출시 가이드 문서

#### 📱 [RELEASE_CHECKLIST.md](./RELEASE_CHECKLIST.md)
**가장 먼저 보세요!**
- iOS/Android 출시 전 체크리스트
- 단계별 확인 사항
- 출시 후 모니터링 가이드

#### 🍎 [IOS_APP_STORE_RELEASE.md](./IOS_APP_STORE_RELEASE.md)
**iOS App Store 출시 완전 가이드**
- Apple Developer Program 설정
- Xcode Archive 생성 방법
- App Store Connect 설정
- TestFlight 배포
- 최종 제출 방법

#### 🤖 [ANDROID_PLAY_STORE_RELEASE.md](./ANDROID_PLAY_STORE_RELEASE.md)
**Google Play Store 출시 완전 가이드**
- Keystore 생성 및 관리
- App Bundle (AAB) 빌드
- Google Play Console 설정
- 프로덕션 트랙 배포
- 최종 제출 방법

#### 📝 [APP_STORE_METADATA.md](./APP_STORE_METADATA.md)
**앱 스토어 메타데이터 모음**
- 앱 설명 (한글, 4000자)
- 짧은 설명 (Subtitle)
- 키워드 리스트
- 스크린샷 가이드
- 카테고리 및 연령 등급

---

### 2. 기술 문서

#### [IOS_RELEASE_GUIDE.md](./IOS_RELEASE_GUIDE.md)
- iOS 릴리즈 빌드 기술 가이드

#### [RELEASE_BUILD.md](./RELEASE_BUILD.md)
- 릴리즈 빌드 생성 방법

---

### 3. 법적 문서

#### [PRIVACY_POLICY.md](./PRIVACY_POLICY.md)
- 개인정보 처리방침 (마크다운)

#### [privacy-policy.html](./privacy-policy.html)
- 개인정보 처리방침 (HTML, 웹 공개용)
- URL: https://bgc8214.github.io/pension-planner-360-flutter/privacy-policy.html

---

## 🎨 마케팅 자료

### 이미지 파일 (`assets/marketing/`)

#### 1. Feature Graphic (Android)
- **파일**: `feature_graphic.png`
- **크기**: 1024 x 500 pixels
- **용도**: Google Play Store Feature Graphic
- **내용**: 앱 로고 + 타이틀 + 부제

#### 2. 앱 아이콘 (512x512)
- **파일**: `app_icon_512.png`
- **크기**: 512 x 512 pixels
- **용도**: Google Play Store 앱 아이콘
- **형식**: PNG (투명 배경 없음)

#### 3. 앱 아이콘 (1024x1024)
- **위치**: `assets/icon/app_icon.png`
- **크기**: 1024 x 1024 pixels
- **용도**: iOS App Store 앱 아이콘

---

## 📸 스크린샷 준비

### 필요한 스크린샷 (8장)

1. **입력 화면** - 연금 정보 입력
2. **세액공제 결과** - 예상 환급액
3. **미래 자산** - 복리 계산 결과
4. **연금 수령 비교** - 종합과세 vs 분리과세
5. **투자 비교** - 일반계좌 vs 연금계좌
6. **자산 변화 차트** - 연차별 추이
7. **도움말** - 상세 설명 화면
8. **다크모드** - 다크 테마

### 해상도

#### iOS
- 6.7" (iPhone 14 Pro Max): 1290 x 2796
- 6.5" (iPhone 11 Pro Max): 1284 x 2778

#### Android
- 휴대전화: 1080 x 1920 (최소 2장)

---

## ⚙️ 빌드 명령어

### iOS 릴리즈 빌드

```bash
# 1. 클린 빌드
flutter clean
flutter pub get

# 2. iOS 릴리즈 빌드
flutter build ios --release

# 3. Xcode에서 Archive
open ios/Runner.xcworkspace
# Xcode에서: Product > Archive
```

### Android 릴리즈 빌드

```bash
# 1. 클린 빌드
flutter clean
flutter pub get

# 2. App Bundle 생성
flutter build appbundle --release

# 생성 위치:
# build/app/outputs/bundle/release/app-release.aab
```

---

## 📋 출시 순서 (권장)

### 1단계: 사전 준비 (1일)
- [ ] Apple Developer Program 가입 ($99/년)
- [ ] Google Play Console 등록 ($25 일회성)
- [ ] 개인정보 처리방침 GitHub Pages 업로드
- [ ] 지원 이메일 주소 준비

### 2단계: Android 빌드 및 테스트 (반나절)
- [ ] Keystore 생성
- [ ] AAB 빌드
- [ ] 실제 기기 테스트

### 3단계: iOS 빌드 및 테스트 (반나절)
- [ ] Xcode 설정
- [ ] Archive 생성
- [ ] 실제 기기 테스트

### 4단계: 스크린샷 촬영 (1일)
- [ ] iOS 시뮬레이터에서 8장
- [ ] Android 에뮬레이터에서 8장
- [ ] 이미지 편집 및 최적화

### 5단계: 메타데이터 작성 (반나절)
- [ ] 앱 설명 작성
- [ ] 키워드 리스트 작성
- [ ] 카테고리 선택

### 6단계: iOS 제출 (반나절)
- [ ] App Store Connect 설정
- [ ] 스크린샷 업로드
- [ ] Archive 업로드
- [ ] TestFlight 테스트
- [ ] 최종 제출

### 7단계: Android 제출 (반나절)
- [ ] Google Play Console 설정
- [ ] 그래픽 자료 업로드
- [ ] AAB 업로드
- [ ] 최종 제출

### 8단계: 검수 대기 (1-3일)
- [ ] iOS 검수 모니터링
- [ ] Android 검수 모니터링

### 9단계: 출시 완료 및 모니터링
- [ ] 앱 스토어에서 다운로드 확인
- [ ] 크래시 리포트 모니터링
- [ ] 사용자 리뷰 확인

---

## ⏱️ 예상 일정

- **준비 기간**: 2-3일
- **iOS 검수**: 1-3일
- **Android 검수**: 1-3일
- **총 소요 기간**: 5-9일

---

## 💰 비용

- **iOS**: $99/년 (Apple Developer Program)
- **Android**: $25 (일회성 등록 비용)
- **총**: $124 (첫 해)

---

## 📞 지원 연락처

### Apple
- Developer Support: https://developer.apple.com/support/
- App Store Connect Help: https://help.apple.com/app-store-connect/

### Google
- Play Console Support: https://support.google.com/googleplay/android-developer/

---

## ✅ 빠른 체크리스트

**출시 전 필수 5가지:**
1. [ ] 릴리즈 빌드 생성 (iOS Archive + Android AAB)
2. [ ] 실제 기기 테스트 완료
3. [ ] 스크린샷 6-8장 준비
4. [ ] 개인정보 처리방침 URL 준비
5. [ ] 앱 설명 작성 완료

**출시 버튼 누르기 전:**
1. [ ] 앱 이름 최종 확인: "스마트 연금계산기"
2. [ ] 버전 확인: 1.0.0
3. [ ] 모든 스크린샷 업로드 완료
4. [ ] 개인정보 처리방침 URL 동작 확인
5. [ ] 키워드 및 카테고리 설정 완료

---

## 🎯 다음 단계

1. **RELEASE_CHECKLIST.md** 파일을 열고 체크리스트 시작
2. iOS와 Android 중 편한 플랫폼부터 시작
3. 해당 플랫폼의 상세 가이드 문서 참조
4. 단계별로 체크하며 진행

---

**행운을 빕니다! 🚀**

**출시 후 피드백 환영합니다!**

---

**마지막 업데이트**: 2025-01-23
**버전**: 1.0.0
