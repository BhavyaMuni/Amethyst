import 'package:amethyst_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  final _db = Firestore.instance;

  Stream<List<User>> getAllUsers() {
    var ref = _db.collection('users');
    return ref.snapshots().map(
        (list) => list.documents.map((e) => User.fromFirestore(e)).toList());
  }

  Future<User> getUser(String uid) async {
    var doc = await _db.collection('users').document(uid).get();
    return User.fromFirestore(doc);
  }

  Stream<User> streamUser(String uid) {
    var snap = _db.collection('users').document(uid).snapshots();
    return snap.map((user) => User.fromFirestore(user));
  }

  List<String> getSortedUserList(User user, List<User> users) {
    Map<String, int> userSameDict = {};
    List combineListUser;
    String currUid;
    try {
      combineListUser = user.instruments + user.genres;
      currUid = user.uid;
    } catch (e) {
      combineListUser = [];
      currUid = '';
    }
    // List combineListUser = user.instruments + user.genres;
    for (var i in users) {
      if (i.uid == currUid) continue;
      String userUid = i.uid;
      List combineList = i.instruments + i.genres;
      int numsame = numOfSameElements(combineList, combineListUser);

      userSameDict[userUid] = numsame;
    }
    var sortedDict = userSameDict.keys.toList(growable: false)
      ..sort((k1, k2) => userSameDict[k1].compareTo(userSameDict[k2]));

    List<String> userUidsSorted = sortedDict.reversed.toList();

    return userUidsSorted;
  }

  Future<void> createUser(FirebaseUser user, String name, String bio) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoUrl': prefs.getString('photoUrl') ?? "",
      'bio': bio,
      'displayName': name ?? "",
      'lastSeen': DateTime.now(),
      'genre': prefs.getString('genres'),
      'instrument': prefs.getString('instruments')
    }, merge: true);
  }

  int numOfSameElements(List list1, List list2) {
    int numSame = 0;
    for (String i in list1) {
      for (String j in list2) {
        if (i == j) {
          numSame += 1;
        }
      }
    }

    return numSame;
  }
}
