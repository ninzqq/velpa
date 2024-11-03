import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/models.dart';

class MarkerListTile extends ConsumerWidget {
  final int index;

  const MarkerListTile({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var usermarkers = ref.read(mapMarkersProvider);
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        top: 3,
        right: 4,
        bottom: 3,
      ),
      child: ListTile(
        title: Text(
          'Paikka ${index + 1}',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        subtitle: Text(
          'Lat: ${usermarkers.markers[index].point.latitude},\nLng: ${usermarkers.markers[index].point.longitude}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        tileColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
