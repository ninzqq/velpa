import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
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
    LatLng currentCenter = ref.read(lastCameraPositionProvider).lastCameraPos;
    double currentZoom = ref.read(lastCameraPositionProvider).zoom;
    List<Marker> markers = ref.watch(mapMarkersProvider).markers;
    List<Marker> temporaryMarkers =
        ref.watch(mapMarkersProvider).temporaryMarkers;

    return SafeArea(
      child: Scaffold(
        drawer: const MainDrawer(),
        floatingActionButton: const MapScreenDrawerButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: FlutterMap(
          //mapController: mapController, // if uncommented, this will cause the map freeze
          options: MapOptions(
            initialCenter:
                const LatLng(65.3, 27), // Get Finland on the screen on startup
            initialZoom: 5,
            onLongPress: (tapPosition, point) {
              ref.read(mapMarkersProvider).addTemporaryMarker(
                    Marker(
                      key: ValueKey(const Uuid().v1()),
                      height: 22.0,
                      point: point,
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                        ),
                        onTap: () => print(
                            'Marker $key tapped! Point: ${point.toString()}'),
                      ),
                    ),
                    ref,
                  );
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return AddNewMarkerBottomSheet(
                    point: point,
                  );
                },
              ).whenComplete(
                () => ref.read(mapMarkersProvider).clearTemporaryMarkers(ref),
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
            MarkerLayer(markers: [...markers, ...temporaryMarkers]),
          ],
        ),
      ),
    );
  }
}
