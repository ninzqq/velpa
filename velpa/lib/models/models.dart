import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import 'package:velpa/models/local_models.dart';
import 'package:logger/logger.dart';
import 'package:velpa/screens/mobile/widgets/marker_map_icon.dart';
import 'package:velpa/services/auth.dart';

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
  final String water;
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
    required this.water,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.photos,
    required this.isPublic,
    required this.isVerified,
    // These two are needed to make the icon appear in the correct position
    super.height = 22.0,
    super.alignment = Alignment.topCenter,
  });

  set setPoint(LatLng point) {
    point = point;
  }

  set setTitle(String title) {
    title = title;
    var logger = Logger();
    logger.d('Title set to $title');
  }

  set setWater(String water) {
    water = water;
  }

  set setDescription(String description) {
    description = description;
  }

  set setCreatedBy(String createdBy) {
    createdBy = createdBy;
  }

  set setCreatedAt(DateTime createdAt) {
    createdAt = createdAt;
  }

  set setUpdatedAt(DateTime updatedAt) {
    updatedAt = updatedAt;
  }

  set setPhotos(List<String> photos) {
    photos = photos;
  }

  set setIsPublic(bool isPublic) {
    isPublic = isPublic;
  }

  set setIsVerified(bool isVerified) {
    isVerified = isVerified;
  }

  // Muuntaa Firestore-dokumentin MapMarker-olioksi
  factory MapMarker.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return MapMarker(
      point: LatLng(data['point'].latitude, data['point'].longitude),
      child: MarkerMapIcon(data['id']),
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      water: data['water'] ?? '',
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
      'child': 'Not in Firestore',
      'id': id,
      'title': title,
      'water': water,
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
  MapMarker? tempMarker;

  var logger = Logger();

  void addMarker(WidgetRef ref) {
    final appFlags = ref.read(appFlagsProvider);

    MapMarker marker = temporaryMarkers.last;

    markers.add(marker);

    if (appFlags.debug) {
      logger.d('Moved temp marker ${marker.id} to actual markers.');
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
      water: '',
      description: '',
      createdBy: 'Anonymous',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      photos: const [],
      isPublic: false,
      isVerified: false,
      child: MarkerMapIcon(id),
    );

    temporaryMarkers.add(tempMarker);

    if (appFlags.debug) {
      logger.d(
          'Add temporary marker at lat: ${tempMarker.point.latitude} lon: ${tempMarker.point.longitude}, id: ${tempMarker.id}');
    }

    notifyListeners();
  }

  void clearTemporaryMarkers(WidgetRef ref) {
    final appFlags = ref.read(appFlagsProvider);
    temporaryMarkers.clear();

    if (appFlags.debug) {
      logger.d('Temporary markers cleared');
    }
    notifyListeners();
  }

  void createTempMarker(LatLng point, WidgetRef ref) {
    final user = AuthService().user;
    final appFlags = ref.read(appFlagsProvider);
    final String id = const Uuid().v4();

    tempMarker = MapMarker(
      point: point,
      id: id,
      title: '',
      water: '',
      description: '',
      createdBy: user != null ? user.email.toString() : 'Anonymous',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      photos: const [],
      isPublic: false,
      isVerified: false,
      child: MarkerMapIcon(id),
    );

    if (appFlags.debug) {
      logger.d('Created temporary marker with id: ${tempMarker!.id}');
    }

    temporaryMarkers.add(tempMarker!);

    notifyListeners();
  }

  void updateTempMarker(MapMarker marker, WidgetRef ref) {
    final appFlags = ref.read(appFlagsProvider);
    tempMarker = marker;

    if (appFlags.debug) {
      logger.d('Updated temporary marker with id: ${tempMarker!.id}');
    }

    notifyListeners();
  }

  void removeTempMarker(WidgetRef ref) {
    final appFlags = ref.read(appFlagsProvider);

    tempMarker = null;
    temporaryMarkers.clear();

    if (appFlags.debug) {
      logger.d('Temporary marker cleared');
    }

    notifyListeners();
  }

  void checkTempMarker() {
    if (tempMarker == null) {
      logger.e('No temporary marker found');
      return;
    } else {
      logger.d(
          'Temporary marker found with \nid: ${tempMarker!.id} \nlat: ${tempMarker!.point.latitude} \nlon: ${tempMarker!.point.longitude} \ntitle: ${tempMarker!.title} \nwater: ${tempMarker!.water} \ndescription: ${tempMarker!.description} \ncreated by: ${tempMarker!.createdBy} \ncreated at: ${tempMarker!.createdAt} \nupdated at: ${tempMarker!.updatedAt} \nphotos: ${tempMarker!.photos} \nis public: ${tempMarker!.isPublic} \nis verified: ${tempMarker!.isVerified}');
    }
  }

  MapMarker? getMarkerById(String id) {
    try {
      return markers.firstWhere((element) => element.id == id);
    } catch (e) {
      logger.e('Marker with id $id not found');
      return null;
    }
  }

  void printMarkers() {
    logger.d(markers);
  }
}

final mapMarkersProvider = ChangeNotifierProvider<MapMarkers>((ref) {
  return MapMarkers();
});
