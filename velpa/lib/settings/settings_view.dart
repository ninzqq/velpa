import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/models.dart';
import 'package:velpa/services/firestore.dart';
import 'settings_controller.dart';
import 'package:velpa/models/local_models.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends ConsumerWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          'Settings',
          style: TextStyle(color: theme.colorScheme.primaryFixed),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            // Glue the SettingsController to the theme selection DropdownButton.
            //
            // When a user selects a theme from the dropdown list, the
            // SettingsController is updated, which rebuilds the MaterialApp.
            child: DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: controller.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: controller.updateThemeMode,
              dropdownColor: theme.colorScheme.secondary,
              items: [
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(
                    'Dark Theme',
                    style: theme.textTheme.labelMedium,
                  ),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(
                    'System Theme',
                    style: theme.textTheme.labelMedium,
                  ),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(
                    'Light Theme',
                    style: theme.textTheme.labelMedium,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              'Debug mode',
              style: TextStyle(color: theme.colorScheme.primaryFixed),
            ),
            trailing: Switch(
              value: ref.watch(appFlagsProvider).debug,
              onChanged: (bool value) {
                ref.read(appFlagsProvider).setDebug(value);
              },
              activeColor: theme.colorScheme.primary,
              activeTrackColor: theme.colorScheme.surfaceContainer,
              inactiveThumbColor: theme.colorScheme.primary,
            ),
          ),
          ListTile(
            title: const Text('testinks'),
            onTap: FirestoreService().addTestStuff,
          ),
          ListTile(
            title: const Text('check temp marker'),
            onTap: () {
              ref.read(mapMarkersProvider).checkTempMarker();
            },
          ),
          ListTile(
            title: const Text('claer temp marker'),
            onTap: () {
              ref.read(mapMarkersProvider).removeTempMarker(ref);
            },
          ),
          const Padding(
            padding: EdgeInsets.all(18),
            child: Text('Version 0.0.0'),
          ),
        ],
      ),
    );
  }
}
