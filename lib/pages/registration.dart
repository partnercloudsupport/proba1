import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  var _formkey = GlobalKey<FormState>();
  String firstName;
  String lastName;
  String email;
  String password;

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\['
        r'[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)'
        r'+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword (String value) {
    if (value.length < 4)
      return "Password too short";
    else
      return null;
  }

  bool validateAndSave () {
    var _fmState = _formkey.currentState;
    if (_fmState.validate()){
      _fmState.save();
      return true;
    }
    else return false;
  }

  void validateAndSubmit () async {
    if (validateAndSave()) {
      try {
        FirebaseUser _fbUser = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: email,
            password: password);
        debugPrint("NEW USER REGISTERED. USER ID: ${_fbUser.uid}");
      } catch (e){
        debugPrint("GRESKA! GRESKA! ERROR MESSAGE: $e");
      }
    }
    debugPrint("NIJE VALIDNO");
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Go back",textAlign: TextAlign.left,),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Form(
          key: _formkey,
          child: Center(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    formName("fisrt name"),
                    formName("last name"),
                    //formBirthYearField(),
                    emailAndPass("email adress"),
                    emailAndPass("password"),
                    registrationButton()
                  ],
                ),
              ),
            ),
          ),

        ),
      ),
    );
  }

  Widget formName (String text) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
          decoration: InputDecoration(
            labelText: "Enter your $text",
          ),
          validator: (String value) {
            if (value.isEmpty)
              return "Requires at least one character";
            else
              return null;
          },
          onSaved: text == "first name"
              ? (String value) {firstName = value;}
              : (String value) {lastName = value;}
      ),
    );
  }

  Widget emailAndPass (String text) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: text == "password" ? true : false,
        decoration: InputDecoration(
          labelText: "Enter your $text",
        ),
        validator: text == "email adress" ?
            (String value) => validateEmail(value) :
            (String value) => validatePassword(value),
        onSaved: text == "email adress" ? (String value) {
          setState(() {
            email = value;
          });
        } : (String value) {
          setState(() {
            password = value;
          });
        },
      ),
    );
  }

  Widget formBirthYearField () {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Enter your birth year",
        ),
        validator: (String value) {
          if (value.isEmpty)
            return "Invalid birth year";
          else
            return null;
        },
      ),
    );
  }

  Widget registrationButton () {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: validateAndSubmit,
        child: Text("Register"),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13.0)
        ),
        color: Theme.of(context).buttonColor,
        textColor: Theme.of(context).textSelectionColor,
      ),
    );
  }
}
