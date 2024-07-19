import 'package:flutter/material.dart';
import 'package:velpa/services/auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var user = AuthService().user;

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeData().scaffoldBackgroundColor,
          title: Text(user.displayName ?? 'Guest'),
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
      return const Text('jaaaaa');
    }
  }
}
