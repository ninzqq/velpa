import 'package:flutter/material.dart';
import 'package:velpa/app.dart';

void showSnackBar(String message, Icon icon, {Duration? duration}) {
  final messenger = Velpa.rootScaffoldMessengerKey.currentState;
  if (messenger != null) {
    messenger.showSnackBar(
      SnackBar(
        content: Row(children: [
          icon,
          Flexible(
            child: Text.rich(
              TextSpan(
                text: message,
              ),
            ),
          )
        ]),
        duration: duration ?? const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
      ),
    );
  }
}
