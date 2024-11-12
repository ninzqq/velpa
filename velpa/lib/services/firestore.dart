import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
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
    await ref.doc(id).set({'PASKAA': 'No VITTU', 'JAAHAS': 'JOOHOS'});
  }

  Future<void> addMapMarker(String title, String water, String description,
      double latitude, double longitude, List<String> photos) async {
    var user = AuthService().user!;
    CollectionReference markers =
        db.collection('users').doc(user.uid).collection('mapMarkers');
    await markers.add({
      MapMarker(
          point: LatLng(latitude, longitude),
          child: const Text(''),
          id: uuid.v4(),
          title: title,
          water: water,
          description: description,
          createdBy: FirebaseAuth.instance.currentUser!.uid,
          createdAt: DateTime.parse(FieldValue.serverTimestamp().toString()),
          updatedAt: DateTime.parse(FieldValue.serverTimestamp().toString()),
          photos: photos,
          isPublic: true,
          isVerified: false),
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
