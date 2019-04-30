import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  var _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;

  _isLoading () {
    setState(() {
      _loading = true;
    });
  }

  _loggedIn () {
    setState(() {
      _loading = false;
    });
  }



  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\['
        r'[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)'
        r'+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else return null;
  }


  String validatePassword (String value) {
    if (value.length <= 6)
      return "Password needs to be at least 6 characters long";
    else return null;
  }

  @override
  dispose(){
    _email.dispose();
    _password.dispose();
    super.dispose();
  }


  bool validateAndSave () {
    var _formState = _formKey.currentState;
    if (_formState.validate()){
      _formState.save();
      _isLoading();
      return true;
    }
    else return false;
  }
  
  _showSnackBar (String errorText) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
          duration: Duration(seconds: 4),
          content: Text(errorText)
      )
    );
  }

  Future<void> validateAndSubmit () async {
    if (validateAndSave()){
      await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: _email.text,
            password: _password.text)
          .then((_user) {
            _loggedIn();
            Navigator.of(context).pushNamed("/main_page");
          })
          .catchError((e) {
        _showSnackBar(e.toString());
        _loggedIn();
        debugPrint("GRESKA! GRESKA! ERROR MESSAGE: $e");
      });
      }
    else debugPrint("NIJE VALIDNO");
  }

  Widget textFormField (String text) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: TextFormField(
        controller: text == "password" ? _password : _email,
        obscureText: text == "password" ? true : false,
        decoration: InputDecoration(
            labelText: "Enter your $text",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)
            )
        ),
        validator: text == "password"
            ? (String value) => validatePassword(value)
            : (String value) => validateEmail(value),
      ),
    );
  }

  Widget loginButton () {
    return Padding(
      padding: EdgeInsets.only(left: 120.0, right: 120.0),
      child: RaisedButton(
        onPressed: validateAndSubmit,
        child: Text("Login"),
        color: Theme.of(context).buttonColor,
        textColor: Theme.of(context).textSelectionColor,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13.0)
        ),
      ),
    );
  }

  Widget regButton () {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).pushNamed("/registration");
      },
      child: Text("Don't have an account? Create new!",
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget getImage (String imageUrl) {
    AssetImage assetImage = AssetImage(imageUrl);
    Image image = Image(image: assetImage, height: 250.0, width: 250.0,);
    return Container(child: image);
  }

  Widget _progressIndicator () {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        strokeWidth: 4.0,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: ListView(
            children: <Widget>[
              getImage("lib/images/challenge.jpg"),
              textFormField("email addres"),
              textFormField("password"),
              _loading ? _progressIndicator() : loginButton(),
              regButton(),
              Divider(height: 80.0)
            ]
        ),
      ),
    );
  }
}

