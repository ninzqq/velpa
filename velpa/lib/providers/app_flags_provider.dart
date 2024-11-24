import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class AppFlags extends ChangeNotifier {
  bool _debug = true;
  var logger = Logger();

  get debug {
    return _debug;
  }

  void setDebug(bool b) {
    _debug = b;
    logger.d('Debug mode: $_debug');
    notifyListeners();
  }
}

final appFlagsProvider = ChangeNotifierProvider<AppFlags>((ref) {
  return AppFlags();
});
