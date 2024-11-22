import 'package:flutter/material.dart';
import 'package:velpa/app.dart';

void showSnackBar(String message, {Duration? duration}) {
  final messenger = Velpa.rootScaffoldMessengerKey.currentState;
  if (messenger != null) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 2),
      ),
    );
  }
}
