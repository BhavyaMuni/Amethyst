import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String uid;
  final String bio;
  final String name;
  final String photoUrl;
  final List<String> instruments;
  final List<String> genres;

  User(
      {@required this.uid,
      this.bio,
      this.genres,
      this.instruments,
      this.name,
      this.photoUrl});

  factory User.fromFirestore(DocumentSnapshot doc) {
    dynamic data = doc.data;
    return User(
        uid: data['uid'],
        name: data['displayName'],
        bio: data['bio'] ?? '',
        instruments: data['instrument'].split(", ") ?? [],
        genres: data['genre'].split(", ") ?? [],
        photoUrl: data['photoUrl'] ?? '');
  }
}
