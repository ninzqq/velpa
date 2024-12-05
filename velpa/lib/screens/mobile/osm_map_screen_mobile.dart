import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:velpa/models/map_marker_model.dart';
import 'package:velpa/providers/custom_map_controller_provider.dart';
import 'package:velpa/providers/map_markers_provider.dart';
import 'package:velpa/screens/mobile/widgets/add_new_marker_bottom_sheet.dart';
import 'package:velpa/screens/mobile/widgets/osm_map.dart';
import 'package:velpa/services/auth.dart';
import 'package:velpa/utils/intro_dialog.dart';
import 'package:velpa/utils/snackbar.dart';
import 'package:velpa/utils/drawer.dart';
import 'package:velpa/utils/map_screen_drawer_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;

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
    List<Marker> markers = ref.watch(mapMarkersProvider).markers;
    List<MapMarker> temporaryMarkers =
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
        body: OsmMap(
          markers: markers,
          temporaryMarkers: temporaryMarkers,
          mapController: mapController,
          titleController: titleController,
          waterController: waterController,
          descriptionController: descriptionController,
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

  LatLng convertToEtrsTM35FIN(LatLng latLng) {
    final wgs84 = proj4.Projection.get('EPSG:4326'); // WGS84
    final etrsTM35FIN = proj4.Projection.get('EPSG:3067') ??
        proj4.Projection.add('EPSG:3067',
            '+proj=utm +zone=35 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs +type=crs'); // ETRS-TM35FIN

    final point = proj4.Point(x: latLng.longitude, y: latLng.latitude);
    final transformedPoint = etrsTM35FIN.transform(wgs84!, point);
    return LatLng(transformedPoint.y, transformedPoint.x);
  }
}
