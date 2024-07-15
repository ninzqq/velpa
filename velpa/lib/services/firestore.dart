import 'dart:async';
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:velpa/services/auth.dart';
import 'package:velpa/models/models.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var uuid = const Uuid();

  Future<void> addMapMarker(String title, String description, double latitude,
      double longitude, List<String> photos) async {
    CollectionReference markers =
        FirebaseFirestore.instance.collection('mapMarkers');
    await markers.add({
      MapMarker(
          id: uuid.v4(),
          title: title,
          description: description,
          createdBy: FirebaseAuth.instance.currentUser!.uid,
          createdAt: DateTime.parse(FieldValue.serverTimestamp().toString()),
          updatedAt: DateTime.parse(FieldValue.serverTimestamp().toString()),
          location: GeoPoint(latitude, longitude),
          photos: photos,
          isPublic: true),
      //  'title': title,
      //  'description': description,
      //  'created_by': FirebaseAuth.instance.currentUser?.uid,
      //  'created_at': FieldValue.serverTimestamp(),
      //  'updated_at': FieldValue.serverTimestamp(),
      //  'location': GeoPoint(latitude, longitude),
      //  'photos': photos,
      //  'public': true,
    });
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
