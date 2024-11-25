import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:velpa/models/map_marker_model.dart';
import 'package:velpa/providers/custom_map_controller_provider.dart';
import 'package:velpa/providers/map_markers_provider.dart';
import 'package:velpa/providers/app_flags_provider.dart';
import 'package:velpa/screens/mobile/widgets/marker_details_bottom_sheet.dart';
import 'package:velpa/utils/snackbar.dart';

class MarkerMapIcon extends ConsumerWidget {
  final String id;

  const MarkerMapIcon(this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appFlags = ref.read(appFlagsProvider);
    final mapController = ref.read(customMapControllerProvider).mapController;
    final marker = ref.read(mapMarkersProvider).getMarkerById(id);
    var logger = Logger();

    // Early return if marker is null
    if (marker == null) {
      showSnackBar(
          'Marker $id not found', const Icon(Icons.error)); // Error state
      return const Icon(Icons.location_on, color: Colors.red);
    }

    final iconColor = _getMarkerColor(marker);

    return GestureDetector(
      child: Icon(Icons.location_on, color: iconColor),
      onTap: () {
        if (appFlags.debug) logger.d('Marker $id tapped!}');
        if (mapController.camera.zoom < 10) {
          mapController.move(
            LatLng(marker.point.latitude - 0.09, marker.point.longitude),
            10,
          );
        }
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => MarkerDetailsBottomSheet(id: id),
        );
      },
    );
  }

  Color _getMarkerColor(MapMarker? marker) {
    if (marker == null) return Colors.red; // Error state
    if (marker.isVerified) return Colors.blue;
    return Colors.grey; // Unverified state
  }
}
