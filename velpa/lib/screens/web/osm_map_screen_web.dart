import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class OSMMapScreen extends StatefulWidget {
  const OSMMapScreen({super.key});

  @override
  State<OSMMapScreen> createState() => _OSMMapScreenState();
}

class _OSMMapScreenState extends State<OSMMapScreen> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(65.3, 27), // Get Finland on the screen on startup
        initialZoom: 5.85,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        CurrentLocationLayer(
          alignPositionOnUpdate: AlignOnUpdate.never,
          alignDirectionOnUpdate: AlignOnUpdate.always,
          style: const LocationMarkerStyle(
            markerSize: Size(13, 13),
          ),
        ),
      ],
    );
  }
}
