import 'package:amethyst_app/pages/explore.dart';
import 'package:amethyst_app/pages/get_started.dart';
import 'package:amethyst_app/pages/home_page.dart';
import 'package:amethyst_app/pages/login_page.dart';
import 'package:amethyst_app/pages/sign_up.dart';
import 'package:amethyst_app/pages/sign_up_sequence.dart';
import 'package:amethyst_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<FirebaseUser>.value(
              value: FirebaseAuth.instance.onAuthStateChanged),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          routes: {
            "/root": (BuildContext context) => new RootPage(),
            "/register": (BuildContext context) => new SignUp(),
          },
          theme: ThemeData.dark().copyWith(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primaryColor: Color(0xffB339F6),
              textTheme:
                  Theme.of(context).textTheme.apply(fontFamily: 'AvenirLTStd')),
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
        body: HomePage(
          user: user,
          auth: new Auth(),
        ),
      );
    } else {
      return Scaffold(
        body: GetStartedPage(),
      );
    }
  }
}
