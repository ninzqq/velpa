import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  Future<bool> checkUserPermissions(String action) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return false;

      final userData = doc.data()!;
      final roles = userData['roles'] ?? {'admin': false, 'moderator': false};

      switch (action) {
        case 'verify_marker':
        case 'delete_marker':
          return roles['admin'] == true || roles['moderator'] == true;
        case 'manage_users':
          return roles['admin'] == true;
        default:
          return false;
      }
    } catch (e) {
      _logger.e('Error checking permissions: $e');
      return false;
    }
  }

  Future<void> verifyMarker(String markerId) async {
    if (!await checkUserPermissions('verify_marker')) {
      throw UnauthorizedException('Insufficient permissions to verify markers');
    }

    try {
      await _firestore.runTransaction((transaction) async {
        final markerRef =
            _firestore.collection('unverifiedMarkers').doc(markerId);
        final markerDoc = await transaction.get(markerRef);

        if (!markerDoc.exists) {
          throw Exception('Marker not found');
        }

        final markerData = markerDoc.data()!;

        // Move to verified markers collection
        transaction.set(
          _firestore.collection('verifiedMarkers').doc(markerId),
          {...markerData, 'verifiedAt': FieldValue.serverTimestamp()},
        );

        // Delete from unverified collection
        transaction.delete(markerRef);
      });
    } catch (e) {
      _logger.e('Error verifying marker: $e');
      rethrow;
    }
  }
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}
