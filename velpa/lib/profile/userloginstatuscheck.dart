import 'package:flutter/material.dart';
import 'package:velpa/profile/loginscreen.dart';
import 'package:velpa/profile/profile_screen.dart';
import 'package:velpa/services/auth.dart';
import 'package:velpa/utils/loadingscreen.dart';

class UserLogInStatusCheck extends StatelessWidget {
  const UserLogInStatusCheck({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: LoadingTextScreen(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          return const ProfileScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
