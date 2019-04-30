import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/userManagement.dart';
import 'dart:async';


class RegistrationPage extends StatefulWidget {

  RegistrationPage({Key key, this.user}) : super(key: key);

  UserManagement user;

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  var _formKey = GlobalKey<FormState>();
  TextEditingController _password = TextEditingController();
  TextEditingController _email = TextEditingController();
  bool _flag = false;
  var _sKey = GlobalKey<ScaffoldState>();
  DateTime _dateTime = DateTime.now();
  String _dateFormat = "2/1/1998";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        key: _sKey,
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
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    formName("first name"),
                    formName("last name"),
                    formUsername(),
                    emailAndPass("email adress"),
                    emailAndPass("password"),
                    showBirthDate(context),
                    _flag ? _progressIndicator() : registrationButton()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  _isLoading () {
    setState(() {
      _flag = true;
    });
  }

  _signedIn () {
    setState(() {
      _flag = false;
    });
  }

  @override
  void dispose () {
    _password.dispose();
    _email.dispose();
    super.dispose();
  }

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
    if (value.length <= 6)
      return "Password too short";
    else
      return null;
  }

  bool validateAndSave () {
    var _fmState = _formKey.currentState;
    if (_fmState.validate()){
      _fmState.save();
      _isLoading();
      return true;
    }
    else return false;
  }

  _showSnackBar (String errorText) {
    _sKey.currentState.showSnackBar(
        SnackBar(
            duration: Duration(seconds: 4),
            content: Text(errorText)
        )
    );
  }

  Future validateAndSubmit () async {
    if (validateAndSave()) {
       await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: _email.text,
            password: _password.text)
           .then((_user) {
             widget.user.email = _user.email;
             widget.user.uid = _user.uid;
             widget.user.photoUrl = _user.photoUrl ?? "";
             widget.user.birthDate = _dateFormat;
             print("DATE FORMAT: ${_dateTime.month}/${_dateTime.day}/${_dateTime.year}");
         UserManagement().addNewUser(widget.user);
       })
           .then((value) {
             _signedIn();
             Navigator.of(context).pushReplacementNamed("/main_page");
           })
           .catchError((e) {
         _showSnackBar(e.toString());
         _signedIn();
         debugPrint("GRESKA! GRESKA! ERROR MESSAGE: $e");
       });
      }
    else debugPrint("NIJE VALIDNO");
  }

  Widget _progressIndicator () {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        strokeWidth: 4.0,
      ),
    );
  }


  Widget showBirthDate (BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: RaisedButton(
            onPressed: () => selectDate(context),
            child: Icon(
              Icons.date_range,
              color: Theme.of(context).textSelectionColor,
            ),
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13.0)
            ),
          ),
        ),
        Expanded(
            child:
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(_dateFormat),
            )
        ),
      ],
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
              if (value.isEmpty) return "Requires at least one character";
              else return null;
            },
            onSaved: text == "first name"
                ? (String value) { setState(() {
              widget.user.firstName = value;
            });}
                : (String value) { setState(() {
              widget.user.lastName = value;
            });},
          ),
      );
  }

  Future selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(1945,1,1),
        lastDate: DateTime(2019,12,31)
    );

    if (selected != null)
      setState(() {
        _dateTime = selected;
        _dateFormat = "${_dateTime.month}/${_dateTime.day}/${_dateTime.year}";
      });
  }

  Widget emailAndPass (String text) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: text == "password" ? _password : _email,
        obscureText: text == "password" ? true : false,
        decoration: InputDecoration(
          labelText: "Enter your $text",
        ),
        validator: text == "password" ?
            (String value) => validatePassword(value) :
            (String value) => validateEmail(value),
      ),
    );
  }

  Widget formUsername () {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Enter your username",
        ),
        validator: (String value) {
          if (value.isEmpty)
            return "Requires at least one character";
          else return null;
        },
        onSaved: (value) {
          setState(() {
            widget.user.username = value;
          });
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
