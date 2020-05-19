import 'package:amethyst_app/models/user_model.dart';
import 'package:amethyst_app/services/auth.dart';
import 'package:amethyst_app/services/database.dart';
import 'package:amethyst_app/services/image_storage.dart';
import 'package:amethyst_app/styles.dart';
import 'package:amethyst_app/widgets/form_field.dart';
import 'package:amethyst_app/widgets/list_preferences.dart';
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
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: StreamProvider.value(
        value: DatabaseService().streamUser(user.uid),
        child: Profile(
          auth: Auth(),
        ),
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
  final GlobalKey<ImageSelectState> _imKey = GlobalKey();
  final GlobalKey<ListGenresAndInstrumentsState> _listPrefKey = GlobalKey();
  bool isLoading = false;
  String _errorMessage;

  String _name;
  String _bio;
  List<String> genres;
  List<String> instruments;

  DatabaseService _databaseService = DatabaseService();

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

  nameCb(name) {
    _name = name;
  }

  bioCb(name) {
    _bio = name;
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return StreamBuilder(
        stream: _databaseService.streamUser(user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
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
                              key: _imKey,
                              imUrl: user.photoUrl ?? "",
                            ),
                          ),
                        ),
                        //
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 40),
                          child: FormTextField(
                            initVal: snapshot.data.name,
                            hintText: "Your name",
                            text: "Name",
                            cb: nameCb,
                          ),
                        ),
                        //
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 40),
                          child: FormTextField(
                            initVal: snapshot.data.bio,
                            hintText: "Something about you",
                            text: "Bio",
                            cb: bioCb,
                          ),
                        ),
                        ListGenresAndInstruments(
                          key: _listPrefKey,
                          editable: true,
                          instruments: snapshot.data.instruments,
                          genres: snapshot.data.genres,
                        ),
                        Text(_errorMessage.toString()),
                      ],
                    ),
                    GradientButton(
                      increaseHeightBy: 20,
                      increaseWidthBy: 80,
                      callback: () =>
                          validateAndSubmit(user.uid, snapshot.data),
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

  void validateAndSubmit(String userUid, User user) async {
    setState(() {
      _errorMessage = "";
      isLoading = true;
    });
    if (validateAndSave()) {
      try {
        if (_name != user.name ||
            _bio != user.bio ||
            _listPrefKey.currentState.instruments != user.instruments ||
            _listPrefKey.currentState.genres != user.genres)
          Firestore.instance.collection("users").document(userUid).updateData({
            "displayName": _name,
            "bio": _bio,
            "instrument": _listPrefKey.currentState.instruments.join(", "),
            "genre": _listPrefKey.currentState.genres.join(", ")
          });

        await _imKey.currentState.startUpload();
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
