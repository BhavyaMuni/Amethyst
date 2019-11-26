import 'dart:ffi';

import 'package:amethyst_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseDB {
  Future<void> nameUpdate(String newName, FirebaseUser user);
  Future<void> genreUpdate(String genre, FirebaseUser user);
  Future<void> instrumentUpdate(String newEmail, FirebaseUser user);
}

class DB implements BaseDB {
  Future<void> nameUpdate(String newName, FirebaseUser user) async {
    DocumentReference ref =
        Firestore.instance.collection("users").document(user.uid);
    try {
      await ref.updateData({'displayName': newName});
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> genreUpdate(String genre, FirebaseUser user) async {
    DocumentReference ref =
        Firestore.instance.collection("users").document(user.uid);
    try {
      await ref.updateData({"genre": genre});
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> instrumentUpdate(String instrument, FirebaseUser user) async {
    DocumentReference ref =
        Firestore.instance.collection("users").document(user.uid);
    try {
      await ref.updateData({"instrument": instrument});
    } catch (e) {
      print("Error: $e");
    }
  }
}
