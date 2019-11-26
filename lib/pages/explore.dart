import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key key}) : super(key: key);

  final baseTextStyle = const TextStyle(fontFamily: 'AvenirLTStd');

  LinearGradient baseGrad() {
    return LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      stops: [0.2, 0.9],
      colors: <Color>[Color(0xffB339F6), Color(0xff32D5EB)],
    );
  }

  TextStyle headerTextStyle() {
    return baseTextStyle.copyWith(
        color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600);
  }

  TextStyle smallheaderTextStyle() {
    return baseTextStyle.copyWith(
        color: Color(0xffb339f6), fontSize: 12.0, fontWeight: FontWeight.w600);
  }

  TextStyle regularTextStyle() {
    return baseTextStyle.copyWith(
        color: Color(0xff000000), fontSize: 9.0, fontWeight: FontWeight.w400);
  }

  TextStyle subheaderTextStyle() {
    return baseTextStyle.copyWith(
        color: Color(0xffb339f6), fontSize: 12.0, fontWeight: FontWeight.w400);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listCards(),
    );
  }

  Widget listCards() {
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
              return userRow(
                  snapshot.data.documents[val]['displayName'],
                  snapshot.data.documents[val]['instrument'],
                  snapshot.data.documents[val]['photoUrl']);
            },
            itemCount: snapshot.data.documents.length,
          );
        }
      },
    );
  }

  Widget cardsUser(String displyName, String instrument) {
    return Container(
      margin: EdgeInsets.only(left: 46.0),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15.0)),
      child: cardContent(displyName, instrument),
    );
  }

  Widget avatarUser(String photoUrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10),
      child: CircleAvatar(
        radius: 46.0,
        backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
      ),
    );
  }

  Widget userRow(String displayName, String instrument, String photoUrl) {
    return Container(
      height: 210,
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Stack(
        children: <Widget>[
          cardsUser(displayName, instrument),
          avatarUser(photoUrl)
        ],
      ),
    );
  }

  Widget cardContent(String displayName, String instrument) {
    return Container(
      margin: EdgeInsets.fromLTRB(76, 16, 16, 16),
      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 4.0,
          ),
          GradientText(
            "$displayName",
            gradient: baseGrad(),
            style: headerTextStyle(),
          ),
          Container(
            height: 4.0,
          ),
          Text(
            "Mumbai, India",
            style: subheaderTextStyle(),
          ),
          Container(
            height: 4,
          ),
          Text(
            "Hello, I'm John Doe a musician. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
            style: regularTextStyle(),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            height: 4.0,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Color(0xff32D5EB)),
          ),
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Favourite instrument: ",
                    style: subheaderTextStyle(),
                  ),
                  Text(
                    "$instrument",
                    style: smallheaderTextStyle(),
                  ),
                ],
              ),
              Container(width: 10),
              FlatButton(
                onPressed: () {},
                color: Color(0x00ffffff),
                child: Text(
                  "Start Talking!",
                  style:
                      smallheaderTextStyle().copyWith(color: Color(0xff32d5eb)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
