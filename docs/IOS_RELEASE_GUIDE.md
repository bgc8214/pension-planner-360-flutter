# iOS 앱스토어 출시 가이드

## 📋 출시 체크리스트

### 1. ✅ 기본 설정 (완료)
- [x] 앱 아이콘 설정 완료 (모든 사이즈)
- [x] 스플래시 스크린 설정 완료
- [x] 버전 정보: 1.0.0+1
- [ ] Bundle ID 확인 필요
- [ ] 앱 디스플레이 이름 변경 필요

### 2. 🎨 앱 정보 설정

#### Bundle ID 및 이름 변경
현재 설정을 의미있는 값으로 변경해야 합니다:

**파일: `ios/Runner/Info.plist`**
```xml
<key>CFBundleDisplayName</key>
<string>연금플래너360</string>

<key>CFBundleName</key>
<string>PensionPlanner360</string>
```

**파일: `ios/Runner.xcodeproj/project.pbxproj`**
- Bundle Identifier: `com.pensionplanner.pension360` (또는 원하는 ID)
- Display Name: `연금플래너360`

### 3. 📱 지원 기기 및 OS 버전

**권장 설정:**
- 최소 iOS 버전: 13.0 이상
- 지원 기기: iPhone, iPad
- 화면 방향: Portrait (세로 모드 권장)

**파일: `ios/Podfile`**
```ruby
platform :ios, '13.0'
```

### 4. 🔐 개인정보 처리방침

이미 작성된 개인정보 처리방침을 호스팅해야 합니다:

**옵션 1: GitHub Pages (무료, 추천)**
```
https://[username].github.io/pension-planner-360-flutter/privacy-policy.html
```

**옵션 2: Notion 페이지**
- Notion에서 공개 페이지로 설정
- URL 복사하여 사용

**필요한 작업:**
1. `docs/PRIVACY_POLICY.md`를 HTML로 변환
2. GitHub Pages 또는 Notion에 호스팅
3. App Store Connect에 URL 등록

### 5. 📸 스크린샷 준비

**필수 스크린샷 사이즈:**
- 6.7" (iPhone 14 Pro Max): 1290 x 2796
- 6.5" (iPhone 11 Pro Max): 1242 x 2688
- 5.5" (iPhone 8 Plus): 1242 x 2208

**필요한 스크린샷 (최소 3장, 최대 10장):**
1. ✅ 입력 화면 (메인 기능)
2. ✅ 결과 화면 (세액공제, 미래자산, 연금수령)
3. ✅ 차트 화면
4. ✅ 시나리오 저장/불러오기
5. ✅ 설정 화면

이미 `docs/screenshots/` 폴더에 8장의 스크린샷이 있습니다!

### 6. 📝 App Store 설명 작성

이미 `docs/STORE_LISTING.md`에 작성되어 있습니다:

**앱 이름 (30자 제한):**
```
연금플래너360 - 연금저축 계산기
```

**부제목 (30자 제한):**
```
세액공제부터 연금수령까지
```

**키워드 (100자, 쉼표로 구분):**
```
연금저축,IRP,세액공제,연금계산기,노후준비,은퇴플랜,투자계산,연금수령,퇴직연금,재테크,금융계산기,세금환급,복리계산,자산관리,노후자금
```

**설명문 (4,000자):**
`docs/STORE_LISTING.md` 참조

### 7. 🏷️ 카테고리 및 등급

**주 카테고리:** Finance (금융)
**부 카테고리:** Productivity (생산성)

**연령 등급:** 4+ (모든 연령)
- 폭력, 성적 콘텐츠 없음
- 개인정보 수집 없음
- 완전 오프라인

### 8. 🔨 빌드 및 테스트

#### 릴리즈 빌드 생성
```bash
# 1. iOS 기기/시뮬레이터로 테스트
flutter run -d [device-id] --release

# 2. Archive 생성
flutter build ios --release

# 3. Xcode에서 Archive 및 업로드
open ios/Runner.xcworkspace
```

#### Xcode에서 Archive
1. Xcode에서 `Product > Archive` 실행
2. Archive 완료 후 `Window > Organizer` 열기
3. `Distribute App` 클릭
4. `App Store Connect` 선택
5. 서명 및 업로드

### 9. 📲 TestFlight 베타 테스트 (선택)

**권장:**
- 출시 전 최소 5명 이상 베타 테스터 초대
- 1주일 이상 테스트
- 피드백 수집 및 버그 수정

### 10. 🚀 App Store Connect 설정

#### 필요한 정보
- [ ] Apple Developer 계정 (연간 $99)
- [ ] 앱 이름 (고유해야 함)
- [ ] 카테고리
- [ ] 개인정보 처리방침 URL
- [ ] 지원 URL (GitHub 또는 웹사이트)
- [ ] 마케팅 URL (선택)
- [ ] 스크린샷 (3-10장)
- [ ] 앱 미리보기 비디오 (선택)

#### App Store Connect 단계
1. **앱 정보**
   - 이름, 부제목, 카테고리
   - 개인정보 처리방침 URL
   - 라이선스 계약

2. **가격 및 배포**
   - 무료 앱
   - 전 세계 배포

3. **버전 정보**
   - 스크린샷
   - 설명
   - 키워드
   - 지원 URL

4. **빌드 업로드**
   - Xcode에서 Archive
   - TestFlight로 전송
   - App Store Connect에서 빌드 선택

5. **심사 정보**
   - 연락처 정보
   - 데모 계정 (해당 없음)
   - 심사 참고사항

6. **제출**
   - "심사 제출" 클릭
   - 평균 24-48시간 소요

## 🔧 필수 수정 사항

### 1. Info.plist 업데이트
```xml
<key>CFBundleDisplayName</key>
<string>연금플래너360</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>결과 이미지를 갤러리에 저장하기 위해 권한이 필요합니다.</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>결과 이미지를 갤러리에 저장하기 위해 권한이 필요합니다.</string>
```

### 2. 최소 iOS 버전 설정
**파일: `ios/Podfile`**
```ruby
platform :ios, '13.0'
```

**파일: `ios/Runner.xcodeproj/project.pbxproj`**
Xcode에서:
- Runner 타겟 선택
- General 탭
- Deployment Info > iOS 13.0

## 📊 출시 후 모니터링

### 지표 확인
- 다운로드 수
- 사용자 평점 및 리뷰
- 충돌 보고서
- 사용자 피드백

### 업데이트 계획
- 버그 수정: 즉시
- 마이너 기능 추가: 2주~1개월
- 메이저 업데이트: 3개월

## 🎯 출시 타임라인 (예상)

| 단계 | 소요 시간 | 상태 |
|------|----------|------|
| 앱 설정 수정 | 1시간 | 🔄 진행 예정 |
| 개인정보 처리방침 호스팅 | 1시간 | 📝 준비 중 |
| iOS 빌드 및 테스트 | 2시간 | ⏳ 대기 중 |
| TestFlight 베타 (선택) | 1주일 | ⏳ 대기 중 |
| App Store Connect 설정 | 2시간 | ⏳ 대기 중 |
| Apple 심사 대기 | 1-3일 | ⏳ 대기 중 |
| **총 소요 시간** | **약 1-2주** | |

## 📚 참고 자료

- [Apple Developer](https://developer.apple.com/)
- [App Store Connect](https://appstoreconnect.apple.com/)
- [Flutter iOS 배포 가이드](https://docs.flutter.dev/deployment/ios)
- [App Store 심사 가이드라인](https://developer.apple.com/app-store/review/guidelines/)

## ⚠️ 주의사항

1. **Apple Developer 계정 필수**
   - 개인: $99/년
   - 조직: $99/년
   - 계정 생성 후 24시간 내 활성화

2. **심사 거부 가능성**
   - 개인정보 처리방침 누락
   - 스크린샷 품질 불량
   - 앱 충돌 또는 버그
   - 설명과 실제 기능 불일치

3. **한글 지원**
   - 앱 이름, 설명 모두 한글 가능
   - 키워드는 영문 추천
   - 한국 App Store에 최적화

## 💡 팁

1. **빠른 심사를 위해:**
   - 스크린샷 고품질
   - 명확한 설명
   - 버그 없는 빌드
   - 심사 참고사항 상세 작성

2. **좋은 첫인상:**
   - 매력적인 앱 아이콘
   - 명확한 부제목
   - 3-5장의 깔끔한 스크린샷
   - 간결한 설명

3. **지속적인 개선:**
   - 사용자 리뷰 적극 응대
   - 정기적인 업데이트
   - 버그 빠르게 수정

---

**작성일:** 2025-10-11
**버전:** 1.0.0
**작성자:** Claude Code
