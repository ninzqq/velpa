import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velpa/models/models.dart';
import 'package:uuid/uuid.dart';
import 'package:velpa/services/auth.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var uuid = const Uuid();

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
  }

  Future<QuerySnapshot> getMapMarkers() async {
    return await FirebaseFirestore.instance.collection('mapMarkers').get();
  }

  Future<void> deleteMapMarker(String markerId) async {
    DocumentReference marker =
        FirebaseFirestore.instance.collection('mapMarkers').doc(markerId);
    await marker.delete();
  }
}
