import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
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

class MapMarker extends Marker {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> photos;
  final bool isPublic;
  final bool isVerified;

  const MapMarker({
    required super.point,
    required super.child,
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.photos,
    required this.isPublic,
    required this.isVerified,
  });

  // Muuntaa Firestore-dokumentin MapMarker-olioksi
  factory MapMarker.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return MapMarker(
      point: LatLng(data['point'].latitude, data['point'].longitude),
      child: data['child'] ?? '',
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdBy: data['created_by'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
      photos: List<String>.from(data['photos'] ?? []),
      isPublic: data['public'] ?? true,
      isVerified: data['isVerified'] ?? false,
    );
  }

  // Muuntaa MapMarker-olion Map-muotoon Firestorea varten
  Map<String, dynamic> toFirestore() {
    return {
      'point': point,
      'child': child,
      'id': id,
      'title': title,
      'description': description,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'photos': photos,
      'public': isPublic,
      'isVerified': false,
    };
  }
}

class MapMarkers extends ChangeNotifier {
  List<MapMarker> markers = [];
  List<MapMarker> temporaryMarkers = [];

  void addMarker(WidgetRef ref) {
    final appFlags = ref.read(appFlagsProvider);

    MapMarker marker = temporaryMarkers.last;

    markers.add(marker);

    if (appFlags.debug) {
      print('Moved temp marker ${marker.id} to actual markers.');
    }

    notifyListeners();
  }

  void removeLastMarker() {
    markers.removeLast();
    notifyListeners();
  }

  void addTemporaryMarker(LatLng point, WidgetRef ref) {
    final appFlags = ref.read(appFlagsProvider);
    final String id = const Uuid().v4();

    MapMarker tempMarker = MapMarker(
      point: point,
      id: id,
      title: '',
      description: '',
      createdBy: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      photos: const [],
      isPublic: false,
      isVerified: false,
      child: GestureDetector(
        child: const Icon(
          Icons.location_on,
          color: Colors.blue,
        ),
        onTap: () => {
          appFlags.debug
              ? print('Marker $id tapped! Point: ${point.toString()}')
              : null
        },
      ),
    );

    temporaryMarkers.add(tempMarker);

    if (appFlags.debug) {
      print(
          'Add temporary marker at lat: ${tempMarker.point.latitude} lon: ${tempMarker.point.longitude}, id: ${tempMarker.id}');
    }

    notifyListeners();
  }

  void clearTemporaryMarkers(WidgetRef ref) {
    final appFlags = ref.read(appFlagsProvider);
    temporaryMarkers.clear();

    if (appFlags.debug) {
      print('Temporary markers cleared');
    }
    notifyListeners();
  }

  void printMarkers() {
    print(markers);
  }
}

final mapMarkersProvider = ChangeNotifierProvider<MapMarkers>((ref) {
  return MapMarkers();
});
