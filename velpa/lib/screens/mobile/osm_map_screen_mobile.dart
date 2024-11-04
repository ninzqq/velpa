import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:velpa/models/local_models.dart';
import 'package:velpa/models/models.dart';
import 'package:velpa/screens/mobile/widgets/add_new_marker_bottom_sheet.dart';
import 'package:velpa/widgets/drawer.dart';
import 'package:velpa/widgets/map_screen_drawer_button.dart';

class OSMMapScreenMobile extends ConsumerWidget {
  const OSMMapScreenMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MapController mapController = MapController();
    LatLng currentCenter = ref.watch(lastCameraPositionProvider).lastCameraPos;
    double currentZoom = ref.watch(lastCameraPositionProvider).zoom;
    List<Marker> markers = ref.watch(mapMarkersProvider).markers;

    return SafeArea(
      child: Scaffold(
        drawer: const MainDrawer(),
        floatingActionButton: const MapScreenDrawerButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter:
                currentCenter, // Get Finland on the screen on startup
            initialZoom: currentZoom,
            onLongPress: (tapPosition, point) {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return AddNewMarkerBottomSheet(
                    point: point,
                  );
                },
              );
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.velpa',
            ),
            CurrentLocationLayer(
              alignPositionOnUpdate: AlignOnUpdate.never,
              alignDirectionOnUpdate: AlignOnUpdate.always,
              style: const LocationMarkerStyle(
                markerSize: Size(1, 1),
              ),
            ),
            MarkerLayer(markers: markers),
          ],
        ),
      ),
    );
  }
}
