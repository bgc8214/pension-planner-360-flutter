# iOS App Store 출시 가이드

## 📋 사전 준비사항

### 1. Apple Developer Program 가입
- URL: https://developer.apple.com/programs/
- 비용: $99/년
- 필요 서류: 신분증, 사업자등록증 (법인인 경우)

### 2. App Store Connect 계정
- URL: https://appstoreconnect.apple.com/
- Apple Developer Program 가입 후 자동 접근 가능

---

## 🔧 1단계: Xcode 프로젝트 설정

### Bundle Identifier 확인
```bash
# 현재 설정: com.boss.pensionplanner360dev
# 프로덕션용으로 변경 권장: com.yourcompany.smartpensioncalc
```

**변경 방법:**
1. Xcode 열기: `open ios/Runner.xcworkspace`
2. Runner > General > Identity
3. Bundle Identifier 수정
4. Signing & Capabilities에서 Team 선택

### 버전 정보 설정
**pubspec.yaml**
```yaml
version: 1.0.0+1
# 형식: [버전번호]+[빌드번호]
# 버전번호: 사용자에게 표시 (예: 1.0.0)
# 빌드번호: 내부 관리용 (예: 1, 2, 3...)
```

---

## 📱 2단계: Archive 빌드 생성

### 방법 1: Flutter 명령어 (권장)
```bash
# 1. 깨끗한 빌드
flutter clean
flutter pub get

# 2. iOS 릴리즈 빌드
flutter build ios --release

# 3. Xcode에서 Archive
open ios/Runner.xcworkspace
```

**Xcode에서:**
1. Product > Scheme > Edit Scheme
2. Run > Build Configuration > Release 선택
3. Product > Archive

### 방법 2: Xcode만 사용
1. `open ios/Runner.xcworkspace`
2. Signing & Capabilities에서 Team 선택
3. Generic iOS Device 선택
4. Product > Archive

---

## 🚀 3단계: App Store Connect 설정

### 새 앱 등록
1. App Store Connect 로그인
2. **My Apps** > **+** > **New App**

#### 기본 정보 입력
- **플랫폼**: iOS
- **이름**: 스마트 연금계산기
- **언어**: Korean (한국어)
- **Bundle ID**: com.yourcompany.smartpensioncalc (Xcode와 동일)
- **SKU**: smartpensioncalc-ios (고유 식별자)

### 앱 정보 입력

#### 1. App Information
- **이름**: 스마트 연금계산기
- **부제목** (Subtitle, 30자): 연금저축·IRP 세액공제 계산기
- **카테고리**:
  - Primary: Finance
  - Secondary: Productivity
- **콘텐츠 권한** (Content Rights): 본인 소유

#### 2. Pricing and Availability
- **Price**: Free (무료)
- **Availability**: All Countries (모든 국가)

#### 3. App Privacy
개인정보 처리방침 URL:
```
https://bgc8214.github.io/pension-planner-360-flutter/privacy-policy.html
```

**데이터 수집**:
- ☑️ "No, we do not collect data from this app"
  (이 앱은 데이터를 수집하지 않습니다)

#### 4. Age Rating
- **Age Rating**: 4+ (모든 연령)
- 모든 질문에 "No" 답변

---

## 📸 4단계: 스크린샷 준비

### 필수 해상도 (각 2-10장)

#### iPhone 6.7" (iPhone 14 Pro Max, 15 Pro Max)
- 해상도: 1290 x 2796 pixels
- 최소 2장, 권장 6-8장

#### iPhone 6.5" (iPhone 11 Pro Max, XS Max)
- 해상도: 1284 x 2778 pixels
- 최소 2장, 권장 6-8장

#### iPhone 5.5" (iPhone 8 Plus)
- 해상도: 1242 x 2208 pixels
- 선택사항 (이전 기기 지원 시)

### 스크린샷 캡처 방법

```bash
# iOS 시뮬레이터에서 자동 캡처 스크립트 실행
# (이미 생성된 스크립트가 있다면 사용)

# 수동 캡처:
1. iPhone 14 Pro Max 시뮬레이터 실행
2. Cmd + S로 스크린샷 저장
3. 데스크톱에 저장됨
```

### 스크린샷 순서 (권장)
1. 입력 화면 - 연금 정보 입력
2. 세액공제 결과 - 예상 환급액
3. 미래 자산 - 복리 계산
4. 연금 수령 비교 - 과세 방식
5. 투자 비교 - 일반 vs 연금계좌
6. 자산 변화 차트
7. 상세 도움말
8. 다크모드 (선택)

---

## 📝 5단계: 앱 설명 작성

### App Store 설명 (4,000자)
**위치**: App Store Connect > App Information > Description

```
📊 스마트 연금계산기란?

은퇴 준비의 첫걸음, 연금저축과 IRP를 더 똑똑하게 활용하세요!

✨ 주요 기능
• 세액공제 자동 계산 (2025년 세법)
• 미래 자산 시뮬레이션
• 연금 수령 전략 비교
• 자산 변화 추이 시각화
• 투자 비교 분석

... (APP_STORE_METADATA.md 참조)
```

### 프로모션 텍스트 (170자)
```
🎉 2025년 최신 세법 반영!
연금저축·IRP 세액공제부터 은퇴 후 연금 수령까지
한 번에 계산하는 스마트한 금융 계산기
완전 무료, 광고 없음, 개인정보 미수집
```

### 키워드 (100자)
```
연금,연금저축,IRP,세액공제,연말정산,개인연금,퇴직연금,노후준비,은퇴계획,재테크,금융계산기,연금계산,세금환급,투자,자산관리
```

---

## 🎨 6단계: 앱 아이콘 및 프리뷰

### 앱 아이콘
- **크기**: 1024 x 1024 pixels
- **형식**: PNG (투명 배경 없음)
- **위치**: `assets/icon/app_icon.png`
- **업로드**: App Store Connect > App Store > App Icon

### 앱 프리뷰 비디오 (선택사항)
- **길이**: 15-30초
- **해상도**: 스크린샷과 동일
- **내용**: 주요 기능 시연

---

## 📦 7단계: Archive 업로드

### Xcode에서 업로드
1. **Window** > **Organizer**
2. 생성된 Archive 선택
3. **Distribute App** 클릭
4. **App Store Connect** 선택
5. **Upload** 선택
6. Signing 옵션:
   - ☑️ Automatically manage signing (권장)
7. **Upload** 실행

### 업로드 확인
- App Store Connect > TestFlight > iOS Builds
- "Processing" 상태 → "Ready to Test" (5-30분 소요)

---

## ✅ 8단계: TestFlight 테스트

### 내부 테스터 추가
1. TestFlight > Internal Testing > **+**
2. 테스터 이메일 추가
3. 빌드 선택 및 테스트 시작

### 외부 테스터 (선택)
1. TestFlight > External Testing > **+**
2. 그룹 생성 및 테스터 추가
3. Apple 검수 필요 (1-2일)

---

## 🚀 9단계: 최종 제출

### App Store Connect에서 제출
1. **App Store** 탭 선택
2. **+** > **Version 1.0.0**
3. 모든 필수 항목 입력 완료 확인:
   - ✅ 스크린샷 (6-8장)
   - ✅ 설명
   - ✅ 키워드
   - ✅ 지원 URL
   - ✅ 개인정보 처리방침 URL
   - ✅ 카테고리
   - ✅ 연령 등급
   - ✅ 빌드 선택

4. **Add for Review** → **Submit for Review**

---

## ⏱️ 검수 기간

- **평균**: 24-48시간
- **최대**: 7일
- **빠르면**: 12시간 이내

### 검수 거절 사유 (흔한 경우)
1. 메타데이터 불일치
2. 앱 크래시
3. 개인정보 처리방침 누락
4. 스크린샷 품질 저하
5. 기능 설명 불명확

---

## 🎯 체크리스트

### 출시 전 필수 확인
- [ ] Bundle Identifier 설정
- [ ] Version/Build 번호 확인
- [ ] Signing & Capabilities 설정
- [ ] Archive 빌드 성공
- [ ] TestFlight 테스트 완료
- [ ] 스크린샷 6-8장 준비
- [ ] 앱 설명 작성
- [ ] 키워드 설정
- [ ] 개인정보 처리방침 URL
- [ ] 지원 이메일/URL
- [ ] 연령 등급 설정
- [ ] 가격 설정 (무료)

### 출시 후 확인
- [ ] App Store 검색 확인
- [ ] 다운로드 테스트
- [ ] 사용자 리뷰 모니터링
- [ ] 크래시 리포트 확인

---

## 🔧 문제 해결

### "No signing identity found"
**해결:**
```bash
1. Xcode > Preferences > Accounts
2. Apple ID 추가
3. Download Manual Profiles
```

### "Archive 버튼이 비활성화"
**해결:**
```bash
1. Generic iOS Device 선택 (시뮬레이터 아님)
2. Build Configuration이 Release인지 확인
```

### "Upload Failed"
**해결:**
```bash
1. Application Loader 사용
2. Xcode 재시작
3. Derived Data 삭제:
   rm -rf ~/Library/Developer/Xcode/DerivedData
```

---

## 📞 지원

- **Apple Developer Support**: https://developer.apple.com/support/
- **App Store Connect Help**: https://help.apple.com/app-store-connect/

---

**마지막 업데이트**: 2025-01-23
