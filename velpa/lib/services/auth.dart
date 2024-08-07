import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:velpa/models/local_models.dart';

class AuthService {
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      // handle error
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
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(authCredential);
    } on FirebaseAuthException catch (e) {
      // handle error
    }
  }

  // Rekisteröi uusi käyttäjä
  Future<void> emailRegister(String email, String password) async {
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
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
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
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }
}
