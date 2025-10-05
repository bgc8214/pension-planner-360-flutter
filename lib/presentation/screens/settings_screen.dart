import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/theme_provider.dart';
import 'onboarding_screen.dart';

/// 설정 화면
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          // 테마 설정 섹션
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '테마',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          
          // 라이트 모드
          RadioListTile<AppThemeModeValue>(
            title: const Text('라이트 모드'),
            subtitle: const Text('밝은 테마 사용'),
            value: AppThemeModeValue.light,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) {
                ref.read(appThemeModeProvider.notifier).setThemeMode(value);
              }
            },
            secondary: const Icon(Icons.light_mode),
          ),
          
          // 다크 모드
          RadioListTile<AppThemeModeValue>(
            title: const Text('다크 모드'),
            subtitle: const Text('어두운 테마 사용'),
            value: AppThemeModeValue.dark,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) {
                ref.read(appThemeModeProvider.notifier).setThemeMode(value);
              }
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          
          // 시스템 설정
          RadioListTile<AppThemeModeValue>(
            title: const Text('시스템 설정'),
            subtitle: const Text('기기 테마 설정 따르기'),
            value: AppThemeModeValue.system,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) {
                ref.read(appThemeModeProvider.notifier).setThemeMode(value);
              }
            },
            secondary: const Icon(Icons.settings_suggest),
          ),
          
          const Divider(),
          
          // 앱 정보 섹션
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '앱 정보',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('앱 소개 다시보기'),
            subtitle: const Text('튜토리얼 다시 확인'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OnboardingScreen(),
                ),
              );
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('버전'),
            subtitle: const Text('1.0.0'),
          ),
          
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('앱 설명'),
            subtitle: const Text('연금저축 및 IRP 전략 시뮬레이터'),
          ),
          
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('오픈소스 라이선스'),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: '연금 플래너 360',
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }
}
