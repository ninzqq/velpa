import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/models.dart';

class MarkerDetails extends ConsumerWidget {
  const MarkerDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    final markerProvider = ref.watch(mapMarkersProvider);
    final marker = markerProvider.markers.last;

    if (marker == null) {
      return const SizedBox.shrink();
    }
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                marker.title,
                style: theme.textTheme.labelMedium,
              ),
              SizedBox(height: 8.0),
              Text(
                marker.description,
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 8.0),
              Text(
                'Latitude: ${marker.point.latitude}',
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                'Longitude: ${marker.point.longitude}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
