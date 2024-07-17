// lib/src/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/theme_service.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final ThemeService themeService;

  const HomeScreen({Key? key, required this.themeService}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home_appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                          themeService: widget.themeService,
                        )),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your action here
        },
        label: const Text('Action'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
