import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:velpa/local_models/local_models.dart';
import 'package:velpa/local_models/models.dart';
import 'package:velpa/screens/mapscreen.dart';
import 'package:velpa/screens/markersscreen.dart';
import 'package:provider/provider.dart';
import 'package:velpa/widgets/bottomnavbar.dart';

void main() => runApp(Velpa());

class Velpa extends StatelessWidget {
  Velpa({super.key});

  double? lat;
  double? lon;
  double? zoom;
  LocationData? locationData;

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    if (lat == null || lon == null) {
      return const Center(
          child: Text('loading', textDirection: TextDirection.ltr));
    } else {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => BottomNavBarIndex(),
          ),
          ChangeNotifierProvider(
            create: (context) => MapsLastCameraPosition(
                lat: lat ?? 0.0, lon: lon ?? 0.0, zoom: zoom ?? 15.0),
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

  Future getCurrentLocation() async {
    Location location = Location();
    locationData = await location.getLocation();
    lat = locationData?.latitude ?? 0.0; // Provide a default value if null
    lon = locationData?.longitude ?? 0.0; // Provide a default value if null
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> screens = [
    const MapScreen(),
    const OtherMarkersScreen(),
    // Lisää tähän lisää sivuja tarvittaessa
  ];

  @override
  Widget build(BuildContext context) {
    print('REBUILT HOMESCREENSTATE');
    var bottomnavbarindex =
        Provider.of<BottomNavBarIndex>(context, listen: true);

    return Scaffold(
      body: screens[bottomnavbarindex.idx],
      bottomNavigationBar: BottomNavBar(
        bottomnavbarindex: bottomnavbarindex,
      ),
    );
  }
}
