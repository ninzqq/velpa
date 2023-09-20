import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:velpa/local_models/local_models.dart';
import 'package:velpa/local_models/models.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Location location = Location();

  @override
  Widget build(BuildContext context) {
    var lastCameraPos =
        Provider.of<MapsLastCameraPosition>(context, listen: true);
    var usermarkers = Provider.of<UserMarkers>(context, listen: true);

    return GoogleMap(
      onMapCreated: (controller) {
        mapController = controller;
        _navigateToLastCameraPositionOrUserLocation();
      },
      markers: Set<Marker>.from(usermarkers.markers),
      initialCameraPosition: CameraPosition(
        target: LatLng(lastCameraPos.lat, lastCameraPos.lon),
        zoom: lastCameraPos.zoom,
      ),
      onTap: (LatLng location) {
        // Merkitse paikka kartalle
        setState(() {
          usermarkers.add(
            Marker(
              markerId: MarkerId(location.toString()),
              position: location,
              infoWindow: const InfoWindow(title: 'Merkitty paikka'),
            ),
          );
        });
      },
      onCameraMove: ((position) => {
            lastCameraPos.setLastCameraPos(
              LatLng(position.target.latitude, position.target.longitude),
              position.zoom,
            ),
          }),
    );
  }

  void _navigateToLastCameraPositionOrUserLocation() async {
    var lastCameraPos =
        Provider.of<MapsLastCameraPosition>(context, listen: false);
    double latitude = 0.0;
    double longitude = 0.0;
    double zoom = 10.0;

    if (lastCameraPos.lat == 0 && lastCameraPos.lon == 0) {
      LocationData locationData = await location.getLocation();
      latitude =
          locationData.latitude ?? 0.0; // Provide a default value if null
      longitude =
          locationData.longitude ?? 0.0; // Provide a default value if null
    } else {
      latitude = lastCameraPos.lat;
      longitude = lastCameraPos.lon;
      zoom = lastCameraPos.zoom;
    }

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: zoom,
        ),
      ),
    );
  }
}
