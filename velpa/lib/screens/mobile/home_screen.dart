import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:velpa/screens/mobile/osm_map_screen_mobile.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:velpa/screens/web/osm_map_screen_web.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? currentUser;
  StreamSubscription<User?>? _authStateSubscription;

  double? lat;
  double? lon;
  double? zoom;
  LocationData? locationData;

  @override
  void initState() {
    super.initState();
    // Use a StreamSubscription to manage the listener
    _authStateSubscription = auth.authStateChanges().listen((User? user) {
      if (mounted) {
        // Check if widget is still mounted before calling setState
        setState(() {
          currentUser = user;
        });
      }
    });
  }

  @override
  void dispose() {
    // Cancel the subscription when the widget is disposed
    _authStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();

    if (!kIsWeb) {
      // Mobile
      return const OSMMapScreenMobile();
    } else {
      // Web/browser
      return const Scaffold(
        body: OSMMapScreenWeb(),
      );
    }
  }

  Future getCurrentLocation() async {
    Location location = Location();
    locationData = await location.getLocation();
    lat = locationData?.latitude ?? 64.94; // Provide a default value if null
    lon = locationData?.longitude ?? 26.33; // Provide a default value if null
  }
}
