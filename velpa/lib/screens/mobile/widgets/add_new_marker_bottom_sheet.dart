import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          );
        },
      ),
    );
  }
}
