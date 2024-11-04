import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

class OSMMapScreenWeb extends StatefulWidget {
  const OSMMapScreenWeb({super.key});

  @override
  State<OSMMapScreenWeb> createState() => _OSMMapScreenState();
}

class _OSMMapScreenState extends State<OSMMapScreenWeb> {
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
