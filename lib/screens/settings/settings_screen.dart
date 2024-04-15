// lib/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../services/theme_service.dart';
import 'widgets/settings_section.dart';

class SettingsScreen extends StatefulWidget {
  final ThemeService themeService;

  const SettingsScreen({Key? key, required this.themeService})
      : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = "Loading..."; // Default value for app version.

  @override
  void initState() {
    super.initState();
    widget.themeService.addListener(_update);
    _fetchAppVersion();
  }

  @override
  void dispose() {
    widget.themeService.removeListener(_update);
    super.dispose();
  }

  void _update() {
    // This function is called whenever the theme service notifies its listeners.
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _fetchAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  // mailto:daniel@sticker.name
  final Uri _url = Uri.parse('mailto:daniel@sticker.name');
  Future<void> _launchURL() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(vertical: 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ThemeMode.values.map((mode) {
              return RadioListTile<ThemeMode>(
                title: Text(mode == ThemeMode.system
                    ? 'System (Default)'
                    : mode.toString().split('.').last.capitalize()),
                value: mode,
                groupValue: widget.themeService.themeMode,
                onChanged: (ThemeMode? newValue) {
                  widget.themeService.setThemeMode(newValue!);
                  Navigator.of(context).pop(); // Close the dialog.
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text('Settings'),
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
                          widget.themeService.themeMode == ThemeMode.system
                              ? 'System (Default)'
                              : widget.themeService.themeMode
                                  .toString()
                                  .split('.')
                                  .last
                                  .capitalize()),
                      onTap: _showThemeDialog,
                    ),
                    ListTile(
                      leading: const Icon(Icons.color_lens),
                      title: const Text('Use Dynamic Colors'),
                      trailing: Switch(
                        value: widget.themeService.useDynamicColors,
                        onChanged: widget.themeService.toggleDynamicColors,
                      ),
                    ),
                  ],
                ),
                SettingsSection(name: 'About', children: [
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help Center'),
                    onTap: _launchURL,
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('MyApp for Android'),
                    subtitle: Text('Version $_appVersion'),
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app,
                        color: Theme.of(context).colorScheme.error),
                    title: Text('Sign out',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error)),
                    onTap: () => Navigator.pop(context),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
