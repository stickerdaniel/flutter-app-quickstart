import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/settings_section.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(ThemeMode) onThemeChanged;
  final void Function(bool) onDynamicColorToggle;

  const SettingsScreen({
    Key? key,
    required this.onThemeChanged,
    required this.onDynamicColorToggle,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeMode _themeMode = ThemeMode.system;
  late bool _useDynamicColors = false;
  String _appVersion = "Loading..."; // default value

  @override
  void initState() {
    super.initState();
    _fetchAppVersion();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = (prefs.getString('themeMode') ?? 'system') == 'light'
          ? ThemeMode.light
          : ThemeMode.dark;
      if (prefs.getBool('useDynamicColors') ?? false) {
        toggleDynamicColors(true);
      }
    });
  }

  Future<void> _fetchAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  final Uri url = Uri.parse('https://creatasy.de');
  Future<void> _launchURL() async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ThemeMode.values.map((mode) {
              return RadioListTile(
                title: Text(mode == ThemeMode.system
                    ? 'System (Default)'
                    : mode.toString().split('.').last.capitalize()),
                value: mode,
                groupValue: _themeMode,
                onChanged: (ThemeMode? newValue) {
                  setState(() {
                    _themeMode = newValue!;
                    widget.onThemeChanged(_themeMode);
                  });
                  Navigator.of(context).pop(); // Close the dialog.
                },

                contentPadding: EdgeInsets.zero, // Removes default padding
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void toggleDynamicColors(bool value) {
    setState(() {
      _useDynamicColors = value;
    });
    widget.onDynamicColorToggle(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Settings'),
            pinned: true,
            expandedHeight: 150.0,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SettingsSection(
                  name: 'App',
                  children: [
                    ListTile(
                      leading: const Icon(Icons.brightness_medium_outlined),
                      title: const Text('Color Scheme'),
                      subtitle: Text(
                        _themeMode == ThemeMode.system
                            ? 'System (Default)'
                            : _themeMode
                                .toString()
                                .split('.')
                                .last
                                .capitalize(),
                      ),
                      onTap: _showThemeDialog,
                    ),
                    ListTile(
                      leading: const Icon(Icons.color_lens),
                      title: const Text('Use System Colors'),
                      trailing: Switch(
                        value: _useDynamicColors,
                        onChanged: (bool value) {
                          toggleDynamicColors(value);
                        },
                      ),
                      onTap: () {
                        toggleDynamicColors(
                            !_useDynamicColors); // toggle the value when the ListTile is tapped
                      },
                    ),
                  ],
                ),
                SettingsSection(name: 'About', children: [
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help Center'),
                    onTap: () => {_launchURL()},
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('MyApp for Android'),
                    subtitle: Text(
                        'Version $_appVersion'), // using the state variable here
                    enableFeedback: false,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: Text('Sign out',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error)),
                    onTap: () => {Navigator.pop(context)},
                  ),
                ])
              ],
            ),
          )
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
