import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/settings/settings_screen.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _useDynamicColors = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var themeModeString = prefs.getString('themeMode') ?? 'system';
      switch (themeModeString) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
      _useDynamicColors = prefs.getBool('useDynamicColors') ?? false;
    });
  }

  void setThemeMode(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mode == ThemeMode.system) {
      prefs.remove('themeMode');
    } else {
      prefs.setString('themeMode', mode == ThemeMode.light ? 'light' : 'dark');
    }
    setState(() {
      _themeMode = mode;
    });
  }

  void toggleDynamicColors(bool useDynamic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('useDynamicColors', useDynamic);
    setState(() {
      _useDynamicColors = useDynamic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'Flutter Demo',
          themeMode: _themeMode,
          theme: _useDynamicColors && lightDynamic != null
              ? ThemeData.from(
                  colorScheme: lightDynamic,
                  useMaterial3: true,
                )
              : ThemeData.from(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: Colors.lightBlue),
                  useMaterial3: true,
                ),
          darkTheme: _useDynamicColors && darkDynamic != null
              ? ThemeData.from(
                  colorScheme: darkDynamic,
                  useMaterial3: true,
                )
              : ThemeData.from(
                  colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.lightBlue, brightness: Brightness.dark),
                  useMaterial3: true,
                ),
          home: MyHomePage(
            title: 'MyApp',
            onThemeChanged: setThemeMode,
            onDynamicColorToggle: toggleDynamicColors,
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final void Function(ThemeMode) onThemeChanged;
  final void Function(bool)
      onDynamicColorToggle; // Adding a callback for toggling dynamic colors
  final String title;

  const MyHomePage(
      {Key? key,
      required this.onThemeChanged,
      required this.title,
      required this.onDynamicColorToggle})
      : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      appBar: AppBar(
        elevation: 3,
        title: Text(widget.title),
        actions: [
          // In your settings IconButton's onPressed method, pass the toggle method
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                          onThemeChanged: widget.onThemeChanged,
                          onDynamicColorToggle: widget.onDynamicColorToggle,
                        )),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Action'),
        icon: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
