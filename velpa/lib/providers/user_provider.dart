import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:velpa/models/user_model.dart';
import 'package:velpa/services/auth.dart';
import 'package:velpa/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, UserModel?>((ref) {
  // Initialize the notifier and load user if exists
  final notifier = CurrentUserNotifier();
  notifier.initializeUser();
  return notifier;
});

class CurrentUserNotifier extends StateNotifier<UserModel?> {
  CurrentUserNotifier() : super(null) {
    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        loadUser(firebaseUser.uid);
      } else {
        clearUser();
      }
    });
  }

  final UserService _userService = UserService();
  final Logger _logger = Logger();

  Future<void> initializeUser() async {
    final currentUid = AuthService().getCurrentUserId();
    if (currentUid != null) {
      await loadUser(currentUid);
    }
  }

  Future<void> loadUser(String uid) async {
    _logger.d('Loading user with uid: $uid');
    final user = await _userService.getUserModel(uid);
    _logger.d('Loaded user: ${user?.toMap()}');
    state = user;
  }

  bool hasPermission(String action) {
    if (state == null) return false;

    switch (action) {
      case 'verify_marker':
      case 'delete_marker':
        return state!.roles.isAdmin || state!.roles.isModerator;
      case 'manage_users':
        return state!.roles.isAdmin;
      default:
        return false;
    }
  }

  void clearUser() {
    state = null;
  }
}
