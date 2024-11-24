import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/providers/map_markers_provider.dart';
import 'package:velpa/screens/mobile/widgets/marker_list_tile.dart';

class MarkersScreen extends ConsumerWidget {
  const MarkersScreen({super.key});

  static const routeName = '/markers';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var usermarkers = ref.read(mapMarkersProvider);

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
