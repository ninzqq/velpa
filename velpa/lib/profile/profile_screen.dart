import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/services/auth.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = AuthService().user;
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profiili', style: theme.textTheme.titleLarge),
        foregroundColor: theme.colorScheme.primaryFixed,
      ),
      body: SafeArea(
        child: Container(
          color: theme.colorScheme.surface,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(children: [
                  Text(user?.displayName ?? '',
                      style: theme.textTheme.titleLarge),
                  Text(user?.email ?? '', style: theme.textTheme.titleLarge),
                ]),
                ElevatedButton(
                  child: const Text('Kirjaudu ulos'),
                  onPressed: () async {
                    await AuthService().signOut(ref);
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (Route<dynamic> route) => false);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
