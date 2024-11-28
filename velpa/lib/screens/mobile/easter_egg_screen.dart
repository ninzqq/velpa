import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EasterEggScreen extends ConsumerWidget {
  const EasterEggScreen({super.key});

  static const routeName = '/easter-egg';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.red,
        foregroundColor: theme.colorScheme.primaryFixed,
      ),
      body: Container(
        color: Colors.red,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Lopeta se näpyttäminen',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
