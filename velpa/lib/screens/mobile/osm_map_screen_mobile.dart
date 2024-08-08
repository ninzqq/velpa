import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:velpa/models/local_models.dart';
import 'package:velpa/widgets/drawer.dart';

class OSMMapScreenMobile extends ConsumerWidget {
  const OSMMapScreenMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MapController mapController = MapController();
    LatLng currentCenter = ref.watch(lastCameraPositionProvider).lastCameraPos;
    double currentZoom = ref.watch(lastCameraPositionProvider).zoom;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Velpa'),
        ),
        drawer: const MainDrawer(),
        body: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter:
                currentCenter, // Get Finland on the screen on startup
            initialZoom: currentZoom,
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
        ),
      ),
    );
  }
}
