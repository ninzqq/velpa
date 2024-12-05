import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velpa/providers/map_markers_provider.dart';
import 'package:velpa/screens/mobile/widgets/add_new_marker_bottom_sheet.dart';
import 'package:velpa/services/auth.dart';
import 'package:velpa/utils/snackbar.dart';

class OsmMap extends ConsumerWidget {
  final List markers;
  final List temporaryMarkers;
  final MapController mapController;
  final TextEditingController titleController;
  final TextEditingController waterController;
  final TextEditingController descriptionController;
  const OsmMap(
      {super.key,
      required this.markers,
      required this.temporaryMarkers,
      required this.mapController,
      required this.titleController,
      required this.waterController,
      required this.descriptionController});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterMap(
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
        maxZoom: 15,
        minZoom: 2,
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
              showSnackBar('Marker is not within bounds',
                  const Icon(Icons.priority_high_rounded, color: Colors.red));
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
          maxZoom: 15,
          minZoom: 2,
          tileSize: 256,
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
        RichAttributionWidget(
          animationConfig: const ScaleRAWA(), // Or `FadeRAWA` as is default
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () async {
                try {
                  final Uri url =
                      Uri.parse('https://openstreetmap.org/copyright');
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } catch (e) {
                  if (context.mounted) {
                    showSnackBar('Could not open URL',
                        const Icon(Icons.error, color: Colors.red));
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
