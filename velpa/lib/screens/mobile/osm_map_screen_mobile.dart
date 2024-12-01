import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:velpa/providers/custom_map_controller_provider.dart';
import 'package:velpa/providers/map_markers_provider.dart';
import 'package:velpa/screens/mobile/widgets/add_new_marker_bottom_sheet.dart';
import 'package:velpa/services/auth.dart';
import 'package:velpa/utils/intro_dialog.dart';
import 'package:velpa/utils/snackbar.dart';
import 'package:velpa/utils/drawer.dart';
import 'package:velpa/utils/map_screen_drawer_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OSMMapScreenMobile extends ConsumerStatefulWidget {
  const OSMMapScreenMobile({super.key});

  @override
  OSMMapScreenMobileState createState() => OSMMapScreenMobileState();
}

class OSMMapScreenMobileState extends ConsumerState<OSMMapScreenMobile> {
  late MapController mapController;
  @override
  void initState() {
    super.initState();
    mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(customMapControllerProvider).setMapController(mapController);
      await ref.read(mapMarkersProvider).loadMarkersFromFirestore(ref);
      if (mounted) {
        showIntroDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> markers =
        ref.watch(mapMarkersProvider.select((value) => value.markers));
    List<Marker> temporaryMarkers =
        ref.watch(mapMarkersProvider.select((value) => value.temporaryMarkers));
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
          mapController: mapController,
          options: MapOptions(
            keepAlive: true,
            initialCenter:
                const LatLng(65.3, 26), // Get Finland on the screen on startup
            initialZoom: 5.25,
            interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.pinchZoom |
                    InteractiveFlag.drag |
                    InteractiveFlag.doubleTapDragZoom |
                    InteractiveFlag.doubleTapZoom |
                    InteractiveFlag.pinchMove),
            maxZoom: 19,
            minZoom: 5,
            onLongPress: (tapPosition, point) {
              if (AuthService().user == null) {
                showSnackBar('Please login to add a marker',
                    const Icon(Icons.priority_high_rounded, color: Colors.red));
                return;
              } else {
                final isWithinBounds = ref
                    .read(mapMarkersProvider)
                    .checkTempMarkerIsWithinBounds(point);
                if (!isWithinBounds) {
                  showSnackBar(
                      'Marker is not within bounds',
                      const Icon(Icons.priority_high_rounded,
                          color: Colors.red));
                  return;
                }
                ref.read(mapMarkersProvider).createTempMarker(point, ref);
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return AddNewMarkerBottomSheet(
                      titleController: titleController,
                      waterController: waterController,
                      descriptionController: descriptionController,
                    );
                  },
                ).whenComplete(() {
                  ref.read(mapMarkersProvider).removeTempMarker(ref);
                });
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.velpa',
            ),
            CurrentLocationLayer(
              alignPositionOnUpdate: AlignOnUpdate.never,
              alignDirectionOnUpdate: AlignOnUpdate.never,
              style: const LocationMarkerStyle(
                markerSize: Size(12, 12),
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

  void showIntroDialog(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? intro = prefs.getBool('intro');
    if (intro == true) {
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const IntroDialog();
        });

    await prefs.setBool('intro', true);
  }
}
