import 'package:amethyst_app/services/auth.dart';
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

  bool isLoading = false;
  String _errorMessage;

  String _name;
  String _email;
  String _password;
  String _bio;
  @override
  void initState() {
    _errorMessage = "";
    // TODO: implement initState
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
        child: ListView(
          primary: false,
          shrinkWrap: true,
          children: <Widget>[
            Center(
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Color(0x44000000),
                    child: Container(
                      child: Icon(
                        MdiIcons.faceProfile,
                        size: 30,
                      ),
                    ),
                    radius: 60,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    width: 45,
                    height: 45,
                    child: Icon(MdiIcons.camera),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: TextStyles().baseGrad()),
                  )
                ],
              ),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
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
              height: 30,
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
              height: 30,
            ),
            Center(
                child: Text("or connect with:",
                    style: TextStyles()
                        .regularTextStyle()
                        .copyWith(color: Colors.white, fontSize: 14))),
            Container(
              height: 10,
            ),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton.icon(
                    label: Text(""),
                    icon: Center(child: Icon(MdiIcons.google)),
                    onPressed: () {},
                    shape: CircleBorder(),
                  ),
                  FlatButton.icon(
                    label: Text(""),
                    icon: Center(child: Icon(MdiIcons.facebook)),
                    onPressed: () {},
                    shape: CircleBorder(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Center(
              child: Text(
                  "By continuing you are agreeing to our Terms of Service and Privacy and Cookie Policy",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400)),
            ),
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
        userId = (await widget.auth.signUp(_email, _password, _name)).uid;

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
