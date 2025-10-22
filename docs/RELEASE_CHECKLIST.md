# 📋 앱 출시 최종 체크리스트

## ✅ 출시 전 필수 확인 사항

### 📱 공통 (iOS & Android)

#### 1. 앱 기본 정보
- [ ] 앱 이름: "스마트 연금계산기" 확인
- [ ] 버전: 1.0.0+1 설정 완료
- [ ] Bundle ID (iOS) / Application ID (Android) 최종 확인
- [ ] 앱 아이콘 1024x1024 생성 완료
- [ ] 스플래시 스크린 생성 완료

#### 2. 법적 문서
- [ ] 개인정보 처리방침 URL 준비
  - https://bgc8214.github.io/pension-planner_360-flutter/privacy-policy.html
- [ ] 지원 이메일 주소 준비
- [ ] 지원 웹사이트 URL 준비

#### 3. 마케팅 자료
- [ ] 앱 설명 (한글, 4000자) 작성 완료
- [ ] 짧은 설명 (80자) 작성 완료
- [ ] 키워드 리스트 준비 (15개)
- [ ] 스크린샷 6-8장 준비
- [ ] Feature Graphic (Android) 생성 완료

#### 4. 앱 테스트
- [ ] 실제 기기에서 릴리즈 빌드 테스트 완료
- [ ] 모든 핵심 기능 정상 작동 확인
  - [ ] 세액공제 계산
  - [ ] 미래 자산 시뮬레이션
  - [ ] 연금 수령 비교
  - [ ] 투자 비교
  - [ ] 시나리오 저장/불러오기
- [ ] 다크모드 정상 작동
- [ ] 온보딩 화면 정상 작동
- [ ] 도움말 다이얼로그 정상 작동
- [ ] 크래시 없음 확인

---

## 🍎 iOS App Store 출시

### 사전 준비
- [ ] Apple Developer Program 가입 완료 ($99/년)
- [ ] App Store Connect 계정 접근 가능
- [ ] Xcode 최신 버전 설치

### Xcode 프로젝트 설정
- [ ] Bundle Identifier 최종 확인
- [ ] Signing & Capabilities에서 Team 선택
- [ ] Version 1.0.0, Build 1 확인

### Archive 및 업로드
- [ ] `flutter build ios --release` 성공
- [ ] Xcode에서 Archive 생성
- [ ] TestFlight 업로드 완료
- [ ] Processing 완료 확인 (5-30분)

### App Store Connect 설정
- [ ] 앱 정보 입력 완료
  - [ ] 앱 이름
  - [ ] 부제목 (30자)
  - [ ] 카테고리: Finance
  - [ ] 연령 등급: 4+
- [ ] 스크린샷 업로드 (6.7", 6.5", 5.5")
- [ ] 앱 설명 입력
- [ ] 키워드 입력 (100자)
- [ ] 지원 URL 입력
- [ ] 개인정보 처리방침 URL 입력
- [ ] 데이터 수집: "No" 선택
- [ ] 빌드 선택 완료

### 제출
- [ ] 모든 필수 항목 ✅ 확인
- [ ] "Submit for Review" 클릭
- [ ] 검수 상태 모니터링 (24-48시간)

---

## 🤖 Android Google Play Store 출시

### 사전 준비
- [ ] Google Play Console 계정 등록 ($25)
- [ ] 개발자 계정 활성화 확인

### Keystore 생성 및 설정
- [ ] Keystore 파일 생성 완료
  ```bash
  ~/keystores/smart-pension-calc.jks
  ```
- [ ] Keystore 안전하게 백업 완료
- [ ] key.properties 파일 생성 및 설정
- [ ] .gitignore에 key.properties 포함 확인

### build.gradle 설정
- [ ] Application ID 최종 확인
- [ ] versionCode: 1
- [ ] versionName: "1.0.0"
- [ ] minSdkVersion: 21
- [ ] targetSdkVersion: 34
- [ ] Signing 설정 완료

### App Bundle 빌드
- [ ] `flutter build appbundle --release` 성공
- [ ] AAB 파일 생성 확인
  ```
  build/app/outputs/bundle/release/app-release.aab
  ```
- [ ] AAB 파일 크기 확인 (15-25MB 예상)

### Google Play Console 설정
- [ ] 앱 만들기 완료
- [ ] 기본 스토어 등록정보 입력
  - [ ] 앱 이름
  - [ ] 간단한 설명 (80자)
  - [ ] 전체 설명 (4000자)
- [ ] 그래픽 자료 업로드
  - [ ] 앱 아이콘 512x512
  - [ ] Feature Graphic 1024x500
  - [ ] 스크린샷 (휴대전화) 2-8장
  - [ ] 스크린샷 (태블릿, 선택)
- [ ] 앱 카테고리: 금융
- [ ] 콘텐츠 등급 설문 완료
- [ ] 개인정보처리방침 URL 입력
- [ ] 데이터 보안 설문 완료
  - [ ] "데이터 수집 안 함" 선택
- [ ] 타겟 국가 선택 (대한민국)

### App Bundle 업로드 및 제출
- [ ] 프로덕션 트랙에 AAB 업로드
- [ ] 출시 노트 작성 (500자)
- [ ] 모든 필수 항목 ✅ 확인
- [ ] "프로덕션으로 출시" 클릭
- [ ] 검수 상태 모니터링 (1-3일)

---

## 📸 스크린샷 준비 상태

### iOS 스크린샷 (필수)
- [ ] 6.7" (1290 x 2796) - 6-8장
- [ ] 6.5" (1284 x 2778) - 6-8장
- [ ] 5.5" (1242 x 2208) - 선택

### Android 스크린샷 (필수)
- [ ] 휴대전화 (1080 x 1920) - 6-8장
- [ ] 태블릿 (1200 x 1920) - 선택

### 스크린샷 내용 (순서대로)
1. [ ] 입력 화면 (연금 정보 입력)
2. [ ] 세액공제 결과
3. [ ] 미래 자산 시뮬레이션
4. [ ] 연금 수령 비교
5. [ ] 투자 비교
6. [ ] 자산 변화 차트
7. [ ] 도움말 화면
8. [ ] 다크모드 (선택)

---

## 📝 메타데이터 준비 상태

### 앱 설명 (4000자)
- [ ] 한글 버전 작성 완료
- [ ] 주요 기능 5가지 포함
- [ ] 사용 방법 설명
- [ ] 개인정보 보호 강조
- [ ] 문의 정보 포함

### 짧은 설명 (80자)
- [ ] iOS Subtitle 작성 완료
- [ ] Android 간단한 설명 작성 완료

### 키워드
- [ ] iOS Keywords (100자) 준비
- [ ] Android Keywords (15개) 준비

---

## 🎨 그래픽 자료 준비 상태

### 앱 아이콘
- [ ] 1024x1024 (iOS) ✓
- [ ] 512x512 (Android) ✓
- [ ] 투명 배경 없음 확인

### Feature Graphic (Android)
- [ ] 1024x500 PNG ✓
- [ ] 고품질 이미지
- [ ] 텍스트 가독성 확인

---

## 🔒 개인정보 및 보안

### 개인정보 처리방침
- [ ] HTML 파일 생성 완료
- [ ] GitHub Pages 업로드 완료
- [ ] URL 접근 확인
- [ ] "개인정보 미수집" 명시

### 데이터 수집
- [ ] iOS: "No data collected" 선택
- [ ] Android: "데이터 수집 안 함" 선택
- [ ] 완전 오프라인 작동 확인

---

## 🧪 테스트 완료 확인

### 기능 테스트
- [ ] 세액공제 계산 정확성
- [ ] 미래 자산 복리 계산
- [ ] 연금 수령 세금 계산
- [ ] 자산 변화 시뮬레이션
- [ ] 투자 비교 계산

### UI/UX 테스트
- [ ] 모든 화면 정상 표시
- [ ] 버튼 및 터치 동작
- [ ] 스크롤 및 애니메이션
- [ ] 다크모드 전환
- [ ] 폰트 크기 적절성

### 디바이스 테스트
- [ ] iPhone (실제 기기)
- [ ] Android Phone (실제 기기 또는 에뮬레이터)
- [ ] 다양한 화면 크기

### 성능 테스트
- [ ] 앱 시작 시간 (3초 이내)
- [ ] 계산 응답 시간 (즉시)
- [ ] 메모리 사용량 정상
- [ ] 배터리 소모 정상

---

## 📊 출시 후 모니터링

### 첫 주
- [ ] 다운로드 수 확인
- [ ] 크래시 리포트 모니터링
  - iOS: Xcode Organizer
  - Android: Play Console
- [ ] 사용자 리뷰 확인 및 응답
- [ ] 별점 모니터링

### 첫 달
- [ ] 사용자 피드백 수집
- [ ] 버그 수정 우선순위 결정
- [ ] 업데이트 계획 수립

---

## 🚀 출시 일정 (예상)

### iOS
- Archive 생성: 즉시
- TestFlight 업로드: 5-30분
- App Store 제출: 즉시
- 검수 대기: 24-48시간
- **출시 완료**: 제출 후 1-3일

### Android
- AAB 빌드: 즉시
- Play Console 업로드: 즉시
- 검수 대기: 1-3일
- **출시 완료**: 제출 후 1-4일

---

## 📞 문제 발생 시 연락처

### Apple
- Developer Support: https://developer.apple.com/support/
- App Store Connect: https://help.apple.com/app-store-connect/

### Google
- Play Console Support: https://support.google.com/googleplay/android-developer/
- 문의: Play Console 내 지원 메뉴

---

## ✅ 최종 확인

**출시 준비 완료 조건:**
- [ ] 모든 체크리스트 항목 ✅
- [ ] 테스트 완료
- [ ] 메타데이터 준비 완료
- [ ] 그래픽 자료 준비 완료
- [ ] 법적 문서 준비 완료
- [ ] Keystore/서명 설정 완료

**출시 버튼을 누르기 전 마지막 확인:**
- [ ] 앱 이름 최종 확인: "스마트 연금계산기"
- [ ] 버전 최종 확인: 1.0.0
- [ ] 개인정보 처리방침 URL 동작 확인
- [ ] 지원 이메일 확인
- [ ] 스크린샷 순서 및 품질 최종 확인

---

**출시 날짜**: _______________
**출시 담당자**: _______________
**검수 완료 날짜**: _______________

---

**마지막 업데이트**: 2025-01-23
