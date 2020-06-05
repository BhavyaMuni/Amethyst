import 'package:amethyst_app/pages/get_started.dart';
import 'package:amethyst_app/pages/home_page.dart';
import 'package:amethyst_app/pages/sign_up/location_page/location_page.dart';
import 'package:amethyst_app/pages/sign_up_sequence.dart';
import 'package:amethyst_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<FirebaseUser>.value(
              value: FirebaseAuth.instance.onAuthStateChanged),
          StreamProvider<List<User>>.value(
              value: DatabaseService().getAllUsers()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          routes: {
            "/root": (BuildContext context) => new RootPage(),
            "/register": (BuildContext context) => new SignUp(),
          },
          theme: ThemeData.dark().copyWith(
              textTheme:
                  Theme.of(context).textTheme.apply(fontFamily: 'Nunito')),
          home: new RootPage(),
        ));
  }
}

class RootPage extends StatelessWidget {
  const RootPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
    if (loggedIn) {
      return Scaffold(
        body: HomePage(),
      );
    } else {
      return Scaffold(
        body: GetStartedPage(),
      );
    }
  }
}
