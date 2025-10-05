# 릴리즈 빌드 가이드

앱 스토어 출시를 위한 릴리즈 빌드 생성 가이드입니다.

## 📱 Android 릴리즈 빌드

### 1. Keystore 생성 (최초 1회만)

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload \
  -storetype JKS
```

**입력 정보:**
- 비밀번호: (안전하게 보관할 것!)
- 이름: 개발자 이름
- 조직: 회사명 또는 개인
- 도시/지역/국가: 해당 정보 입력

**⚠️ 중요**: 
- `upload-keystore.jks` 파일을 안전하게 백업
- 비밀번호를 절대 잃어버리지 말 것
- GitHub에 커밋하지 말 것

### 2. key.properties 파일 생성

`android/key.properties` 파일 생성:

```properties
storePassword=<keystore 비밀번호>
keyPassword=<key 비밀번호>
keyAlias=upload
storeFile=<keystore 파일 경로>
```

예시:
```properties
storePassword=myStrongPassword123
keyPassword=myStrongPassword123
keyAlias=upload
storeFile=/Users/username/upload-keystore.jks
```

### 3. build.gradle 수정

`android/app/build.gradle` 파일에서 다음 부분 수정:

```gradle
// 파일 상단에 추가
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... 기존 설정 ...
    
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

### 4. APK 빌드

```bash
# APK 빌드
flutter build apk --release

# 빌드된 APK 위치
# build/app/outputs/flutter-apk/app-release.apk
```

### 5. App Bundle 빌드 (권장)

```bash
# AAB 빌드 (Google Play 권장 형식)
flutter build appbundle --release

# 빌드된 AAB 위치
# build/app/outputs/bundle/release/app-release.aab
```

### 6. 빌드 확인

```bash
# APK 정보 확인
aapt dump badging build/app/outputs/flutter-apk/app-release.apk

# APK 크기 확인
ls -lh build/app/outputs/flutter-apk/app-release.apk
```

---

## 🍎 iOS 릴리즈 빌드

### 1. Apple Developer 계정 필요

- Apple Developer Program 가입 ($99/년)
- https://developer.apple.com

### 2. Xcode에서 서명 설정

```bash
# Xcode 열기
open ios/Runner.xcworkspace
```

Xcode에서:
1. Runner 프로젝트 선택
2. Signing & Capabilities 탭
3. Team 선택
4. Bundle Identifier 확인: `com.pensionplanner.pension_planner_360_flutter`

### 3. Archive 생성

```bash
# iOS 릴리즈 빌드
flutter build ios --release

# 또는 Xcode에서
# Product > Archive
```

### 4. App Store Connect에 업로드

1. Xcode에서 Window > Organizer
2. Archives 탭에서 최신 archive 선택
3. "Distribute App" 클릭
4. "App Store Connect" 선택
5. 업로드 완료 대기

---

## 🔍 빌드 최적화

### Android 앱 크기 최소화

```bash
# Split APKs (ABI별 분리)
flutter build apk --split-per-abi --release
```

생성되는 APK:
- `app-armeabi-v7a-release.apk` (32비트 ARM)
- `app-arm64-v8a-release.apk` (64비트 ARM)
- `app-x86_64-release.apk` (64비트 Intel)

### ProGuard 활성화 (이미 설정됨)

`android/app/build.gradle`:
```gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
    }
}
```

---

## 📋 릴리즈 체크리스트

### 빌드 전 확인사항

- [ ] `pubspec.yaml`에서 버전 확인/업데이트
- [ ] 디버그 코드 제거
- [ ] 로그 출력 제거 (`print` → `debugPrint`)
- [ ] API 키 등 민감 정보 제거
- [ ] 테스트 실행 (`flutter test`)
- [ ] 코드 분석 (`flutter analyze`)

### Android 빌드 체크리스트

- [ ] Keystore 파일 준비
- [ ] `key.properties` 파일 생성
- [ ] `build.gradle` 서명 설정
- [ ] APK/AAB 빌드 성공
- [ ] 실제 기기에서 테스트

### iOS 빌드 체크리스트

- [ ] Apple Developer 계정 활성화
- [ ] Xcode 서명 설정
- [ ] Archive 생성
- [ ] 실제 기기에서 테스트
- [ ] App Store Connect 업로드

---

## 🐛 문제 해결

### "Keystore not found" 에러
```bash
# keystore 파일 경로 확인
ls -la ~/upload-keystore.jks

# key.properties 파일 경로 수정
```

### iOS 서명 에러
```bash
# 인증서 갱신
open ~/Library/MobileDevice/Provisioning\ Profiles

# Xcode에서 자동 서명 활성화
```

### 빌드 크기가 너무 큼
```bash
# Split APKs 사용
flutter build apk --split-per-abi

# 사용하지 않는 리소스 제거
flutter pub run flutter_native_splash:remove
```

---

## 📱 테스트 배포

### Android - Internal Testing

1. Google Play Console 접속
2. 내부 테스트 트랙 선택
3. AAB 업로드
4. 테스터 이메일 추가
5. 테스트 링크 공유

### iOS - TestFlight

1. App Store Connect 접속
2. TestFlight 탭 선택
3. 빌드 선택
4. 외부 테스터 추가
5. 베타 앱 검토 제출

---

## 📝 버전 관리

### 버전 번호 규칙

`pubspec.yaml`:
```yaml
version: 1.0.0+1
#         │ │ │  └── Build number (자동 증가)
#         │ │ └──── Patch (버그 수정)
#         │ └────── Minor (기능 추가)
#         └──────── Major (큰 변경사항)
```

### 버전 업데이트

```bash
# Minor 버전 업 (기능 추가)
# 1.0.0+1 → 1.1.0+2

# Patch 버전 업 (버그 수정)
# 1.0.0+1 → 1.0.1+2

# Major 버전 업 (큰 변경)
# 1.0.0+1 → 2.0.0+2
```

---

**모든 빌드가 성공하면 앱 스토어 출시 준비 완료! 🎉**
