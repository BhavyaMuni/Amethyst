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
      body: listCards(user.uid, context),
    );
  }

  Widget listCards(String userUid, BuildContext ctx) {
    return StreamBuilder(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return Text("Found an error...");
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text("Loading...",
                style: TextStyles()
                    .regularTextStyle()
                    .copyWith(color: Colors.white, fontSize: 16)),
          );
        } else {
          return ListView.builder(
            itemBuilder: (ctx, val) {
              if (snapshot.data.documents[val]['uid'] == userUid)
                return Container();
              else
                return userContainer(
                    snapshot.data.documents[val]['displayName'],
                    snapshot.data.documents[val]['uid'],
                    snapshot.data.documents[val]['instrument'],
                    snapshot.data.documents[val]['genre'],
                    snapshot.data.documents[val]['photoUrl'],
                    snapshot.data.documents[val]['bio'],
                    ctx);
            },
            itemCount: snapshot.data.documents.length,
          );
        }
      },
    );
  }

  Widget userContainer(String name, String uid, String instru, String genre,
      String photoUrl, String bio, BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20),
      child: GestureDetector(
        onTap: () => Navigator.push(
            ctx, MaterialPageRoute(builder: (ctx) => ChatWindow(toUid: uid))),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Color(0x24ffffff),
                      backgroundImage: photoUrl != "" && photoUrl != null
                          ? NetworkImage(photoUrl)
                          : null,
                      radius: 60,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    name,
                    style:
                        TextStyles().headerTextStyle().copyWith(fontSize: 28),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    height: 90,
                    child: Text(
                      bio != null ? bio : "",
                      style: TextStyles()
                          .regularTextStyle()
                          .copyWith(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text("Genres",
                              style: TextStyles()
                                  .headerTextStyle()
                                  .copyWith(fontSize: 20)),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: listGenre(genre.split(", ")),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text("Instruments",
                              style: TextStyles()
                                  .headerTextStyle()
                                  .copyWith(fontSize: 20)),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: listInstru(instru.split(", ")),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listInstru(List instru) {
    return Container(
      height: 100,
      child: Center(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: instru.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(
                  child: Text(instru[index],
                      textAlign: TextAlign.center,
                      style: TextStyles()
                          .regularTextStyle()
                          .copyWith(color: Colors.white, fontSize: 14))),
            );
          },
        ),
      ),
    );
  }

  Widget listGenre(List genre) {
    return Container(
      height: 100,
      child: Center(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: genre.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(
                  child: Text(genre[index],
                      textAlign: TextAlign.center,
                      style: TextStyles()
                          .regularTextStyle()
                          .copyWith(color: Colors.white, fontSize: 14))),
            );
          },
        ),
      ),
    );
  }
}
