import 'package:amethyst_app/services/auth.dart';
import 'package:amethyst_app/services/database.dart';
import 'package:amethyst_app/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Profile(
        auth: Auth(),
      ),
    );
  }
}

class Profile extends StatefulWidget {
  Profile({Key key, this.auth}) : super(key: key);

  final BaseAuth auth;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = new GlobalKey<FormState>();

  bool isLoading = false;
  String _errorMessage;

  String _name;
  String _bio;

  @override
  void initState() {
    _errorMessage = "";
    isLoading = false;
    super.initState();
  }

  Widget loading() {
    return isLoading == true
        ? Center(child: CircularProgressIndicator())
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Form(
                key: _formKey,
                child: Stack(
                  children: <Widget>[
                    ListView(children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: FlatButton(
                              onPressed: () =>
                                  showLogoutDialog(context, widget.auth),
                              child: Icon(MdiIcons.logoutVariant),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 40),
                            child: Center(
                              child: ImageSelect(
                                imUrl: snapshot.data["photoUrl"],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 40),
                            child: Text(
                              "Name: ",
                              style: TextStyles()
                                  .headerTextStyle()
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Container(
                              margin: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.0),
                                  color: Color(0x44000000)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: TextFormField(
                                  initialValue: snapshot.data["displayName"],
                                  validator: (val) => val.isEmpty
                                      ? "Name can\'t be empty"
                                      : null,
                                  onSaved: (val) => _name = val.trim(),
                                  textAlign: TextAlign.left,
                                  style: TextStyles()
                                      .regularTextStyle()
                                      .copyWith(
                                          color: Colors.white, fontSize: 14),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Your name"),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 40),
                            child: Text(
                              "Bio: ",
                              style: TextStyles()
                                  .headerTextStyle()
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Container(
                              margin: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.0),
                                  color: Color(0x44000000)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 4.0),
                                child: TextFormField(
                                  maxLines: 7,
                                  initialValue: snapshot.data["bio"],
                                  validator: (val) => val.isEmpty
                                      ? "Bio can\'t be empty"
                                      : null,
                                  onSaved: (val) => _bio = val.trim(),
                                  textAlign: TextAlign.left,
                                  style: TextStyles()
                                      .regularTextStyle()
                                      .copyWith(
                                          color: Colors.white, fontSize: 14),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Something about you"),
                                ),
                              ),
                            ),
                          ),
                          Text(_errorMessage.toString()),
                        ],
                      ),
                      GradientButton(
                        increaseHeightBy: 20,
                        increaseWidthBy: 80,
                        callback: () => validateAndSubmit(user.uid),
                        gradient: TextStyles().baseGrad(),
                        child: Text(
                          "Save Changes",
                          style: TextStyles().headerTextStyle(),
                        ),
                      ),
                    ]),
                    loading()
                  ],
                ),
              ),
            );
          }
        });
  }

  void showLogoutDialog(BuildContext context, BaseAuth auth) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(
              "Logout",
              style: TextStyles().headerTextStyle(),
            ),
            content: Text(
              "Are you sure you want to logout?",
              style: TextStyles()
                  .regularTextStyle()
                  .copyWith(color: Colors.white, fontSize: 16),
            ),
            actions: <Widget>[
              GradientButton(
                gradient: TextStyles().baseGrad(),
                child: Text("Cancel"),
                callback: () => Navigator.pop(context),
              ),
              GradientButton(
                gradient: TextStyles().baseGrad(),
                callback: () {
                  auth.signOut();
                  Navigator.pop(context);
                },
                child: Text("Confirm"),
              )
            ],
          );
        });
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit(String userUid) async {
    setState(() {
      _errorMessage = "";
      isLoading = true;
    });
    if (validateAndSave()) {
      try {
        Firestore.instance
            .collection("users")
            .document(userUid)
            .updateData({"displayName": _name, "bio": _bio});
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }
}
