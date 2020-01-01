import 'package:amethyst_app/services/auth.dart';
import 'package:amethyst_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginPage(
        auth: new Auth(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.auth}) : super(key: key);

  final BaseAuth auth;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();
  final _confKey = new GlobalKey<FormState>();

  bool isLoading = false;
  String _errorMessage;

  String _email;
  String _password;

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                    "Sign In",
                    style: TextStyles().headerTextStyle(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                  child: Center(
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed: () => Navigator.pop(context),
                        child: Text("Don't have an account? Create one!",
                            style: TextStyles()
                                .regularTextStyle()
                                .copyWith(color: Colors.white, fontSize: 14))),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Center(
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) => alertDialog(ctx));
                        },
                        child: Text("Need help signing in?",
                            style: TextStyles()
                                .regularTextStyle()
                                .copyWith(color: Colors.white, fontSize: 14))),
                  ),
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

                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
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

  Widget alertDialog(BuildContext context) {
    String forgotEmail;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      contentPadding: EdgeInsets.all(20.0),
      content: Form(
        key: _confKey,
        child: Container(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Forgot your password?",
                style: TextStyles().headerTextStyle().copyWith(fontSize: 20),
              ),
              Text(
                "A link to reset your password will be sent to the email if an account with this email exists.",
                style: TextStyles()
                    .regularTextStyle()
                    .copyWith(color: Colors.white, fontSize: 16),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0x44000000),
                    borderRadius: BorderRadius.circular(40)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: new TextFormField(
                    maxLines: 1,
                    style: TextStyles()
                        .regularTextStyle()
                        .copyWith(color: Colors.white, fontSize: 14),
                    validator: (val) {
                      if (val.isEmpty || val == "")
                        return "";
                      else
                        return null;
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10)),
                    onSaved: (val) => forgotEmail = val.trim(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GradientButton(
                  callback: () async {
                    if (_confKey.currentState.validate())
                      _confKey.currentState.save();
                    Navigator.pop(context);
                    await widget.auth.resetPass(forgotEmail);
                  },
                  gradient: TextStyles().baseGrad(),
                  child: Text(
                    "Confirm",
                    style: TextStyles()
                        .regularTextStyle()
                        .copyWith(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
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
        userId = (await widget.auth.signIn(_email, _password)).uid;

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
