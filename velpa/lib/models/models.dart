import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LastKnownUserPosition with ChangeNotifier {
  double lat;
  double lon;
  LastKnownUserPosition({
    this.lat = 0.0,
    this.lon = 0.0,
  });

  void setLastKnownUserPosition(double lat, double lon) {
    this.lat = lat;
    this.lon = lon;
    //print('$lat\n$lon');
    notifyListeners();
  }
}

class UserMarkers with ChangeNotifier {
  List<Marker> markers = [];

  void add(Marker marker) {
    markers.add(marker);
    print(
        'Add position lat: ${marker.position.latitude}, lon: ${marker.position.longitude}.');
    notifyListeners();
    printMarkers();
  }

  void printMarkers() {
    print(markers);
  }
}
