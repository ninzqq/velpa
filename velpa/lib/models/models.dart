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

  MapMarker copyWith({
    LatLng? point,
    Widget? child,
    String? id,
    String? title,
    String? water,
    String? description,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? photos,
    bool? isPublic,
    bool? isVerified,
  }) {
    return MapMarker(
      point: point ?? this.point,
      child: child ?? this.child,
      id: id ?? this.id,
      title: title ?? this.title,
      water: water ?? this.water,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      photos: photos ?? this.photos,
      isPublic: isPublic ?? this.isPublic,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

class MapMarkers extends ChangeNotifier {
  List<MapMarker> markers = [];
  List<MapMarker> temporaryMarkers = [];
  MapMarker? tempMarker;

  var logger = Logger();

  void addMarker(WidgetRef ref) {
    final appFlags = ref.read(appFlagsProvider);

    MapMarker marker = tempMarker!;

    markers.add(marker);

    if (appFlags.debug) {
      logger.d('Moved temp marker ${marker.id} to actual markers.');
    }

    checkTempMarker();

    notifyListeners();
  }

  void removeLastMarker() {
    markers.removeLast();
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
