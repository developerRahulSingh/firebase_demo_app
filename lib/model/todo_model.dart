import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String email;
  String username;

  UserData();

  UserData.fromMap(Map<String, dynamic> user) {
    email = user['email'];
    username = user['username'];
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
    };
  }
}

class Todo {
  String id;
  String description;

  Todo();

  Todo.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    description = data['description'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
    };
  }
}
