import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/local_models.dart';
import 'package:velpa/services/auth.dart';
import 'package:velpa/widgets/drawer.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = AuthService().user;
    var loggedIn = ref.watch(userStateProvider).isLoggedIn;

    if (loggedIn) {
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
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (Route<dynamic> route) => false);
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return buildAuthForm(ref);
    }
  }

  Widget buildAuthForm(WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in or register'),
      ),
      //drawer: const MainDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => AuthService().emailLogin(
                        ref, emailController.text, passwordController.text),
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () => AuthService().emailRegister(
                        emailController.text, passwordController.text),
                    child: const Text('Register'),
                  ),
                ],
              )
            ],
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