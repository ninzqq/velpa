import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  ref.onDispose(() {
    notifier._userSubscription?.cancel();
  });
  return notifier;
});

class CurrentUserNotifier extends StateNotifier<UserModel?> {
  bool _isLoading = false;
  String? _lastLoadedUid;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  CurrentUserNotifier() : super(null) {
    // Initial load
    initializeUser();
  }

  final UserService _userService = UserService();
  final Logger _logger = Logger();

  Future<void> initializeUser() async {
    final currentUser = AuthService().user;
    if (currentUser != null) {
      await listenToUserChanges(currentUser.uid);
    }
  }

  Future<void> listenToUserChanges(String uid) async {
    if (!mounted) return;

    // Cancel any existing subscription
    await _userSubscription?.cancel();
    _userSubscription = null;
    _lastLoadedUid = uid;

    try {
      _userSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots()
          .listen((snapshot) {
        if (!mounted) return;

        if (snapshot.exists) {
          final userData = snapshot.data() as Map<String, dynamic>;
          // Varmista että kaikki tarvittavat kentät ovat mukana
          userData['uid'] = uid;
          // Varmista että roles-objekti on oikein muodostettu
          final roles = userData['roles'] as Map<String, dynamic>? ??
              {'admin': false, 'moderator': false, 'verified': false};

          userData['roles'] = roles;
          state = UserModel.fromMap(userData);
          _logger.d('User data updated: ${state?.toMap()}');
          _logger.d('User roles: ${state?.roles.toMap()}');
        } else {
          state = null;
          _logger.w('User document does not exist');
        }
      });

      _userSubscription?.onError((error) {
        if (error is FirebaseException &&
            error.code == 'permission-denied' &&
            AuthService().user == null) {
          // Uloskirjautumiseen liittyvä odotettavissa oleva virhe
          _logger.d('User subscription ended due to logout');
        } else {
          _logger.e('Error in user subscription: $error');
          _userSubscription?.cancel();
          _userSubscription = null;
          state = null;
        }
      });
    } catch (e) {
      _logger.e('Error setting up user listener: $e');
      if (mounted) {
        _userSubscription = null;
        state = null;
      }
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
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

  Future<void> clearUser() async {
    if (!mounted) return;

    try {
      // Peruuta kuuntelija ja odota sen valmistumista
      if (_userSubscription != null) {
        await _userSubscription!.cancel();
        _userSubscription = null;
      }

      // Nollaa muut tilat vain jos notifier on vielä elossa
      if (mounted) {
        _lastLoadedUid = null;
        state = null;
      }
    } catch (e) {
      _logger.e('Error clearing user: $e');
    }
  }
}
