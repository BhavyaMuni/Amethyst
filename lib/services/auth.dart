import 'dart:async';
import 'dart:ffi';
import 'package:amethyst_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseAuth {
  Future<FirebaseUser> signIn(String email, String password);

  Future<FirebaseUser> signUp(
      String email, String password, String name, String bio);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<String> facebookSignIn();

  Future<FirebaseUser> googleSignIn();

  Future<void> resetPass(String email);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> googleSignIn() async {
    GoogleSignInAccount account = await _googleSignIn.signIn();
    GoogleSignInAuthentication auth = await account.authentication;

    AuthResult res = await _firebaseAuth.signInWithCredential(
        GoogleAuthProvider.getCredential(
            accessToken: auth.accessToken, idToken: auth.idToken));
    FirebaseUser user = res.user;
    // updateUserData(user);
    return user;
  }

  Future<String> facebookSignIn() async {
    return "";
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user;
  }

  Future<FirebaseUser> signUp(
      String email, String password, String name, String bio) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;

    FirebaseUser user2 = await signIn(email, password);
    DatabaseService dbService = DatabaseService();
    await dbService.createUser(user, name, bio);
    return user2;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<void> resetPass(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
