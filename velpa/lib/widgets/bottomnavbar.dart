import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: ListView(
          children: [
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.map),
            ),
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.account_circle),
            ),
          ],
        ),
      ),
    );
  }
}
