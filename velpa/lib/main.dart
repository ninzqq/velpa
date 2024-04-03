import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:velpa/models/local_models.dart';
import 'package:velpa/models/models.dart';
//import 'package:velpa/screens/google_map_screen.dart';
import 'package:velpa/screens/markers_screen.dart';
import 'package:provider/provider.dart';
import 'package:velpa/screens/osm_map_screen.dart';
import 'package:velpa/widgets/bottomnavbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Velpa());
}

class Velpa extends StatelessWidget {
  const Velpa({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BottomNavBarIndex(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              MapsLastCameraPosition(lat: 64.94, lon: 26.33, zoom: 15.0),
        ),
        ChangeNotifierProvider(
          create: (context) => UserMarkers(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppFlags(),
        ),
        ChangeNotifierProvider(
          create: (context) => TemporaryMarker(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
              labelMedium: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(239, 0, 23, 39),
              ),
              bodyMedium: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(240, 0, 29, 29),
              ),
              bodyLarge: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(239, 200, 255, 255),
              ),
            )),
        title: 'Velpa',
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<Widget> screens = [
    const OSMMapScreen(),
    const OtherMarkersScreen(),
  ];
  double? lat;
  double? lon;
  double? zoom;
  LocationData? locationData;

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    var bottomnavbarindex =
        Provider.of<BottomNavBarIndex>(context, listen: true);

    if (!kIsWeb) {
      // Mobile
      return Scaffold(
        body: screens[bottomnavbarindex.idx],
        bottomNavigationBar: BottomNavBar(
          bottomnavbarindex: bottomnavbarindex,
        ),
      );
    } else {
      // Web/browser
      return const Scaffold(
        body: OSMMapScreen(),
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
