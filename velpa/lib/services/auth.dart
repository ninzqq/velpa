import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:velpa/models/user_model.dart';
import 'package:velpa/providers/app_state_provider.dart';
import 'package:velpa/providers/map_markers_provider.dart';
import 'package:velpa/providers/user_provider.dart';
import 'package:velpa/utils/snackbar.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  var logger = Logger();

  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> signOut(WidgetRef ref) async {
    try {
      // 1. Peruuta ensin Firestore-kuuntelijat
      final userNotifier = ref.read(currentUserProvider.notifier);
      await userNotifier.clearUser();

      // 2. Kirjaudu ulos Firebasesta
      await FirebaseAuth.instance.signOut();

      // 3. Nollaa muut providerit
      ref.invalidate(currentUserProvider);
      ref.invalidate(appStateProvider);
      ref.invalidate(mapMarkersProvider);
    } catch (e) {
      logger.e('Error during sign out: $e');
      rethrow;
    }
  }

  Future<void> googleLogin(WidgetRef ref) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      // First sign out to make sure we don't have any cached credentials
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in flow
        logger.i('Google Sign In was canceled by user');
        return;
      }

      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Store ref.read in a variable before async operations
        final userNotifier = ref.read(currentUserProvider.notifier);

        // Check if this is a new user
        final userDoc = await firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          // Create new UserModel for first-time users
          final user = UserModel(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email!,
            username: googleUser.displayName ??
                userCredential.user!.email!.split('@')[0],
            roles: UserRoles(), // Default roles
            createdAt: DateTime.now(),
          );

          await firestore.collection('users').doc(user.uid).set(user.toMap());
          await userNotifier.loadUser(userCredential.user!.uid);
        } else {
          await userNotifier.loadUser(userCredential.user!.uid);
        }
      } catch (e) {
        logger.e('Error during Google authentication: $e');
        showSnackBar(
          'Failed to authenticate with Google',
          const Icon(Icons.error, color: Colors.red),
        );
      }
    } on PlatformException catch (e) {
      logger.e(
          'Platform Exception during Google Sign In: ${e.code} - ${e.message}');
      showSnackBar(
        'Google Sign In failed: ${e.message}',
        const Icon(Icons.error, color: Colors.red),
      );
    } catch (e) {
      logger.e('Unexpected error during Google Sign In: $e');
      showSnackBar(
        'An unexpected error occurred',
        const Icon(Icons.error, color: Colors.red),
      );
    }
  }

  // Rekisteröi uusi käyttäjä
  Future<void> emailRegister(
      WidgetRef ref, String email, String password) async {
    bool registeredSuccessfully = false;
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create UserModel instance
      final user = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        username: email.split('@')[0],
        roles: UserRoles(), // Default roles (not admin)
        createdAt: DateTime.now(),
      );

      // Lisää käyttäjän tiedot Firestoreen
      await firestore.collection('users').doc(user.uid).set(user.toMap());
      registeredSuccessfully = true;
    } on FirebaseAuthException catch (e) {
      logger.e('Failed with error code: ${e.code}');
      logger.e(e.message);
    }
    if (registeredSuccessfully) {
      emailLogin(ref, email, password);
    }
  }

  // Kirjaudu sisään
  Future<void> emailLogin(WidgetRef ref, String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await ref
          .read(currentUserProvider.notifier)
          .loadUser(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      logger.e('Failed with error code: ${e.code}');
      logger.e(e.message);
      showSnackBar(e.message!, const Icon(Icons.error));
    }
  }
}
