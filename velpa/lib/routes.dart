import 'package:velpa/profile/profile_screen.dart';
import 'package:velpa/screens/markers_screen.dart';
import 'package:velpa/screens/mobile/settings_screen.dart';

var appRoutes = {
  "/markers": (context) => const MarkersScreen(),
  "/profile": (context) => const ProfileScreen(),
  "/settings": (context) => const SettingsScreen(),
};
