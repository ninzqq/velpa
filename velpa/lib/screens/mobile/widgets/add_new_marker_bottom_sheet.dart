import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewMarkerBottomSheet extends ConsumerWidget {
  final LatLng point;
  const AddNewMarkerBottomSheet({super.key, required this.point});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add New Marker',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                    'data: Latitude: ${point.latitude}, Longitude: ${point.longitude}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
