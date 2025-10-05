import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_theme.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/onboarding_screen.dart';
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

class PensionPlannerApp extends ConsumerStatefulWidget {
  const PensionPlannerApp({super.key});

  @override
  ConsumerState<PensionPlannerApp> createState() => _PensionPlannerAppState();
}

class _PensionPlannerAppState extends ConsumerState<PensionPlannerApp> {
  bool? _onboardingCompleted;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(appThemeModeProvider);

    // 온보딩 상태 확인 중
    if (_onboardingCompleted == null) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode.toThemeMode(),
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: '연금 플래너 360',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode.toThemeMode(),
      debugShowCheckedModeBanner: false,
      initialRoute: _onboardingCompleted! ? '/home' : '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
