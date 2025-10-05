/// 접근성 상수 및 헬퍼
class AccessibilityConstants {
  /// 최소 터치 타겟 크기 (Material Design 권장)
  static const double minTouchTargetSize = 48.0;
  
  /// 충분한 대비를 위한 최소 색상 대비율
  static const double minContrastRatio = 4.5;
  
  /// Screen Reader를 위한 시맨틱 라벨
  static const Map<String, String> semanticLabels = {
    'home': '홈 화면',
    'input': '입력 화면',
    'result': '결과 화면',
    'settings': '설정 화면',
    'save': '시나리오 저장',
    'load': '시나리오 불러오기',
    'share': '결과 공유',
    'theme': '테마 변경',
  };
  
  /// 폰트 크기 배율에 따른 레이아웃 조정
  static double getResponsivePadding(double textScaleFactor) {
    if (textScaleFactor > 1.5) {
      return 24.0; // 큰 폰트용 넓은 패딩
    } else if (textScaleFactor > 1.2) {
      return 20.0;
    }
    return 16.0; // 기본 패딩
  }
}
