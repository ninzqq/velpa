import 'package:flutter/material.dart';
import 'package:velpa/profile/userloginstatuscheck.dart';
import 'package:velpa/screens/mobile/markers_screen.dart';
import 'package:velpa/screens/mobile/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:velpa/settings/settings_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:velpa/settings/settings_view.dart';

class Velpa extends StatelessWidget {
  static final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Velpa({super.key, required this.settingsController});

  final SettingsController settingsController;
  final Future<FirebaseApp> initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
        listenable: settingsController,
        builder: (BuildContext context, Widget? child) {
          return FutureBuilder(
              future: initialization,
              builder: (context, snapshot) {
                // Check for errors
                if (snapshot.hasError) {
                  return const Text('error');
                }

                // Once completed, show application
                if (snapshot.connectionState == ConnectionState.done) {
                  return MaterialApp(
                    scaffoldMessengerKey: rootScaffoldMessengerKey,
                    // Providing a restorationScopeId allows the Navigator built by the
                    // MaterialApp to restore the navigation stack when a user leaves and
                    // returns to the app after it has been killed while running in the
                    // background.
                    restorationScopeId: '/home',
                    // Provide the generated AppLocalizations to the MaterialApp. This
                    // allows descendant Widgets to display the correct translations
                    // depending on the user's locale.
                    localizationsDelegates: const [
                      //AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: const [
                      Locale('en', ''), // English, no country code
                    ],
                    // Define a light and dark color theme. Then, read the user's
                    // preferred ThemeMode (light, dark, or system default) from the
                    // SettingsController to display the correct theme.
                    theme: ThemeData(
                      textTheme: const TextTheme(
                        bodyMedium: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          decoration: TextDecoration.none,
                          decorationThickness: 0,
                        ),
                        labelMedium: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        labelLarge: TextStyle(
                          color: Colors.black87,
                          fontSize: 24,
                        ),
                        displayLarge: TextStyle(
                          color: Colors.black87,
                          fontSize: 44,
                        ),
                        displayMedium: TextStyle(
                          color: Colors.black87,
                          fontSize: 32,
                        ),
                        titleLarge: TextStyle(
                          color: Colors.black87,
                          fontSize: 24,
                        ),
                      ),
                      colorScheme: ColorScheme.fromSwatch().copyWith(
                        primary: Colors.cyan.shade500,
                        secondary: Colors.grey.shade300,
                        surface:
                            Colors.cyan.shade500, // background color "dark"
                        surfaceBright:
                            Colors.grey.shade200, // background color "light"
                        primaryFixed: Colors.black,
                        tertiary: Colors.black26,
                        secondaryFixedDim: Colors.grey.shade600,
                        secondaryContainer: Colors.blueGrey.shade300,
                        tertiaryContainer: Colors.cyan.shade100,
                      ),
                    ),
                    darkTheme: ThemeData(
                      textTheme: const TextTheme(
                        bodyMedium: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        labelMedium: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        labelLarge: TextStyle(
                          color: Colors.white70,
                          fontSize: 24,
                        ),
                        displayLarge: TextStyle(
                          color: Colors.white70,
                          fontSize: 44,
                        ),
                        displayMedium: TextStyle(
                          color: Colors.white70,
                          fontSize: 32,
                        ),
                        titleLarge: TextStyle(
                          color: Colors.white70,
                          fontSize: 24,
                        ),
                      ),
                      colorScheme: ColorScheme.fromSwatch().copyWith(
                        primary: const Color.fromARGB(255, 20, 25, 46),
                        secondary: const Color.fromARGB(255, 23, 60, 114),
                        surface: const Color.fromARGB(
                            255, 20, 25, 46), // background color "dark"
                        surfaceBright: const Color.fromARGB(
                            255, 40, 78, 136), // background color "light"
                        primaryFixed: Colors.white54,
                        tertiary: Colors.black26,
                        secondaryFixedDim: Colors.grey.shade600,
                        secondaryContainer: Colors.blueGrey.shade300,
                        tertiaryContainer: Colors.blueGrey.shade900,
                      ),
                    ),
                    themeMode: settingsController.themeMode,

                    // Define a function to handle named routes in order to support
                    // Flutter web url navigation and deep linking.
                    onGenerateRoute: (RouteSettings routeSettings) {
                      return MaterialPageRoute<void>(
                        settings: routeSettings,
                        builder: (BuildContext context) {
                          switch (routeSettings.name) {
                            case SettingsView.routeName:
                              return SettingsView(
                                  controller: settingsController);
                            case HomeScreen.routeName:
                              return const HomeScreen();
                            case MarkersScreen.routeName:
                              return const MarkersScreen();
                            case UserLogInStatusCheck.routeName:
                              return const UserLogInStatusCheck();
                            default:
                              return const HomeScreen();
                          }
                        },
                      );
                    },
                  );
                }

                // Otherwise, show something whilst waiting for initialization to complete
                return const Center(
                    child: Text('loading', textDirection: TextDirection.ltr));
              });
        });
  }
}
