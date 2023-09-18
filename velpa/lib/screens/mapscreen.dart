import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  List<Marker> markers = [];
  Location location = Location();

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {
        mapController = controller;
        _navigateToUserLocation();
      },
      markers: Set<Marker>.from(markers),
      initialCameraPosition: const CameraPosition(
        target: LatLng(0, 0), // Esimerkkisijainti: San Francisco
        zoom: 10.0,
      ),
      onTap: (LatLng location) {
        // Merkitse paikka kartalle
        setState(() {
          markers.add(
            Marker(
              markerId: MarkerId(location.toString()),
              position: location,
              infoWindow: const InfoWindow(title: 'Merkitty paikka'),
            ),
          );
        });
      },
    );
  }

  void _navigateToUserLocation() async {
    LocationData locationData = await location.getLocation();
    double latitude =
        locationData.latitude ?? 0.0; // Provide a default value if null
    double longitude =
        locationData.longitude ?? 0.0; // Provide a default value if null

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 15.0,
        ),
      ),
    );
  }
}
