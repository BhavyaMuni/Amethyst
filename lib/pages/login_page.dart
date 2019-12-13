import 'package:amethyst_app/pages/sign_up_sequence.dart';
import 'package:amethyst_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key key, this.auth, this.isLogin, this.ctxs})
      : super(key: key);

  final BaseAuth auth;
  final bool isLogin;
  final List<BuildContext> ctxs;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isFormLogin;
  final _formKey = new GlobalKey<FormState>();
  final _key = new GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  String _errorMessage;
  String _name;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: isFormLogin
            ? Stack(children: <Widget>[_login_body(), _showCircularProgress()])
            : Stack(
                children: <Widget>[_register_body(), _showCircularProgress()]),
      ),
    );
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    isFormLogin = widget.isLogin;
    super.initState();
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _login_body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10),
          child: _showLogo(),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              decoration: InputDecoration(
                  hintText: "Email Address",
                  icon: Icon(
                    Icons.email,
                    color: Color(0xffb339f6),
                  )),
              validator: (value) =>
                  value.isEmpty ? "Email can\'t be empty" : null,
              onSaved: (value) => _email = value.trim()),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: TextFormField(
            decoration: InputDecoration(
                hintText: "Password",
                icon: Icon(
                  Icons.lock,
                  color: Color(0xffb339f6),
                )),
            obscureText: true,
            autofocus: false,
            validator: (value) =>
                value.isEmpty ? "Password can\'t be empty" : null,
            onSaved: (value) => _password = value.trim(),
          ),
        ),
        _primaryBut(),
        _showSecondaryButton(),
        _showErrorMessage(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Divider(
            thickness: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Text(
            "Or continue with: ",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
        ),
        buttons(),
        _termsOfService(),
      ],
    );
  }

  Widget _register_body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10),
          child: _showLogo(),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: TextFormField(
              autofocus: false,
              decoration: InputDecoration(
                  hintText: "Name",
                  icon: Icon(
                    Icons.email,
                    color: Color(0xffb339f6),
                  )),
              validator: (value) =>
                  value.isEmpty ? "Name can\'t be empty" : null,
              onSaved: (value) => _name = value.trim()),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              decoration: InputDecoration(
                  hintText: "Email Address",
                  icon: Icon(
                    Icons.email,
                    color: Color(0xffb339f6),
                  )),
              validator: (value) =>
                  value.isEmpty ? "Email can\'t be empty" : null,
              onSaved: (value) => _email = value.trim()),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: TextFormField(
            decoration: InputDecoration(
                hintText: "Password",
                icon: Icon(
                  Icons.lock,
                  color: Color(0xffb339f6),
                )),
            obscureText: true,
            autofocus: false,
            validator: (value) =>
                value.isEmpty ? "Password can\'t be empty" : null,
            onSaved: (value) => _password = value.trim(),
          ),
        ),
        _primaryBut(),
        _showSecondaryButton(),
        _showErrorMessage(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Divider(
            thickness: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Text(
            "Or continue with: ",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
        ),
        buttons(),
        _termsOfService(),
      ],
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _primaryBut() {
    return new GradientButton(
      gradient: new LinearGradient(
          colors: <Color>[Color(0xffB339F6), Color(0xff32D5EB)]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isFormLogin == true
            ? Text("Sign In", style: TextStyle(color: Colors.white))
            : Text("Sign Up"),
      ),
      callback: validateAndSubmit,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    );
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: isFormLogin == true
          ? new Text('Create an account',
              style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300))
          : new Text('Have an account? Sign in',
              style:
                  new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300)),
      onPressed: () {},
    );
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60.0,
          child: Image.asset('images/logo5.png'),
        ),
      ),
    );
  }

  Widget buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Icon(
            MdiIcons.google,
            color: Color(0xffde5246),
          ),
          onPressed: () async {
            try {
              await widget.auth.googleSignIn();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/root", (route) => false);
            } catch (e) {
              setState(() {
                _isLoading = false;
                _errorMessage = e.message;
                _formKey.currentState.reset();
              });
            }
          },
        ),
        FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Icon(
            MdiIcons.facebook,
            color: Color(0xff3b5998),
          ),
          onPressed: () async {
            try {
              await widget.auth.facebookSignIn();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            } catch (e) {
              print("Error: $e");
              setState(() {
                _isLoading = false;
                _errorMessage = e.message;
                _formKey.currentState.reset();
              });
            }
          },
        )
      ],
    );
  }

  Widget _termsOfService() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 70, 15, 0),
      child: Center(
        child: Text(
          "By clicking Sign In, you agree to our terms and that you have read our data use policy, including cookie use.",
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w200),
          textAlign: TextAlign.center,
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
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (!isFormLogin) {
          // userId = (await widget.auth.signUp(_email, _password, _name)).uid;

          Navigator.of(context)
              .pushNamedAndRemoveUntil("/root", (route) => false);
        } else {
          userId = (await widget.auth.signIn(_email, _password)).uid;
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/root", (route) => false);
        }
        //widget.auth.sendEmailVerification();
        //_showVerifyEmailSentDialog();
        print('Signed up user: $userId');

        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }
}
