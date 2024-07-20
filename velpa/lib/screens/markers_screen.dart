import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/models.dart';
import 'package:velpa/widgets/markertile.dart';

class OtherMarkersScreen extends ConsumerWidget {
  const OtherMarkersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var usermarkers = ref.read(mapMarkersProvider);
    if (usermarkers.markers.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Markers123123'),
        ),
        body: Center(
          child: Text(
            'You haven\'t set any markers',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Markers'),
      ),
      body: ListView.builder(
        itemCount: usermarkers.markers.length,
        itemBuilder: (context, index) {
          return MarkerListTile(index: index);
        },
      ),
    );
  }
}
