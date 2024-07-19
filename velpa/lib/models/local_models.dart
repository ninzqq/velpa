import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class AppFlags with ChangeNotifier {
  bool markerSelected = false;

  void setMarkerSelected(bool b) {
    markerSelected = b;
    notifyListeners();
  }
}

class UserProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}

class TemporaryMarker with ChangeNotifier {
  Marker marker = const Marker(markerId: MarkerId('123'));

  void set(Marker marker) {
    this.marker = marker;
    notifyListeners();
  }
}

class MapsLastCameraPosition with ChangeNotifier {
  double lat;
  double lon;
  double zoom;
  MapsLastCameraPosition({
    required this.lat,
    required this.lon,
    required this.zoom,
  });

  LatLng get lastCameraPos {
    return LatLng(lat, lon);
  }

  void setLastCameraPos(LatLng latlng, double zoom) {
    lat = latlng.latitude;
    lon = latlng.longitude;
    this.zoom = zoom;
    //print('$lat\n$lon\n$zoom');
    notifyListeners();
  }
}
