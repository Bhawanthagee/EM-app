import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String name;
  String email;
  Timestamp createdOn;

  AppUser({
    required this.name,
    required this.email,
    required this.createdOn,
  });

  // From Firestore JSON to User object
  AppUser.fromJson(Map<String, Object?> json)
      : this(
    name: json['name'] as String? ?? 'Unnamed User', // Provide a default
    email: json['email'] as String? ?? 'No Email',    // Default value
    createdOn: json['createdOn'] as Timestamp? ?? Timestamp.now(),
  );

  // From User object to Firestore JSON
  Map<String, Object> toJson() {
    return {
      'name': name,
      'email': email,
      'createdOn': createdOn,
    };
  }

  // Copy method to easily update fields
  AppUser copyWith({
    String? name,
    String? email,
    Timestamp? createdOn,
  }) {
    return AppUser(
      name: name ?? this.name,
      email: email ?? this.email,
      createdOn: createdOn ?? this.createdOn,
    );
  }
}
