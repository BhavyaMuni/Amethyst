import 'package:amethyst_app/services/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key key, this.toUid}) : super(key: key);
  final String toUid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChatWindow(
      toUid: toUid,
    ));
  }
}

class ChatWindow extends StatefulWidget {
  ChatWindow({Key key, this.toUid}) : super(key: key);
  final String toUid;
  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  String message;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Form(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            onSaved: (val) => message = val,
          ),
          FlatButton(
            child: Text("Submit"),
            onPressed: () {
              Chat(
                      message: "Hello, world!",
                      userUid: user.uid,
                      fromUid: widget.toUid)
                  .createChat();
            },
          ),
        ],
      ),
    ));
  }
}
