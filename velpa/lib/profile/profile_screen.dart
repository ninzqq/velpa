import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/services/auth.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = AuthService().user;

    return Scaffold(
      appBar: AppBar(
        title: Text(user!.displayName ?? 'Guest'),
      ),
      body: SafeArea(
        child: Container(
          color: ThemeData().primaryColorLight,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(top: 50),
                  child: const Center(
                    child: Icon(
                      Icons.question_mark_rounded,
                      size: 100,
                    ),
                  ),
                ),
                Text(user.email ?? '',
                    style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                ElevatedButton(
                  child: const Text('logout'),
                  onPressed: () async {
                    await AuthService().signOut(ref);
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (Route<dynamic> route) => false);
                    }
                  },
                ),
                const Spacer(),
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
