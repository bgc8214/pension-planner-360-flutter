import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_theme.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/providers/theme_provider.dart';
import 'data/models/scenario.dart';
import 'data/models/pension_input.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 초기화
  await Hive.initFlutter();

  // Adapter 등록 (build_runner로 생성된 adapter 사용)
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ScenarioAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(PensionInputAdapter());
  }

  // Box 열기
  await Hive.openBox<Scenario>('scenarios');

  runApp(
    const ProviderScope(
      child: PensionPlannerApp(),
    ),
  );
}

class PensionPlannerApp extends ConsumerWidget {
  const PensionPlannerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp(
      title: '연금 플래너 360',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode.toThemeMode(),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
