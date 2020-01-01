import 'dart:async';
import 'dart:ffi';
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
  final _db = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> googleSignIn() async {
    GoogleSignInAccount account = await _googleSignIn.signIn();
    GoogleSignInAuthentication auth = await account.authentication;

    AuthResult res = await _firebaseAuth.signInWithCredential(
        GoogleAuthProvider.getCredential(
            accessToken: auth.accessToken, idToken: auth.idToken));
    FirebaseUser user = res.user;
    updateUserData(user);
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

    DocumentReference ref = _db.collection('users').document(user.uid);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoUrl': prefs.getString('photoUrl') ?? "",
      'bio': bio,
      'displayName': name ?? "",
      'lastSeen': DateTime.now(),
      'genre': prefs.getStringList('genres').join(", "),
      'instrument': prefs.getString('instrument')
    }, merge: true);
    return user2;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoUrl': user.photoUrl ?? "",
      'displayName': user.displayName ?? "",
      'lastSeen': DateTime.now(),
      'genre': "",
      'instrument': "",
    }, merge: true);
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
