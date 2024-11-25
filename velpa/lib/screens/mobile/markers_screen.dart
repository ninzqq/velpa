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
    var theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.primaryFixed,
          title: Text(
            'Markers',
            style: theme.textTheme.titleLarge,
          ),
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
