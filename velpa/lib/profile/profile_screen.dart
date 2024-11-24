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
        title: Text('Profile', style: theme.textTheme.titleLarge),
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
                  child: const Text('Logout'),
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

  Widget buildSignOutButton(WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Logged in as ${AuthService().user!.email}'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => AuthService().signOut(ref),
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}
