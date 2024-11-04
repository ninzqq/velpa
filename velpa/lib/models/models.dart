import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velpa/models/local_models.dart';

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

class MapMarker {
  String id;
  String title;
  String description;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  GeoPoint location;
  List<String> photos;
  bool isPublic;

  MapMarker({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.location,
    required this.photos,
    required this.isPublic,
  });

  // Muuntaa Firestore-dokumentin MapMarker-olioksi
  factory MapMarker.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return MapMarker(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdBy: data['created_by'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
      location: data['location'] ?? const GeoPoint(0, 0),
      photos: List<String>.from(data['photos'] ?? []),
      isPublic: data['public'] ?? true,
    );
  }

  // Muuntaa MapMarker-olion Map-muotoon Firestorea varten
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'location': location,
      'photos': photos,
      'public': isPublic,
    };
  }
}

class MapMarkers extends ChangeNotifier {
  List<Marker> markers = [];

  void addNewMarker(Marker marker, WidgetRef ref) {
    final appFlags = ref.read(appFlagsProvider);

    markers.add(marker);

    if (appFlags.debug) {
      print(
          'Add position lat: ${marker.point.latitude} lon: ${marker.point.longitude}');
      //printMarkers();
    }

    notifyListeners();
  }

  void removeLastMarker() {
    markers.removeLast();
    notifyListeners();
  }

  void printMarkers() {
    print(markers);
  }
}

final mapMarkersProvider = ChangeNotifierProvider<MapMarkers>((ref) {
  return MapMarkers();
});

class TemporaryMapMarker extends ChangeNotifier {
  Marker? marker;

  void setTemporaryMarker(Marker marker) {
    this.marker = marker;
    print(
        'Add temporary marker at lat: ${marker.point.latitude} lon: ${marker.point.longitude}');
    notifyListeners();
  }

  void removeTemporaryMarker() {
    marker = null;
    notifyListeners();
  }
}

final temporaryMapMarkerProvider = ChangeNotifierProvider<TemporaryMapMarker>(
  (ref) {
    return TemporaryMapMarker();
  },
);
