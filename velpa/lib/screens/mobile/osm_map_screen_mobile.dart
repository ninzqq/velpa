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

class OSMMapScreenMobile extends ConsumerStatefulWidget {
  const OSMMapScreenMobile({super.key});

  @override
  OSMMapScreenMobileState createState() => OSMMapScreenMobileState();
}

class OSMMapScreenMobileState extends ConsumerState<OSMMapScreenMobile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapMarkersProvider).loadMarkersFromFirestore(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    MapController mapController =
        ref.watch(customMapControllerProvider).mapController;
    List<Marker> markers = ref.watch(mapMarkersProvider).markers;
    List<Marker> temporaryMarkers =
        ref.watch(mapMarkersProvider).temporaryMarkers;
    final TextEditingController titleController = TextEditingController();
    final TextEditingController waterController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        drawer: const MainDrawer(),
        floatingActionButton: const MapScreenDrawerButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        resizeToAvoidBottomInset: true,
        body: FlutterMap(
          mapController:
              mapController, // if uncommented, this will cause the map freeze
          options: MapOptions(
            keepAlive: true,
            initialCenter:
                const LatLng(65.3, 27), // Get Finland on the screen on startup
            initialZoom: 5,
            onLongPress: (tapPosition, point) {
              ref.read(mapMarkersProvider).createTempMarker(point, ref);
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return AddNewMarkerBottomSheet(
                    point: point,
                    titleController: titleController,
                    waterController: waterController,
                    descriptionController: descriptionController,
                  );
                },
              ).whenComplete(() {
                ref.read(mapMarkersProvider).removeTempMarker(ref);
              });
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
            MarkerLayer(markers: [
              ...markers,
              ...temporaryMarkers,
            ]),
          ],
        ),
      ),
    );
  }
}
