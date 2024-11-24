import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:velpa/models/map_marker_model.dart';
import 'package:uuid/uuid.dart';
import 'package:velpa/services/auth.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var uuid = const Uuid();

  final Logger logger = Logger();

  Future<void> addTestStuff() async {
    var user = AuthService().user!;
    var id = const Uuid().v4();
    CollectionReference ref =
        db.collection('users').doc(user.uid).collection('testinks');
    await ref.doc(id).set({
      'PASKAA': 'No VITTU',
      'JAAHAS': 'JOOHOS',
    });
  }

  Future<void> addMapMarkerToFirestore(MapMarker marker) async {
    var user = AuthService().user!;
    CollectionReference ref = db.collection('unverifiedMarkers');

    var data = {
      'point': GeoPoint(marker.point.latitude, marker.point.longitude),
      'title': marker.title,
      'water': marker.water,
      'description': marker.description,
      'createdBy': user.email,
      'createdAt': marker.createdAt,
      'updatedAt': marker.updatedAt,
      'photos': marker.photos,
      'isPublic': false,
      'isVerified': false,
    };

    await ref.doc(marker.id).set(data);

    logger.d('Added unverified marker to firestore: ${marker.id}');
  }

  Future<List<MapMarker>> getUnverifiedMarkers() async {
    QuerySnapshot snapshot = await db.collection('unverifiedMarkers').get();

    return snapshot.docs.map((doc) {
      GeoPoint point = doc.get('point');
      return MapMarker(
        id: doc.id,
        point: LatLng(point.latitude, point.longitude),
        title: doc.get('title'),
        water: doc.get('water'),
        description: doc.get('description'),
        createdBy: doc.get('createdBy'),
        createdAt: doc.get('createdAt').toDate(),
        updatedAt: doc.get('updatedAt').toDate(),
        photos: List<String>.from(doc.get('photos')),
        isPublic: doc.get('isPublic'),
        isVerified: doc.get('isVerified'),
      );
    }).toList();
  }

  Future<QuerySnapshot> getMapMarkers() async {
    return await FirebaseFirestore.instance.collection('mapMarkers').get();
  }

  Future<void> deleteMapMarker(String markerId) async {
    DocumentReference marker = FirebaseFirestore.instance
        .collection('unverifiedMarkers')
        .doc(markerId);
    await marker.delete().then((_) {
      logger.d('Deleted unverified marker from firestore: $markerId');
    });
  }
}
