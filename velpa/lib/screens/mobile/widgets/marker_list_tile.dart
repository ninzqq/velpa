import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:velpa/providers/custom_map_controller_provider.dart';
import 'package:velpa/providers/map_markers_provider.dart';
import 'package:velpa/screens/mobile/widgets/marker_details_bottom_sheet.dart';

class MarkerListTile extends ConsumerWidget {
  final int index;

  const MarkerListTile({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var markers = ref.read(mapMarkersProvider).filteredMarkers;
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(
            markers[index].title,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          subtitle: Text(
            '${markers[index].water}\n${markers[index].description}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: TrailingIcon(id: markers[index].id),
          tileColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class TrailingIcon extends ConsumerWidget {
  final String id;
  const TrailingIcon({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marker = ref.read(mapMarkersProvider).getMarkerById(id);
    final mapController = ref.read(customMapControllerProvider).mapController;

    return GestureDetector(
      onTap: () {
        var nav = Navigator.of(context);
        nav.popUntil((route) => route.isFirst);
        mapController.move(
          LatLng(marker!.point.latitude - 0.09, marker.point.longitude),
          10,
        );
        showModalBottomSheet(
            context: context,
            builder: (context) => MarkerDetailsBottomSheet(id: marker.id));
      },
      child: const Icon(
        Icons.chevron_right_rounded,
        size: 40,
        color: Colors.white70,
      ),
    );
  }
}
