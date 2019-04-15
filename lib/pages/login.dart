import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _email;
  String _password;
  var _formKey = GlobalKey<FormState>();



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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
            children: <Widget>[
              getImage("lib/images/challenge.jpg"),
              textFormField("email addres"),
              textFormField("password"),
              loginButton(),
              regButton(),
              Divider(height: 80.0)
            ]
        ),
      ),
    );
  }

  bool validateAndSave () {
    var _formState = _formKey.currentState;
    if (_formState.validate()){
      _formState.save();
      return true;
    }
    else return false;
  }

  void validateAndSubmit () async {
    if (validateAndSave()){
      try {
        FirebaseUser _user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: _email,
            password: _password);
        debugPrint("SIGN IN. USER ID: ${_user.uid}");
      }catch (e){
        debugPrint("GRESKA! GRESKA! ERROR MESSAGE: $e");
      }
    }
    debugPrint("NIJE VALIDNO");
  }

  Widget textFormField (String text) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: TextFormField(
        obscureText: text == "password" ? true : false,
        decoration: InputDecoration(
            labelText: "Enter your $text",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)
            )
        ),
        validator: text == "email adress"
            ? (String value) => validateEmail(value)
            : (String value) => validatePassword(value),
        onSaved: text == "email adress"
            ?  (String value) {_email = value;}
            : (String value) {_password = value;},
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
}

