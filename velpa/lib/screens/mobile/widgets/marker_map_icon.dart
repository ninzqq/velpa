import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
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

    return GestureDetector(
      child: const Icon(
        Icons.location_on,
        color: Colors.blue,
      ),
      onTap: () => {
        appFlags.debug ? logger.d('Marker $id tapped!}') : null,
        if (marker == null)
          {
            showSnackBar('Marker $id not found', const Icon(Icons.error)),
          }
        else
          {
            if (mapController.camera.zoom < 10)
              mapController.move(
                  LatLng(marker.point.latitude - 0.09, marker.point.longitude),
                  10),
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return MarkerDetailsBottomSheet(id: id);
              },
            ),
          }
      },
    );
  }
}
