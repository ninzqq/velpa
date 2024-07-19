import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:velpa/models/local_models.dart';
import 'package:velpa/services/auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = GetIt.instance<UserProvider>();

    if (userProvider.currentUser != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeData().scaffoldBackgroundColor,
          title: Text(userProvider.currentUser!.displayName ?? 'Guest'),
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
                  Text(userProvider.currentUser!.email ?? '',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  ElevatedButton(
                    child: const Text('logout'),
                    onPressed: () async {
                      await AuthService().signOut();
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
      return buildAuthForm();
    }
  }

  Widget buildAuthForm() {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
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
                        emailController.text, passwordController.text),
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

  Widget buildSignOutButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Logged in as ${AuthService().user!.email}'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: AuthService().logout,
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}
