import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference dbCollection =
  FirebaseFirestore.instance.collection('Users');
  Future postUserData(String email, String username) async {
    return await dbCollection.doc(uid).set({
      'email': email,
      'username': username,
    });
  }
}