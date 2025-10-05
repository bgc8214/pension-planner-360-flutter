#!/bin/bash

# 스크린샷 자동 촬영 스크립트
# 사용법: ./capture_screenshots.sh

DEVICE="emulator-5554"
OUTPUT_DIR="docs/screenshots"

echo "📸 스크린샷 자동 촬영을 시작합니다..."
echo "⏳ 앱이 완전히 로드될 때까지 대기 중..."
sleep 10

# 3. 입력 화면 (현재 화면)
echo "📱 입력 화면 촬영..."
adb -s $DEVICE shell screencap -p /sdcard/screenshot.png
adb -s $DEVICE pull /sdcard/screenshot.png $OUTPUT_DIR/03_input.png
adb -s $DEVICE shell rm /sdcard/screenshot.png
sleep 2

# 4. 결과 탭으로 이동
echo "📊 결과 탭으로 이동..."
adb -s $DEVICE shell input tap 810 2270  # 결과 탭 클릭
sleep 2

# 결과 화면 촬영
echo "💰 결과 화면 촬영..."
adb -s $DEVICE shell screencap -p /sdcard/screenshot.png
adb -s $DEVICE pull /sdcard/screenshot.png $OUTPUT_DIR/04_result.png
adb -s $DEVICE shell rm /sdcard/screenshot.png
sleep 2

# 5. 스크롤해서 차트 보기
echo "📈 차트 화면으로 스크롤..."
adb -s $DEVICE shell input swipe 540 1500 540 800 300
sleep 2

echo "📊 차트 화면 촬영..."
adb -s $DEVICE shell screencap -p /sdcard/screenshot.png
adb -s $DEVICE pull /sdcard/screenshot.png $OUTPUT_DIR/05_chart.png
adb -s $DEVICE shell rm /sdcard/screenshot.png
sleep 2

# 6. 시나리오 목록으로 이동
echo "📁 시나리오 목록으로 이동..."
adb -s $DEVICE shell input tap 150 150  # 폴더 아이콘 클릭
sleep 2

echo "💾 시나리오 목록 촬영..."
adb -s $DEVICE shell screencap -p /sdcard/screenshot.png
adb -s $DEVICE pull /sdcard/screenshot.png $OUTPUT_DIR/06_scenarios.png
adb -s $DEVICE shell rm /sdcard/screenshot.png
sleep 1

# 뒤로 가기
adb -s $DEVICE shell input keyevent 4
sleep 2

# 7. 설정으로 이동
echo "⚙️  설정 화면으로 이동..."
adb -s $DEVICE shell input tap 970 150  # 설정 아이콘 클릭
sleep 2

echo "🔧 설정 화면 촬영..."
adb -s $DEVICE shell screencap -p /sdcard/screenshot.png
adb -s $DEVICE pull /sdcard/screenshot.png $OUTPUT_DIR/07_settings.png
adb -s $DEVICE shell rm /sdcard/screenshot.png
sleep 2

# 8. 다크모드로 전환
echo "🌙 다크모드로 전환..."
adb -s $DEVICE shell input tap 540 490  # 다크모드 라디오 버튼
sleep 2

echo "🌙 다크모드 촬영..."
adb -s $DEVICE shell screencap -p /sdcard/screenshot.png
adb -s $DEVICE pull /sdcard/screenshot.png $OUTPUT_DIR/08_dark_mode.png
adb -s $DEVICE shell rm /sdcard/screenshot.png

echo "✅ 스크린샷 촬영 완료!"
echo "📂 저장 위치: $OUTPUT_DIR"
ls -lh $OUTPUT_DIR/*.png
