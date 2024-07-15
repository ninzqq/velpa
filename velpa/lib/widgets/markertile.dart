import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velpa/models/models.dart';

class MarkerListTile extends StatelessWidget {
  final int index;

  const MarkerListTile({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    var usermarkers = Provider.of<MapMarkers>(context, listen: true);
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
          'Lat: ${usermarkers.markers[index].position.latitude},\nLng: ${usermarkers.markers[index].position.longitude}',
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
