import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:velpa/models/models.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var uuid = const Uuid();

  Future<void> addMapMarker(String title, String water, String description,
      double latitude, double longitude, List<String> photos) async {
    CollectionReference markers =
        FirebaseFirestore.instance.collection('mapMarkers');
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
