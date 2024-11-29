import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/services/auth.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Kirjaudu sisään', style: theme.textTheme.titleLarge),
        foregroundColor: theme.colorScheme.primaryFixed,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //const EmailLoginForm(),
            Flexible(
              child: LoginButton(
                icon: Icons.account_circle_rounded,
                text: 'Kirjaudu Googlella',
                loginMethod: AuthService().googleLogin,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends ConsumerWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.loginMethod,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton.icon(
        label: Text(text, style: theme.textTheme.titleLarge),
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(24),
          backgroundColor: color,
        ),
        onPressed: () => loginMethod(ref),
      ),
    );
  }
}

class EmailLoginForm extends ConsumerWidget {
  const EmailLoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              border: Border.all(color: theme.colorScheme.tertiary, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: emailController,
              cursorColor: theme.colorScheme.primaryFixed,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: theme.textTheme.bodyMedium,
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              border: Border.all(color: theme.colorScheme.tertiary, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: passwordController,
              cursorColor: theme.colorScheme.primaryFixed,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: theme.textTheme.bodyMedium,
                border: InputBorder.none,
              ),
              obscureText: true,
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: LoginButton(
              icon: Icons.account_box,
              text: 'Continue with email',
              loginMethod: () {
                AuthService().emailRegister(
                    ref, emailController.text, passwordController.text);
              },
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
