import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/providers/user_provider.dart';
import 'package:velpa/services/auth.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = AuthService().user;
    var theme = Theme.of(context);
    var userRoles = ref.watch(currentUserProvider)?.roles;

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
                  const SizedBox(height: 20),
                  if (userRoles != null && userRoles.isAdmin)
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Admin', style: theme.textTheme.titleLarge),
                      const SizedBox(width: 10),
                      const Icon(Icons.done, color: Colors.green, size: 36),
                    ]),
                  if (userRoles != null && userRoles.isModerator)
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Moderator', style: theme.textTheme.titleLarge),
                      const SizedBox(width: 10),
                      const Icon(Icons.done, color: Colors.green, size: 36),
                    ]),
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
