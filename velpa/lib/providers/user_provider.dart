import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:velpa/models/user_model.dart';
import 'package:velpa/services/auth.dart';
import 'package:velpa/services/user_service.dart';

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, UserModel?>((ref) {
  // Initialize the notifier and load user if exists
  final notifier = CurrentUserNotifier();
  notifier.initializeUser();
  return notifier;
});

class CurrentUserNotifier extends StateNotifier<UserModel?> {
  bool _isLoading = false;
  String? _lastLoadedUid;

  CurrentUserNotifier() : super(null) {
    // Initial load
    initializeUser();
  }

  final UserService _userService = UserService();
  final Logger _logger = Logger();

  Future<void> initializeUser() async {
    final currentUid = AuthService().user;
    if (currentUid != null) {
      await loadUser(currentUid.uid);
    }
  }

  Future<void> loadUser(String uid) async {
    // Skip if already loading or if we already loaded this uid
    if (_isLoading || uid == _lastLoadedUid) return;

    _isLoading = true;
    try {
      final user = await _userService.getUserModel(uid);
      _logger.d('Loaded user: ${user?.toMap()}');
      if (user != null) {
        state = user;
        _lastLoadedUid = uid;
      }
    } catch (e) {
      _logger.e('Error loading user: $e');
    } finally {
      _isLoading = false;
    }
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
    _lastLoadedUid = null;
  }
}
