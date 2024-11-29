import 'package:flutter/material.dart';

class LoadingTextScreen extends StatelessWidget {
  const LoadingTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Container(
        color: theme.colorScheme.primary,
        child: Center(
          child: Text(
            'LATAAING...',
            style: theme.textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
