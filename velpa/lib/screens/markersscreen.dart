import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velpa/local_models/models.dart';
import 'package:velpa/widgets/markertile.dart';

class OtherMarkersScreen extends StatelessWidget {
  const OtherMarkersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var usermarkers = Provider.of<UserMarkers>(context, listen: true);
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
