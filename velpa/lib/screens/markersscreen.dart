import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OtherMarkersScreen extends StatelessWidget {
  final List<Marker>? markers; // Make the markers parameter nullable

  const OtherMarkersScreen({super.key, this.markers});

  @override
  Widget build(BuildContext context) {
    if (markers == null) {
      // Handle the case when markers are null (you can show a loading indicator or an error message)
      return Scaffold(
        appBar: AppBar(
          title: const Text('Omat laskupaikat'),
        ),
        body: const Center(
          child: CircularProgressIndicator(), // Show a loading indicator
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Muiden merkitsemät paikat'),
      ),
      body: ListView.builder(
        itemCount: markers?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Paikka ${index + 1}'),
            subtitle: Text(
                'Lat: ${markers?[index].position.latitude}, Lng: ${markers?[index].position.longitude}'),
          );
        },
      ),
    );
  }
}
