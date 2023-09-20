import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
