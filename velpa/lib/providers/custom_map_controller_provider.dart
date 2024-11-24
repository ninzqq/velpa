import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomMapController extends ChangeNotifier {
  MapController _mapController = MapController();

  MapController get mapController {
    return _mapController;
  }

  void setMapController(MapController controller) {
    if (_mapController != controller) {
      _mapController = controller;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}

final customMapControllerProvider =
    ChangeNotifierProvider<CustomMapController>((ref) {
  return CustomMapController();
});
