import 'package:amethyst_app/pages/explore_page/widgets/explore_list_users.dart';
import 'package:amethyst_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
        body: StreamProvider.value(
      value: DatabaseService().streamUser(user.uid),
      child: ExploreListWidget(),
    ));
  }

  // Widget listCards(String userUid, BuildContext ctx) {
  //   return StreamBuilder(
  //     stream: Firestore.instance.collection('users').snapshots(),
  //     builder: (ctx, snapshot) {
  //       List<int> rand = new List<int>.generate(
  //           snapshot.data.documents.length, (int ind) => ind);

  //       rand.shuffle();
  //       if (snapshot.hasError) {
  //         return Text("Found an error...");
  //       }
  //       if (!snapshot.hasData) {
  //         return Center(
  //           child: Text("Loading...",
  //               style: TextStyles()
  //                   .regularTextStyle()
  //                   .copyWith(color: Colors.white, fontSize: 16)),
  //         );
  //       } else {
  //         return ListView.builder(
  //           itemBuilder: (ctx, val) {
  //             if (snapshot.data.documents[rand[val]]['uid'] == userUid)
  //               return Container();
  //             // else
  //             // return userContainer(snapshot.data.documents[rand[val]], ctx);
  //           },
  //           itemCount: snapshot.data.documents.length,
  //         );
  //       }
  //     },
  //   );
  // }

  // Widget listCards2(String userUid, BuildContext ctx) {
  //   return StreamBuilder(
  //     stream: Firestore.instance
  //         .collection('users')
  //         .where("genre", isGreaterThanOrEqualTo: "EDM")
  //         .where("genre", isLessThan: "EDM\uF7FF")
  //         .snapshots(),
  //     builder: (ctx, snapshot) {
  //       // List<int> rand = new List<int>.generate(
  //       //     snapshot.data.documents.length, (int ind) => ind);

  //       // rand.shuffle();
  //       if (snapshot.hasError) {
  //         return Text("Found an error...");
  //       }
  //       if (!snapshot.hasData) {
  //         return Center(
  //           child: Text("Loading...",
  //               style: TextStyles()
  //                   .regularTextStyle()
  //                   .copyWith(color: Colors.white, fontSize: 16)),
  //         );
  //       } else {
  //         return ListView.builder(
  //           itemBuilder: (ctx, val) {
  //             if (snapshot.data.documents[val]['uid'] == userUid)
  //               return Container();
  //             else
  //               return userContainer(
  //                   snapshot.data.documents[val]['displayName'],
  //                   snapshot.data.documents[val]['uid'],
  //                   snapshot.data.documents[val]['instrument'],
  //                   snapshot.data.documents[val]['genre'],
  //                   snapshot.data.documents[val]['photoUrl'],
  //                   snapshot.data.documents[val]['bio'],
  //                   ctx);
  //           },
  //           itemCount: snapshot.data.documents.length,
  //         );
  //       }
  //     },
  //   );
  // }

}
