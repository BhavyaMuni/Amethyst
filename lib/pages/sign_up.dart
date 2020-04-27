import 'dart:io';
import 'package:provider/provider.dart';
import 'package:amethyst_app/pages/log_in.dart';
import 'package:amethyst_app/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:amethyst_app/services/database.dart';
// import 'package:amethyst_app/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amethyst_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegisterForm(
        auth: new Auth(),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key, this.auth}) : super(key: key);
  final Auth auth;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = new GlobalKey<FormState>();

  final _imKey = GlobalKey<_ImageSelectState>();

  bool isLoading = false;
  String _errorMessage;

  String _name;
  String _email;
  String _password;
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
      child: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            ListView(
              primary: false,
              shrinkWrap: true,
              children: <Widget>[
                Center(
                  child: ImageSelect(key: _imKey),
                ),
                Container(
                  height: 30,
                ),
                Text(
                  "Name: ",
                  style: TextStyles()
                      .subheaderTextStyle()
                      .copyWith(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.left,
                ),
                Container(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: Color(0x44000000)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextFormField(
                      validator: (val) =>
                          val.isEmpty ? "Name can\'t be empty" : null,
                      onSaved: (val) => _name = val.trim(),
                      textAlign: TextAlign.left,
                      style: TextStyles()
                          .regularTextStyle()
                          .copyWith(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Your name"),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                ),
                Text(
                  "Bio: ",
                  style: TextStyles()
                      .subheaderTextStyle()
                      .copyWith(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.left,
                ),
                Container(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: Color(0x44000000)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    child: TextFormField(
                      onSaved: (val) => _bio = val.trim(),
                      minLines: 1,
                      maxLines: 4,
                      textAlign: TextAlign.left,
                      style: TextStyles()
                          .regularTextStyle()
                          .copyWith(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintMaxLines: 5,
                          hintText: "Something about you"),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                ),
                Text(
                  "Email: ",
                  style: TextStyles()
                      .subheaderTextStyle()
                      .copyWith(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.left,
                ),
                Container(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: Color(0x44000000)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextFormField(
                      validator: (val) =>
                          val.isEmpty ? "Email can\'t be empty" : null,
                      onSaved: (val) => _email = val.trim(),
                      textAlign: TextAlign.left,
                      style: TextStyles()
                          .regularTextStyle()
                          .copyWith(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Email address"),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                ),
                Text(
                  "Password: ",
                  style: TextStyles()
                      .subheaderTextStyle()
                      .copyWith(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.left,
                ),
                Container(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: Color(0x44000000),
                      borderRadius: BorderRadius.circular(40.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextFormField(
                      validator: (val) =>
                          val.isEmpty ? "Password can\'t be empty" : null,
                      onSaved: (val) => _password = val.trim(),
                      obscureText: true,
                      textAlign: TextAlign.left,
                      style: TextStyles()
                          .regularTextStyle()
                          .copyWith(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Password"),
                    ),
                  ),
                ),
                Container(
                  height: 20,
                ),
                (_errorMessage == null || _errorMessage == "")
                    ? Container()
                    : Center(
                        child: Text(
                        _errorMessage.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyles()
                            .regularTextStyle()
                            .copyWith(color: Colors.red),
                      )),
                Container(
                  height: 20,
                ),
                GradientButton(
                  increaseHeightBy: 25,
                  increaseWidthBy: 100,
                  gradient: TextStyles().baseGrad(),
                  callback: validateAndSubmit,
                  child: Text(
                    "Sign Up",
                    style: TextStyles().headerTextStyle(),
                  ),
                ),
                Container(
                  height: 20,
                ),
                Center(
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("/root", (route) => false);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new LoginForm()));
                      },
                      child: Text("Already have an account? Log in!",
                          style: TextStyles()
                              .regularTextStyle()
                              .copyWith(color: Colors.white, fontSize: 14))),
                ),
                // Center(
                //     child: Text("or connect with:",
                //         style: TextStyles()
                //             .regularTextStyle()
                //             .copyWith(color: Colors.white, fontSize: 14))),
                // Container(
                //   height: 10,
                // ),
                // Center(
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //       FlatButton.icon(
                //         label: Text(""),
                //         icon: Center(child: Icon(MdiIcons.google)),
                //         onPressed: () {},
                //         shape: CircleBorder(),
                //       ),
                //       FlatButton.icon(
                //         label: Text(""),
                //         icon: Center(child: Icon(MdiIcons.facebook)),
                //         onPressed: () {},
                //         shape: CircleBorder(),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 40,
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Text(
                        "By continuing you are agreeing to our Terms of Service and Privacy and Cookie Policy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400)),
                  ),
                ),
              ],
            ),
            loading(),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        userId = (await widget.auth.signUp(_email, _password, _name, _bio)).uid;
        print(await _imKey.currentState.startUpload(userId));
        //widget.auth.sendEmailVerification();
        //_showVerifyEmailSentDialog();
        print('Signed up user: $userId');

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
      Navigator.of(context).pushNamedAndRemoveUntil("/root", (route) => false);
    }
  }
}

class ImageSelect extends StatefulWidget {
  ImageSelect({Key key, this.imUrl}) : super(key: key);
  final String imUrl;

  @override
  _ImageSelectState createState() => _ImageSelectState();
}

class _ImageSelectState extends State<ImageSelect> {
  File _imageFile;
  bool _loading = false;

  StorageUploadTask _uploadTask;
  String downloadUrl;

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    if (selected != null) {
      setState(() {
        _imageFile = selected;
        _loading = false;
      });
    }
  }

  /// Starts an upload task
  Future<String> startUpload(String userUid) async {
    var user = Provider.of<FirebaseUser>(context, listen: false);

    /// Unique file name for the file
    final StorageReference _storage = FirebaseStorage.instance
        .ref()
        .child("profile_pictures/${DateTime.now()}-$userUid.png");

    if (_imageFile != null) {
      _uploadTask = _storage.putFile(_imageFile);
      print("uploading");
    } else {
      _loading = false;
      print("no file selected");
    }

    var _downloadUrl =
        (await (await _uploadTask.onComplete).ref.getDownloadURL()).toString();

    if (userUid != null && userUid != "") {
      Firestore.instance
          .collection("users")
          .document(userUid)
          .updateData({"photoUrl": _downloadUrl});
    }
    setState(() {
      _loading = false;
    });
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.photoUrl = _downloadUrl;
    await user.updateProfile(updateInfo).catchError(() {
      print("Error changing user profile");
    });

    return _downloadUrl;
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context, listen: false);

    return GestureDetector(
      onTap: () async {
        await _pickImage(ImageSource.gallery);
        // try {
        //   _startUpload(user.uid);
        // } catch (e) {
        //   _startUpload(null);
        // }
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Color(0x44000000),
            child: _imageFile == null
                ? Icon(MdiIcons.faceProfile, size: 40)
                : null,
            radius: 80,
            backgroundImage: _imageFile != null ? FileImage(_imageFile) : null,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: 50,
            height: 50,
            child: Icon(MdiIcons.camera),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: TextStyles().baseGrad(),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x44000000),
                      offset: Offset(10, 10),
                      blurRadius: 20,
                      spreadRadius: 5),
                ]),
          )
        ],
      ),
    );
  }
}
