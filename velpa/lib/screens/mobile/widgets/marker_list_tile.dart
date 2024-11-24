import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/providers/map_markers_provider.dart';

class MarkerListTile extends ConsumerWidget {
  final int index;

  const MarkerListTile({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var markers = ref.read(mapMarkersProvider).markers;
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: ListTile(
        title: Text(
          markers[index].title,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        subtitle: Text(
          '${markers[index].water}\n${markers[index].description}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        tileColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
