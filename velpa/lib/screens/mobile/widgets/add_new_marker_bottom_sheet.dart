import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/models.dart';

class AddNewMarkerBottomSheet extends ConsumerWidget {
  final LatLng point;
  const AddNewMarkerBottomSheet({super.key, required this.point});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: BottomSheet(
        enableDrag: false,
        backgroundColor: theme.colorScheme.primary,
        onClosing: () {},
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Add New Marker',
                      style: theme.textTheme.labelMedium,
                    ),
                    Text(
                      'data: Latitude: ${point.latitude}, Longitude: ${point.longitude}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ref.read(mapMarkersProvider).addMarker(ref);
                        Navigator.pop(context);
                      },
                      child: const Text('Add Marker'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
