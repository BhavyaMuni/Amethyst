import 'package:amethyst_app/services/chat.dart';
import 'package:amethyst_app/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key key, this.toUid}) : super(key: key);
  final String toUid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ChatsList());
  }
}

class ChatsList extends StatelessWidget {
  const ChatsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return StreamBuilder(
      stream: Firestore.instance
          .collection('chats')
          .document(user.uid)
          .collection("messages")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Found an error...");
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return StreamBuilder(
            stream: Firestore.instance.collection('users').snapshots(),
            builder: (context, snapshot2) {
              return ListView.builder(
                itemBuilder: (context, val) {
                  DocumentSnapshot doc = snapshot.data.documents[val];
                  return StreamBuilder(
                    stream: Firestore.instance
                        .collection("users")
                        .document(doc.documentID)
                        .snapshots(),
                    builder: (context, snappy) {
                      if (!snappy.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(""),
                        );
                      } else {
                        return FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0x44000000),
                                            offset: Offset(10, 10),
                                            blurRadius: 20,
                                            spreadRadius: 5),
                                        BoxShadow(
                                            color: Color(0x0effffff),
                                            offset: Offset(-10, -10),
                                            blurRadius: 20,
                                            spreadRadius: 5)
                                      ],
                                      color: Color(0xff3b3b3b),
                                      borderRadius:
                                          BorderRadius.circular(40.0)),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: CircleAvatar(
                                            radius: 40,
                                            backgroundColor: Color(0x44000000),
                                            backgroundImage: snappy
                                                            .data["photoUrl"] !=
                                                        null &&
                                                    snappy.data["photoUrl"] !=
                                                        ""
                                                ? NetworkImage(
                                                    snappy.data["photoUrl"])
                                                : NetworkImage(""),
                                            child: snappy.data["photoUrl"] !=
                                                        null &&
                                                    snappy.data["photoUrl"] !=
                                                        ""
                                                ? null
                                                : Icon(MdiIcons.faceProfile)),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(snappy.data["displayName"],
                                              style: TextStyles()
                                                  .regularTextStyle()
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 16)),
                                          StreamBuilder(
                                              stream: Firestore.instance
                                                  .collection("chats")
                                                  .document(user.uid)
                                                  .collection("messages")
                                                  .document(snappy.data["uid"])
                                                  .snapshots(),
                                              builder: (context, snap) {
                                                if (!snap.hasData)
                                                  return Text("Loading...",
                                                      style: TextStyles()
                                                          .regularTextStyle()
                                                          .copyWith(
                                                              color: Colors
                                                                  .white54,
                                                              fontSize: 12));
                                                return Text(
                                                    snap.data["messages"][(snap
                                                            .data["messages"]
                                                            .length -
                                                        1)]["messages"],
                                                    maxLines: 1,
                                                    style: TextStyles()
                                                        .regularTextStyle()
                                                        .copyWith(
                                                            color:
                                                                Colors.white54,
                                                            fontSize: 12));
                                              })
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => ChatWindow(
                                          toUid: doc.documentID,
                                        ))));
                      }
                    },
                  );
                },
                itemCount: snapshot.data.documents.length,
              );
            },
          );
        }
      },
    );
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: GradientAppBar(
        gradient: TextStyles().baseGrad(),
        title: StreamBuilder(
          stream: Firestore.instance
              .collection("users")
              .document(widget.toUid)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData)
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: CircleAvatar(
                        backgroundColor: Color(0x44000000),
                        backgroundImage: snapshot.data["photoUrl"] != null &&
                                snapshot.data["photoUrl"] != ""
                            ? NetworkImage(snapshot.data["photoUrl"])
                            : NetworkImage(""),
                        child: snapshot.data["photoUrl"] != null &&
                                snapshot.data["photoUrl"] != ""
                            ? null
                            : Icon(MdiIcons.faceProfile)),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(
                        snapshot.data["displayName"],
                        style: TextStyles()
                            .headerTextStyle()
                            .copyWith(fontSize: 20),
                      ),
                    ),
                  )
                ],
              );
            else
              return Center(
                child: Text(
                  "Discover people and start chatting!",
                  textAlign: TextAlign.center,
                  style:
                      TextStyles().subheaderTextStyle().copyWith(fontSize: 30),
                ),
              );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Flexible(child: chats(widget.toUid, user.uid)),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0x44000000),
                                borderRadius: BorderRadius.circular(40)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 8),
                              child: new TextFormField(
                                minLines: 1,
                                maxLines: 4,
                                style: TextStyles().regularTextStyle().copyWith(
                                    color: Colors.white, fontSize: 16),
                                validator: (val) {
                                  if (val.isEmpty || val == "")
                                    return "";
                                  else
                                    return null;
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10)),
                                onSaved: (val) => message = val.trim(),
                              ),
                            ),
                          ),
                        ),
                        GradientButton(
                          increaseHeightBy: 20,
                          increaseWidthBy: 20,
                          gradient: TextStyles().baseGrad(),
                          shape: CircleBorder(),
                          child: Center(child: Icon(Icons.arrow_forward_ios)),
                          callback: () {
                            _formKey.currentState.validate();
                            _formKey.currentState.save();
                            _formKey.currentState.reset();
                            message.isNotEmpty
                                ? Chat(
                                        message: message,
                                        userUid: user.uid,
                                        fromUid: widget.toUid)
                                    .createChat()
                                : null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget chats(String toUid, String userUid) {
    final snap = Firestore.instance
        .collection("chats")
        .document(userUid)
        .collection("messages")
        .document(toUid)
        .get();
    if (snap != null)
      return StreamBuilder(
        stream: Firestore.instance
            .collection("chats")
            .document(userUid)
            .collection("messages")
            .document(toUid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.data == null) {
            return Center(
              child: Text("Start chatting!",
                  style: TextStyles()
                      .regularTextStyle()
                      .copyWith(color: Colors.white54, fontSize: 14)),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListView.builder(
                itemBuilder: (context, val) {
                  if (snapshot.data["messages"][val]["fromMsg"] != true) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Color(0x44000000)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                                snapshot.data["messages"][val]["messages"],
                                style: TextStyles().regularTextStyle().copyWith(
                                    color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Color(0x44000000)),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                    snapshot.data["messages"][val]["messages"],
                                    style: TextStyles()
                                        .regularTextStyle()
                                        .copyWith(
                                            color: Colors.white, fontSize: 16)),
                              ),
                            )));
                  }

                  // return Center(
                  //   child: Text("Start chatting!",
                  //       style: TextStyles()
                  //           .regularTextStyle()
                  //           .copyWith(color: Colors.white54, fontSize: 14)),
                  // );
                },
                itemCount: snapshot.data["messages"].length,
              ),
            );
          }
        },
      );
    else
      return Center(child: Text("Start Chatting!"));
  }
}
