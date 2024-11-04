import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class BottomNavBarIndex with ChangeNotifier {
  int idx;
  BottomNavBarIndex({
    this.idx = 0,
  });

  void changeIndex(int index) {
    idx = index;
    notifyListeners();
  }
}

class AppFlags extends ChangeNotifier {
  bool _markerSelected = false;
  bool _debug = true;

  get markerSelected {
    return _markerSelected;
  }

  get debug {
    return _debug;
  }

  void setMarkerSelected(bool b) {
    _markerSelected = b;
    notifyListeners();
  }

  void setDebug(bool b) {
    _debug = b;
    print('Debug mode: $_debug');
    notifyListeners();
  }
}

final appFlagsProvider = ChangeNotifierProvider<AppFlags>((ref) {
  return AppFlags();
});

class UserState extends ChangeNotifier {
  bool _isLoggedIn = false;

  get isLoggedIn {
    return _isLoggedIn;
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

final userStateProvider = ChangeNotifierProvider<UserState>((ref) {
  return UserState();
});

class MapsLastCameraPositionState extends ChangeNotifier {
  double lat = 65.3;
  double lon = 27;
  double zoom = 5;

  LatLng get lastCameraPos {
    return LatLng(lat, lon);
  }

  void setLastCameraPos(LatLng latlng, double zoom) {
    lat = latlng.latitude;
    lon = latlng.longitude;
    zoom = zoom;
    //print('$lat\n$lon\n$zoom');
    notifyListeners();
  }
}

final lastCameraPositionProvider =
    ChangeNotifierProvider<MapsLastCameraPositionState>((ref) {
  return MapsLastCameraPositionState();
});
