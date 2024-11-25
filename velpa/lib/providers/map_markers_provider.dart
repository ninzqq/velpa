import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';
import 'package:velpa/models/map_marker_model.dart';
import 'package:velpa/providers/app_flags_provider.dart';
import 'package:velpa/screens/mobile/widgets/marker_map_icon.dart';
import 'package:velpa/services/auth.dart';
import 'package:velpa/services/firestore.dart';
import 'package:velpa/utils/snackbar.dart';

class MapMarkers extends ChangeNotifier {
  List<MapMarker> markers = [];
  List<MapMarker> temporaryMarkers = [];
  MapMarker? tempMarker;

  var logger = Logger();

  bool _isLoading = false;

  Future<void> loadMarkersFromFirestore(WidgetRef ref) async {
    final appFlags = ref.read(appFlagsProvider);

    // Prevent multiple simultaneous loads
    if (_isLoading) return;
    _isLoading = true;

    try {
      List<MapMarker> firestoreMarkers =
          await FirestoreService().getUnverifiedMarkers();

      // Add visual marker icons to each marker
      markers = firestoreMarkers
          .map((marker) => marker.copyWith(child: MarkerMapIcon(marker.id)))
          .toList();

      notifyListeners();
      if (appFlags.debug) {
        logger.d('${markers.length} markers loaded from firestore');
      }
    } catch (e) {
      logger.e('Error loading markers: $e');
      showSnackBar(
        'Error loading markers: $e',
        const Icon(Icons.priority_high_rounded, color: Colors.red),
        duration: const Duration(seconds: 5),
      );
    } finally {
      _isLoading = false;
    }
  }

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

  void createTempMarker(LatLng point, WidgetRef ref) {
    final user = AuthService().user;
    final appFlags = ref.read(appFlagsProvider);
    final String id = const Uuid().v4();
    double latitude = double.parse(point.latitude.toStringAsFixed(7));
    double longitude = double.parse(point.longitude.toStringAsFixed(7));

    tempMarker = MapMarker(
      point: LatLng(latitude, longitude),
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
      var marker = markers.firstWhere((element) => element.id == id);
      return marker;
    } catch (e) {
      try {
        var tempMarker =
            temporaryMarkers.firstWhere((element) => element.id == id);
        return tempMarker;
      } catch (e) {
        logger.e('Marker with id $id not found');
        return null;
      }
    }
  }
}

final mapMarkersProvider = ChangeNotifierProvider<MapMarkers>((ref) {
  return MapMarkers();
});
