// lib/src/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

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
                    ? AppLocalizations.of(context)!.settings_systemDefault
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

  String getPlatformName() {
    if (kIsWeb) {
      return "Web";
    } else {
      if (Platform.isAndroid) {
        return "Android";
      } else if (Platform.isIOS) {
        return "iOS";
      } else if (Platform.isFuchsia) {
        return "Fuchsia";
      } else if (Platform.isLinux) {
        return "Linux";
      } else if (Platform.isMacOS) {
        return "MacOS";
      } else if (Platform.isWindows) {
        return "Windows";
      } else {
        return "Unknown";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(AppLocalizations.of(context)!.settings_title),
            pinned: true,
            expandedHeight: 150.0,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SettingsSection(
                  name: AppLocalizations.of(context)!.settings_appearance,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.brightness_medium_outlined),
                      title: Text(
                          AppLocalizations.of(context)!.settings_colorScheme),
                      subtitle: Text(widget.themeService.themeMode ==
                              ThemeMode.system
                          ? AppLocalizations.of(context)!.settings_systemDefault
                          : widget.themeService.themeMode
                              .toString()
                              .split('.')
                              .last
                              .capitalize()),
                      onTap: _showThemeDialog,
                    ),
                    ListTile(
                      leading: const Icon(Icons.color_lens),
                      title: Text(AppLocalizations.of(context)!
                          .settings_useDynamicColors),
                      trailing: Switch(
                        value: widget.themeService.useDynamicColors,
                        onChanged: widget.themeService.toggleDynamicColors,
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                    name: AppLocalizations.of(context)!.settings_about,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: Text(
                            AppLocalizations.of(context)!.settings_helpCenter),
                        onTap: _launchURL,
                      ),
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: Text(AppLocalizations.of(context)!
                            .settings_appForPlattform(getPlatformName())),
                        subtitle: Text(AppLocalizations.of(context)!
                            .settings_version(_appVersion)),
                      ),
                      ListTile(
                        leading: Icon(Icons.exit_to_app,
                            color: Theme.of(context).colorScheme.error),
                        title: Text(
                            AppLocalizations.of(context)!.settings_signOut,
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
