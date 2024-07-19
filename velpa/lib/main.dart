import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:velpa/models/local_models.dart';
import 'package:velpa/models/models.dart';
import 'package:velpa/routes.dart';
//import 'package:velpa/screens/google_map_screen.dart';
import 'package:velpa/screens/markers_screen.dart';
import 'package:provider/provider.dart';
import 'package:velpa/screens/mobile/osm_map_screen_mobile.dart';
import 'package:velpa/widgets/bottomnavbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:velpa/widgets/drawer.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();

  runApp(Velpa());
}

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => UserProvider());
}

class Velpa extends StatelessWidget {
  Velpa({super.key});
  final Future<FirebaseApp> initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return const Text('error');
          }

          // Once completed, show application
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => UserProvider(),
                ),
                ChangeNotifierProvider(
                  create: (context) => BottomNavBarIndex(),
                ),
                ChangeNotifierProvider(
                  create: (context) => MapsLastCameraPosition(
                      lat: 64.94, lon: 26.33, zoom: 15.0),
                ),
                ChangeNotifierProvider(
                  create: (context) => MapMarkers(),
                ),
                ChangeNotifierProvider(
                  create: (context) => AppFlags(),
                ),
                ChangeNotifierProvider(
                  create: (context) => TemporaryMarker(),
                ),
              ],
              child: MaterialApp(
                home: const HomeScreen(),
                routes: appRoutes,
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
              ),
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return const Center(
              child: Text('loading', textDirection: TextDirection.ltr));
        });
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? currentUser;

  final List<Widget> screens = [
    const OSMMapScreen(),
    const OtherMarkersScreen(),
  ];
  double? lat;
  double? lon;
  double? zoom;
  LocationData? locationData;

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((User? user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    //var bottomnavbarindex =
    //    Provider.of<BottomNavBarIndex>(context, listen: true);

    if (!kIsWeb) {
      // Mobile
      return const SafeArea(
        child: Scaffold(
          body: Center(
            child: OSMMapScreen(),
          ),
          drawer: MainDrawer(),
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
