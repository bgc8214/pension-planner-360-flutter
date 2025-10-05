import 'package:flutter/material.dart' as material;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

/// 다크모드 설정 Provider
@riverpod
class AppThemeMode extends _$AppThemeMode {
  static const String _key = 'theme_mode';

  @override
  AppThemeModeValue build() {
    _loadThemeMode();
    return AppThemeModeValue.system;
  }

  /// SharedPreferences에서 테마 모드 불러오기
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_key);
    
    if (savedMode != null) {
      state = AppThemeModeValue.values.firstWhere(
        (mode) => mode.name == savedMode,
        orElse: () => AppThemeModeValue.system,
      );
    }
  }

  /// 테마 모드 변경
  Future<void> setThemeMode(AppThemeModeValue mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }

  /// 다크모드로 전환
  Future<void> setDarkMode() async {
    await setThemeMode(AppThemeModeValue.dark);
  }

  /// 라이트모드로 전환
  Future<void> setLightMode() async {
    await setThemeMode(AppThemeModeValue.light);
  }

  /// 시스템 설정 따르기
  Future<void> setSystemMode() async {
    await setThemeMode(AppThemeModeValue.system);
  }
}

/// 테마 모드 enum
enum AppThemeModeValue {
  light,
  dark,
  system;

  material.ThemeMode toThemeMode() {
    switch (this) {
      case AppThemeModeValue.light:
        return material.ThemeMode.light;
      case AppThemeModeValue.dark:
        return material.ThemeMode.dark;
      case AppThemeModeValue.system:
        return material.ThemeMode.system;
    }
  }

  String get displayName {
    switch (this) {
      case AppThemeModeValue.light:
        return '라이트 모드';
      case AppThemeModeValue.dark:
        return '다크 모드';
      case AppThemeModeValue.system:
        return '시스템 설정';
    }
  }
}
