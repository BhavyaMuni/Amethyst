import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  Chat({this.message, this.userUid, this.fromUid});

  String message;
  String userUid;
  String fromUid;

  void createChat() async {
    Firestore f = Firestore.instance;
    DocumentReference ref = f
        .collection("chats")
        .document(userUid)
        .collection("messages")
        .document(fromUid);
    await ref.setData({
      "messages": FieldValue.arrayUnion([
        {"messages": message, "createdAt": DateTime.now()}
      ]),
    }, merge: true);
  }
}
