import 'package:flutter/material.dart';
import 'package:proba/services/userManagement.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _newFirstName = TextEditingController();
  TextEditingController _newLastName = TextEditingController();
  DateTime _dateTime = DateTime.now();
  String _dateFormat = "2/1/1998";
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

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
        key: _key,
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _globalKey,
                child: Column(
                  children: <Widget>[
                    newInfo("first name"),
                    newInfo("last name"),
                    showBirthDate(context),
                    updateButton(context)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showSnackBar (String errorText) {
    _key.currentState.showSnackBar(
        SnackBar(
            duration: Duration(seconds: 4),
            content: Text(errorText)
        )
    );
  }

  bool validateAndSave () {
    var _fmState = _globalKey.currentState;
    if (_fmState.validate()){
      _fmState.save();
      return true;
    }
    else return false;
  }

  Future validateAndSubmit () async {
    if (validateAndSave()){
      UserManagement()
          .updateUserInfo(_newFirstName, _newLastName, _dateFormat)
          .then((val) {_showSnackBar("Profile updated!");})
          .catchError((e) {_showSnackBar(e);});
    }
  }


  Widget showBirthDate(BuildContext context) {
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
            shape:
                OutlineInputBorder(borderRadius: BorderRadius.circular(13.0)),
          ),
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(_dateFormat)
        )),
      ],
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

  Widget newInfo(String text) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: text == "first name" ? _newFirstName : _newLastName,
        decoration: InputDecoration(
          labelText: "Enter new $text",
        ),
        validator: (String value) {
          if (value.isEmpty) return "Requires at least one character";
          else return null;
        },
      ),
    );
  }

  Widget updateButton(BuildContext context) {
    return RaisedButton(
        onPressed: validateAndSubmit,
        child: Text(
          "Update profile information",
          style: TextStyle(
            color: Theme.of(context).textSelectionColor
          ),
        ),
        shape:
        OutlineInputBorder(borderRadius: BorderRadius.circular(13.0))
    );
  }


}
