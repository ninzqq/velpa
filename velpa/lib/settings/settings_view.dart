import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/providers/app_flags_provider.dart';
import 'package:velpa/screens/mobile/easter_egg_screen.dart';
import 'settings_controller.dart';

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
    int tapCount = 0;

    int increaseTapCount() {
      return tapCount++;
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.primaryFixed,
        title: Text(
          'Asetukset',
          style: TextStyle(color: theme.colorScheme.primaryFixed),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            // Glue the SettingsController to the theme selection DropdownButton.
            //
            // When a user selects a theme from the dropdown list, the
            // SettingsController is updated, which rebuilds the MaterialApp.
            child: ListTile(
              title: Text(
                'Teema',
                style: TextStyle(color: theme.colorScheme.primaryFixed),
              ),
              trailing: DropdownButton<ThemeMode>(
                // Read the selected themeMode from the controller
                value: controller.themeMode,
                // Call the updateThemeMode method any time the user selects a theme.
                onChanged: controller.updateThemeMode,
                dropdownColor: theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(8),
                elevation: 0,
                underline: Container(),
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(
                      'Tumma teema',
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(
                      'Järjestelmän teema',
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(
                      'Vaalea teema',
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
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
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.all(18),
            child: GestureDetector(
              onTap: () {
                if (increaseTapCount() == 4) {
                  Navigator.pushNamed(context, EasterEggScreen.routeName);
                }
              },
              child: const Text('Versio 0.0.1'),
            ),
          ),
        ],
      ),
    );
  }
}
