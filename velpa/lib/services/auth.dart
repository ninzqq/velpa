import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:velpa/models/local_models.dart';
import 'package:velpa/utils/snackbar.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  var logger = Logger();

  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
    }
  }

  Future<void> signOut(WidgetRef ref) async {
    //final googleCurrentUser =
    //    GoogleSignIn().currentUser ?? await GoogleSignIn().signIn();
    //if (googleCurrentUser != null) {
    //  await GoogleSignIn().disconnect().catchError((e, stack) {
    //    // Handle error
    //  });
    //}
    await FirebaseAuth.instance.signOut();
    ref.read(userStateProvider).logout();
  }

  Future<void> googleLogin() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'profile',
        ],
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

        await FirebaseAuth.instance.signInWithCredential(credential);

        var user = FirebaseAuth.instance.currentUser;

        await firestore.collection('users').doc(user!.uid).set({
          'username': user.email?.split('@')[0],
          'email': user.email,
          'isVerified': false,
          'created_at': FieldValue.serverTimestamp(),
        });
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

      User user = userCredential.user!;
      // Lisää käyttäjän tiedot Firestoreen
      await firestore.collection('users').doc(user.uid).set({
        'username': email.split('@')[0],
        'email': email,
        'isVerified': false,
        'created_at': FieldValue.serverTimestamp(),
      });
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
      ref.read(userStateProvider).login();
    } on FirebaseAuthException catch (e) {
      logger.e('Failed with error code: ${e.code}');
      logger.e(e.message);
      showSnackBar(e.message!, const Icon(Icons.error));
    }
  }
}
