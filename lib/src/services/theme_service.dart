// lib/src/services/theme_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_color/dynamic_color.dart';

class ThemeService {
  ThemeMode _themeMode = ThemeMode.system;
  bool _useDynamicColors = false;
  final Color _brandColor = const Color.fromARGB(255, 239, 134, 239);
  final List<VoidCallback> _listeners = [];

  ThemeMode get themeMode => _themeMode;
  bool get useDynamicColors => _useDynamicColors;

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  Future<void> loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeMode = (prefs.getString('themeMode') ?? 'system') == 'light'
        ? ThemeMode.light
        : ThemeMode.dark;
    _useDynamicColors = prefs.getBool('useDynamicColors') ?? false;
    _notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'themeMode', mode == ThemeMode.light ? 'light' : 'dark');
    _themeMode = mode;
    _notifyListeners();
  }

  Future<void> toggleDynamicColors(bool useDynamic) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useDynamicColors', useDynamic);
    _useDynamicColors = useDynamic;
    _notifyListeners();
  }

  ThemeData getThemeData(ColorScheme? dynamicScheme, {required bool isDark}) {
    ColorScheme colorScheme;
    if (_useDynamicColors && dynamicScheme != null) {
      colorScheme = dynamicScheme.harmonized().copyWith(secondary: _brandColor);
    } else {
      colorScheme = ColorScheme.fromSeed(
        seedColor: _brandColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
      );
    }
    return ThemeData.from(colorScheme: colorScheme, useMaterial3: true);
  }
}
