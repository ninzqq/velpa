import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/local_models.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Debug mode'),
            trailing: Switch(
              value: ref.watch(appFlagsProvider).debug,
              onChanged: (bool value) {
                ref.read(appFlagsProvider).setDebug(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
