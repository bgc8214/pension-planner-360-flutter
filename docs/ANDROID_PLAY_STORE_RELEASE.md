# Android Google Play Store 출시 가이드

## 📋 사전 준비사항

### 1. Google Play Console 계정
- URL: https://play.google.com/console
- 비용: $25 (일회성 등록 비용)
- 필요 서류: Google 계정, 신용카드

### 2. 개발자 계정 활성화
- 등록 후 24-48시간 내 승인

---

## 🔐 1단계: Keystore 생성 (앱 서명)

### Keystore 생성

```bash
# 1. keystore 디렉토리 생성
mkdir -p ~/keystores
cd ~/keystores

# 2. Keystore 파일 생성
keytool -genkey -v -keystore smart-pension-calc.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias smartpensioncalc

# 질문에 답변:
# - Password: [안전한 비밀번호 입력 및 기록]
# - 이름: [본인 이름]
# - 조직: [회사명 또는 개인]
# - 도시/국가: 서울, KR
```

**⚠️ 중요: Keystore 파일과 비밀번호는 절대 잃어버리지 마세요!**
- 잃어버리면 앱 업데이트 불가능
- 안전한 곳에 백업 보관

### key.properties 파일 생성

```bash
# android/key.properties 생성
cat > android/key.properties << EOF
storePassword=[키스토어 비밀번호]
keyPassword=[키 비밀번호]
keyAlias=smartpensioncalc
storeFile=/Users/[사용자명]/keystores/smart-pension-calc.jks
EOF
```

**⚠️ key.properties는 .gitignore에 포함되어야 함** (이미 포함됨)

---

## 📝 2단계: build.gradle 설정

### android/app/build.gradle 수정

#### 1. 서명 설정 추가 (이미 설정되어 있는지 확인)

```gradle
// 파일 상단에 추가
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

#### 2. 앱 정보 확인

```gradle
android {
    defaultConfig {
        applicationId "com.boss.smartpensioncalc"  // 수정 필요
        minSdkVersion 21  // Android 5.0 이상
        targetSdkVersion 34  // 최신 타겟
        versionCode 1  // 빌드 번호 (정수)
        versionName "1.0.0"  // 버전 이름 (사용자용)
    }
}
```

---

## 🏗️ 3단계: App Bundle 빌드

### 방법 1: Flutter 명령어 (권장)

```bash
# 1. 깨끗한 빌드
flutter clean
flutter pub get

# 2. App Bundle 생성 (AAB)
flutter build appbundle --release

# 생성 위치:
# build/app/outputs/bundle/release/app-release.aab
```

### 방법 2: APK 빌드 (테스트용)

```bash
# APK 생성
flutter build apk --release

# 생성 위치:
# build/app/outputs/flutter-apk/app-release.apk
```

### 빌드 크기 확인

```bash
ls -lh build/app/outputs/bundle/release/app-release.aab
# 예상 크기: 15-25MB
```

---

## 📱 4단계: Google Play Console 설정

### 새 앱 만들기

1. **Play Console** 로그인
2. **모든 앱** > **앱 만들기**

#### 앱 세부정보
- **앱 이름**: 스마트 연금계산기
- **기본 언어**: 한국어
- **앱 또는 게임**: 앱
- **무료 또는 유료**: 무료

### 앱 정보 입력

#### 1. 스토어 등록정보 > 기본 스토어 등록정보

**앱 이름** (30자):
```
스마트 연금계산기
```

**간단한 설명** (80자):
```
연금저축·IRP 세액공제부터 은퇴 후 연금 수령까지 한 번에 계산하는 스마트한 금융 계산기
```

**전체 설명** (4,000자):
```
📊 스마트 연금계산기란?

은퇴 준비의 첫걸음, 연금저축과 IRP(개인형 퇴직연금)를 더 똑똑하게 활용하세요!

✨ 주요 기능

1. 세액공제 자동 계산
• 연금저축, IRP 납입액 입력만으로 세액공제 금액 자동 계산
• 2025년 세법 기준 적용 (총급여 5,500만원 기준)
• 최대 900만원 한도 자동 체크

... (APP_STORE_METADATA.md 전체 내용 복사)
```

#### 2. 그래픽 자료

**앱 아이콘**
- 크기: 512 x 512 pixels
- 형식: PNG (32비트, 투명 배경 없음)
- 파일: `assets/icon/app_icon.png` (리사이즈 필요)

**Feature Graphic** (필수)
- 크기: 1024 x 500 pixels
- 형식: PNG 또는 JPG
- 내용: 앱 로고 + "스마트 연금계산기" 타이틀

**스크린샷** (휴대전화, 2-8장)
- 크기: 최소 320px, 최대 3840px
- 권장: 1080 x 1920 pixels (9:16 비율)
- 최소 2장, 권장 6-8장

**스크린샷** (태블릿, 선택사항)
- 크기: 1200 x 1920 pixels (10인치)
- 최소 2장

#### 3. 분류

**앱 카테고리**:
- 카테고리: 금융
- 태그: 도구, 생산성

**콘텐츠 등급**:
- 설문조사 완료
- 예상 등급: 모든 연령 (3+)

#### 4. 연락처 세부정보

- **이메일**: [개발자 이메일]
- **전화번호**: [선택사항]
- **웹사이트**: https://bgc8214.github.io/pension-planner-360

#### 5. 개인정보처리방침

```
https://bgc8214.github.io/pension-planner-360-flutter/privacy-policy.html
```

---

## 📸 5단계: 스크린샷 준비

### 필수 스크린샷 (휴대전화)

#### 해상도: 1080 x 1920 pixels
1. 입력 화면
2. 세액공제 결과
3. 미래 자산
4. 연금 수령 비교
5. 투자 비교
6. 자산 변화 차트
7. 도움말
8. 다크모드

### 스크린샷 캡처 방법

```bash
# Android 에뮬레이터에서
1. Pixel 7 에뮬레이터 실행
2. 해상도: 1080 x 2400 (자동)
3. 스크린샷 촬영
4. 크롭 후 저장
```

---

## 🚀 6단계: 프로덕션 트랙에 업로드

### 앱 번들 업로드

1. **프로덕션** > **새 버전 만들기**
2. **App Bundle 업로드**
   - 파일: `build/app/outputs/bundle/release/app-release.aab`
3. 버전 이름: `1.0.0 (1)`

### 출시 노트 작성 (500자)

```
🎉 스마트 연금계산기 첫 출시!

✨ 주요 기능
• 연금저축/IRP 세액공제 자동 계산 (2025년 세법)
• 미래 자산 시뮬레이션 (복리 계산)
• 연금 수령 과세 방식 비교
• 자산 변화 추이 시각화
• 일반계좌 vs 연금계좌 투자 비교

🔒 개인정보 보호
• 완전 오프라인 작동
• 개인정보 미수집
• 광고 없음

💡 특징
• 직관적인 UI/UX
• 다크모드 지원
• 상세 도움말
```

---

## ✅ 7단계: 국가 및 지역 선택

### 출시 국가
- **권장**: 대한민국만 선택 (초기)
- **확장**: 테스트 후 전 세계 출시 가능

---

## 🧪 8단계: 내부 테스트 (선택사항)

### 내부 테스트 트랙 사용
1. **테스트** > **내부 테스트** > **새 버전 만들기**
2. 테스터 이메일 추가
3. AAB 업로드 및 테스트

---

## 🚀 9단계: 검토 제출

### 제출 전 체크리스트
- [ ] 앱 이름 확인
- [ ] 설명 및 키워드 입력
- [ ] 스크린샷 업로드 (최소 2장)
- [ ] Feature Graphic 업로드
- [ ] 앱 아이콘 업로드
- [ ] 카테고리 선택
- [ ] 콘텐츠 등급 완료
- [ ] 개인정보처리방침 URL
- [ ] 타겟 국가 선택
- [ ] AAB 업로드
- [ ] 출시 노트 작성

### 검토 제출
1. **프로덕션** > **검토**
2. 모든 항목 ✅ 확인
3. **프로덕션으로 출시** 클릭

---

## ⏱️ 검수 기간

- **평균**: 1-3일
- **빠르면**: 수 시간
- **늦으면**: 7일

### 거절 사유 (흔한 경우)
1. 개인정보처리방침 누락
2. 스크린샷 품질 저하
3. 설명 불충분
4. 앱 크래시
5. 권한 사용 이유 미제공

---

## 📊 10단계: Google Play 콘솔 설정

### Play Console 추가 설정

#### 데이터 보안
1. **데이터 수집**: "아니요, 이 앱은 사용자 데이터를 수집하지 않습니다"
2. 모든 질문에 "아니요" 답변

#### 광고 ID
- **광고 ID 사용**: 아니요

#### 타겟층 및 콘텐츠
- **타겟 연령**: 모든 연령
- **앱 콘텐츠**: 교육/금융 도구

---

## 🎯 체크리스트

### 출시 전 필수 확인
- [ ] Keystore 파일 생성 및 백업
- [ ] key.properties 설정
- [ ] Application ID 확인
- [ ] Version Code/Name 설정
- [ ] AAB 빌드 성공
- [ ] 테스트 완료
- [ ] 스크린샷 2-8장 준비
- [ ] Feature Graphic 준비
- [ ] 앱 설명 작성
- [ ] 개인정보처리방침 URL
- [ ] 카테고리 설정
- [ ] 콘텐츠 등급 완료
- [ ] 출시 국가 선택

### 출시 후 확인
- [ ] Google Play에서 검색
- [ ] 다운로드 테스트
- [ ] 리뷰 모니터링
- [ ] 크래시 리포트 확인 (Play Console)

---

## 🔧 문제 해결

### "Keystore was tampered with"
**해결:**
```bash
# Keystore 비밀번호 확인
keytool -list -v -keystore ~/keystores/smart-pension-calc.jks
```

### "Bundle too large"
**해결:**
```bash
# 앱 크기 분석
flutter build appbundle --release --analyze-size

# 불필요한 리소스 제거
```

### "Invalid package name"
**해결:**
```bash
# android/app/build.gradle 확인
# applicationId가 유효한 Java 패키지명인지 확인
```

---

## 📈 출시 후 관리

### 업데이트 주기
- 버그 수정: 즉시
- 기능 추가: 월 1회
- 세법 변경: 즉시 (매년 1월)

### 버전 관리
```yaml
# pubspec.yaml
version: 1.0.1+2
# 1.0.1: 버전 이름 (사용자용)
# 2: 버전 코드 (빌드 번호, 자동 증가)
```

---

## 📞 지원

- **Google Play Console Help**: https://support.google.com/googleplay/android-developer/
- **Play Console 문의**: https://play.google.com/console/about/contact/

---

**마지막 업데이트**: 2025-01-23
