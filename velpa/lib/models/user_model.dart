import 'package:cloud_firestore/cloud_firestore.dart';

class UserRoles {
  final bool isAdmin;
  final bool isModerator;
  final bool isVerified;
  UserRoles({
    this.isAdmin = false,
    this.isModerator = false,
    this.isVerified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'admin': isAdmin,
      'moderator': isModerator,
      'verified': isVerified,
    };
  }

  factory UserRoles.fromMap(Map<String, dynamic> map) {
    return UserRoles(
      isAdmin: map['admin'] ?? false,
      isModerator: map['moderator'] ?? false,
      isVerified: map['verified'] ?? false,
    );
  }
}

class UserModel {
  final String uid;
  final String email;
  final String username;
  final UserRoles roles;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.roles,
    required this.createdAt,
  });

  // ... toMap and fromMap methods
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'roles': roles.toMap(),
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
      roles: UserRoles.fromMap(map['roles']),
      createdAt: (map['created_at'] as Timestamp).toDate(),
    );
  }
}
