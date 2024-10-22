import 'package:app01/model/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user.dart';

const String TODO_COLLOECTION_REF = "todos";
const String USER_COLLECTION_REF = "users";


class DatabaseService{
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _todosRef;
  late final CollectionReference _usersRef;


  DatabaseService(){
    _usersRef = _firestore.collection(USER_COLLECTION_REF).withConverter<AppUser>(
      fromFirestore: (snapshot, _) => AppUser.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson(),
    );

  }
  Future<void> addUser(String id, AppUser user  ) async {
    await _usersRef.add(user);
  }
  Future<void> updateUser(String userId, AppUser user) async {
    await _usersRef.doc(userId).update(user.toJson());
  }
  Future<void> deleteUser(String userId) async {
    await _usersRef.doc(userId).delete();
  }

}