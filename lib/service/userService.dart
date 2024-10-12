// service/user_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to get user data by userId
  Stream<AppUser?> getUserData(String userId) {
    return _firestore
        .collection('users') // Assuming you have a 'users' collection
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return AppUser.fromJson(snapshot.data()!);
      }
      return null; // Return null if the user doesn't exist
    });
  }

  // Method to update user data
  Future<void> updateUserData(AppUser user, String userId) async {
    try {
      await _firestore.collection('users').doc(userId).set(user.toJson());
    } catch (e) {
      print('Error updating user data: $e');
    }
  }
}
