// main.dart
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'services/theme_service.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeService _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _themeService.loadPreferences().then((_) {
      _themeService.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder:
          (ColorScheme? lightDynamicScheme, ColorScheme? darkDynamicScheme) {
        // Pass the dynamic color schemes to the ThemeService
        ThemeData lightTheme =
            _themeService.getThemeData(lightDynamicScheme, isDark: false);
        ThemeData darkTheme =
            _themeService.getThemeData(darkDynamicScheme, isDark: true);

        return MaterialApp(
          title: 'Flutter Demo',
          themeMode: _themeService.themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          home: HomeScreen(themeService: _themeService),
        );
      },
    );
  }

  @override
  void dispose() {
    _themeService.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }
}
