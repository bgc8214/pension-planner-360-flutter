import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pension_planner_360_flutter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('연금 플래너 360 통합 테스트', () {
    testWidgets('앱 시작 및 기본 UI 확인', (WidgetTester tester) async {
      // 앱 시작
      app.main();
      await tester.pumpAndSettle();

      // 앱 타이틀 확인
      expect(find.text('연금 플래너 360'), findsOneWidget);

      // 탭 네비게이션 확인
      expect(find.text('입력'), findsOneWidget);
      expect(find.text('결과'), findsOneWidget);
    });

    testWidgets('입력 화면에서 값 변경 및 결과 확인', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 입력 탭에 있는지 확인
      expect(find.text('입력'), findsOneWidget);

      // 결과 탭으로 이동
      await tester.tap(find.text('결과'));
      await tester.pumpAndSettle();

      // 결과 화면 확인
      expect(find.text('연간 예상 환급액'), findsOneWidget);
      expect(find.text('미래 예상 자산'), findsOneWidget);
      expect(find.text('연금 수령 시뮬레이션'), findsOneWidget);
    });

    testWidgets('설정 화면 접근 및 다크모드 전환', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 설정 버튼 찾기 (톱니바퀴 아이콘)
      final settingsButton = find.byIcon(Icons.settings_outlined);
      expect(settingsButton, findsOneWidget);

      // 설정 화면 열기
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      // 설정 화면 확인
      expect(find.text('설정'), findsOneWidget);
      expect(find.text('테마'), findsOneWidget);
      expect(find.text('라이트 모드'), findsOneWidget);
      expect(find.text('다크 모드'), findsOneWidget);

      // 다크 모드 선택
      await tester.tap(find.text('다크 모드'));
      await tester.pumpAndSettle();

      // 뒤로 가기
      await tester.pageBack();
      await tester.pumpAndSettle();
    });

    testWidgets('시나리오 저장 플로우', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 저장 버튼 찾기
      final saveButton = find.byIcon(Icons.save);
      expect(saveButton, findsOneWidget);

      // 저장 다이얼로그 열기
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // 다이얼로그 확인
      expect(find.text('시나리오 저장'), findsOneWidget);
      expect(find.text('시나리오 이름'), findsOneWidget);

      // 취소 버튼으로 닫기
      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();
    });

    testWidgets('시나리오 목록 화면 접근', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 폴더 버튼 찾기
      final folderButton = find.byIcon(Icons.folder_open);
      expect(folderButton, findsOneWidget);

      // 시나리오 목록 화면 열기
      await tester.tap(folderButton);
      await tester.pumpAndSettle();

      // 시나리오 목록 화면 확인
      expect(find.text('저장된 시나리오'), findsOneWidget);

      // 뒤로 가기
      await tester.pageBack();
      await tester.pumpAndSettle();
    });
  });
}
