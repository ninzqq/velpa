import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:velpa/screens/mobile/widgets/marker_map_icon.dart';

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

  MapMarker({
    super.point = const LatLng(0.0, 0.0),
    super.child = const Icon(Icons.location_on),
    this.id = '',
    this.title = '',
    this.water = '',
    this.description = '',
    this.createdBy = '',
    this.photos = const [],
    this.isPublic = false,
    this.isVerified = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    // These two are needed to make the icon appear in the correct position
    super.height = 22.0,
    super.alignment = Alignment.topCenter,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

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
