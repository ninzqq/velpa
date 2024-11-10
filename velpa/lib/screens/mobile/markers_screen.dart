import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/models.dart';
import 'package:velpa/widgets/marker_list_tile.dart';

class MarkersScreen extends ConsumerWidget {
  const MarkersScreen({super.key});

  static const routeName = '/markers';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var usermarkers = ref.read(mapMarkersProvider);
    if (usermarkers.markers.isEmpty) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Markers123123'),
          ),
          body: Center(
            child: Text(
              'You haven\'t set any markers',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Markers'),
        ),
        body: ListView.builder(
          itemCount: usermarkers.markers.length,
          itemBuilder: (context, index) {
            return MarkerListTile(index: index);
          },
        ),
      ),
    );
  }
}
