import 'package:amethyst_app/pages/chat.dart';
import 'package:amethyst_app/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: listCards("", context),
    );
  }

  Widget listCards(String userUid, BuildContext ctx) {
    return StreamBuilder(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Found an error...");
        }
        if (!snapshot.hasData) {
          return Text("Loading...");
        } else {
          return ListView.builder(
            itemBuilder: (context, val) {
              return userContainer(
                  snapshot.data.documents[val]['displayName'],
                  snapshot.data.documents[val]['uid'],
                  snapshot.data.documents[val]['instrument'],
                  snapshot.data.documents[val]['photoUrl'],
                  ctx);
            },
            itemCount: snapshot.data.documents.length,
          );
        }
      },
    );
  }

  Widget userContainer(String name, String uid, String instru, String photoUrl,
      BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20),
      child: GestureDetector(
        onTap: () => Navigator.push(
            ctx, MaterialPageRoute(builder: (ctx) => ChatPage(toUid: uid))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60.0),
              color: Color(0x0effffff)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(
                  child: CircleAvatar(
                    backgroundImage: photoUrl != "" && photoUrl != null
                        ? NetworkImage(photoUrl)
                        : null,
                    radius: 60,
                  ),
                ),
                Container(height: 30),
                Text(
                  "John Doe",
                  style: TextStyles().headerTextStyle().copyWith(fontSize: 28),
                ),
                Container(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      "assets/gradient_pin.png",
                      height: 30,
                      width: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Mumbai, India",
                        style: TextStyles()
                            .subheaderTextStyle()
                            .copyWith(color: Colors.white60, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Container(height: 30),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Risus at ultrices mi tempus imperdiet nulla malesuada pellentesque. Faucibus purus in massa tempor nec feugiat nisl.",
                  style: TextStyles()
                      .regularTextStyle()
                      .copyWith(color: Colors.white, fontSize: 16),
                ),
                Container(height: 30),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Genres",
                            style: TextStyles()
                                .headerTextStyle()
                                .copyWith(fontSize: 20),
                          ),
                          Container(height: 8),
                          Text(
                            "EDM",
                            style: TextStyles()
                                .regularTextStyle()
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                          Container(height: 8),
                          Text(
                            "Hip Hop",
                            style: TextStyles()
                                .regularTextStyle()
                                .copyWith(color: Colors.white, fontSize: 14),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Instruments",
                            style: TextStyles()
                                .headerTextStyle()
                                .copyWith(fontSize: 20),
                          ),
                          Container(height: 8),
                          Text(
                            "Cello",
                            style: TextStyles()
                                .regularTextStyle()
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                          Container(height: 8),
                          Text(
                            "Classical Guitar",
                            style: TextStyles()
                                .regularTextStyle()
                                .copyWith(color: Colors.white, fontSize: 14),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
