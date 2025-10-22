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

  // 에러 핸들러 설정
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  try {
    // Hive 초기화
    debugPrint('Initializing Hive...');
    await Hive.initFlutter();
    debugPrint('Hive initialized successfully');

    // Adapter 등록 (build_runner로 생성된 adapter 사용)
    if (!Hive.isAdapterRegistered(0)) {
      debugPrint('Registering ScenarioAdapter...');
      Hive.registerAdapter(ScenarioAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      debugPrint('Registering PensionInputAdapter...');
      Hive.registerAdapter(PensionInputAdapter());
    }

    // Box 열기 - 타임아웃 추가
    debugPrint('Opening Hive box...');
    await Hive.openBox<Scenario>('scenarios').timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        debugPrint('Hive box opening timed out, continuing anyway...');
        throw Exception('Hive initialization timeout');
      },
    );
    debugPrint('Hive box opened successfully');
  } catch (e, stackTrace) {
    debugPrint('Hive initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    // Hive 초기화 실패해도 앱은 계속 실행
    // 시나리오 저장 기능만 비활성화됨
  }

  debugPrint('Starting app...');
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
    try {
      final prefs = await SharedPreferences.getInstance().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          debugPrint('SharedPreferences timeout, showing onboarding');
          throw Exception('SharedPreferences timeout');
        },
      );
      if (mounted) {
        setState(() {
          _onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
        });
      }
    } catch (e) {
      debugPrint('Error checking onboarding status: $e');
      // 에러 발생 시 온보딩 표시
      if (mounted) {
        setState(() {
          _onboardingCompleted = false;
        });
      }
    }
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
      title: '스마트 연금계산기',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode.toThemeMode(),
      debugShowCheckedModeBanner: false,
      home: _onboardingCompleted! ? const HomeScreen() : const OnboardingScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
