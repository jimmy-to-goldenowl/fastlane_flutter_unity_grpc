import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LUser extends Equatable {
  final String id;
  final String? photoURL;
  final String? phoneNumber;
  final String? displayName;
  final String? email;
  const LUser({
    required this.id,
    this.photoURL,
    this.phoneNumber,
    this.displayName,
    this.email,
  });

  factory LUser.fromDocument(DocumentSnapshot doc) {
    return LUser.fromMap(doc.data() as Map<String, dynamic>, docId: doc.id);
  }
  factory LUser.fromUserCredential(User user) {
    return LUser(
      id: user.uid,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
      email: user.email,
      displayName: user.displayName,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      if (photoURL != null) 'photoURL': photoURL,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (displayName != null) 'displayName': displayName,
      if (email != null) 'email': email,
    };
  }

  factory LUser.fromMap(Map<String, dynamic> map, {String? docId}) {
    return LUser(
      id: docId ?? map['uid'] as String,
      photoURL: map['photoURL'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      displayName: map['displayName'] as String?,
      email: map['email'] as String?,
    );
  }

  /// Empty user which represents an unauthenticated user.
  static const empty = LUser(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == LUser.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != LUser.empty;
  @override
  List<Object?> get props => [id];

  LUser copyWith({
    String? id,
    String? photoURL,
    String? phoneNumber,
    String? displayName,
    String? email,
  }) {
    return LUser(
      id: id ?? this.id,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
    );
  }
}
