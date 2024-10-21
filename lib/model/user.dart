import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String userId;
  String name;
  String email;
  Timestamp createdOn;

  AppUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.createdOn,
  });

  // From Firestore JSON to User object
  AppUser.fromJson(Map<String, Object?> json)
      : this(
    userId: json['userId'] as String? ?? 'Unknown userId',
    name: json['name'] as String? ?? 'Unnamed User',
    email: json['email'] as String? ?? 'No Email',
    createdOn: json['createdOn'] as Timestamp? ?? Timestamp.now(),
  );

  // From User object to Firestore JSON
  Map<String, Object> toJson() {
    return {
      'userId':userId,
      'name': name,
      'email': email,
      'createdOn': createdOn,
    };
  }

  // Copy method to easily update fields
  AppUser copyWith({
    String? userId,
    String? name,
    String? email,
    Timestamp? createdOn,
  }) {
    return AppUser(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      createdOn: createdOn ?? this.createdOn,
    );
  }
}
