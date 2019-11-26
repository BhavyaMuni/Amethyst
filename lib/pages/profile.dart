import 'package:amethyst_app/services/auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.auth}) : super(key: key);

  final BaseAuth auth;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        child: FlatButton(
          child: Text("Logout"),
          onPressed: () async {
            await widget.auth.signOut();
          },
        ),
      )),
    );
  }
}
