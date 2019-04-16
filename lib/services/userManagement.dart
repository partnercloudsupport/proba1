import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class UserManagement {

  String firstName;
  String lastName;
  String username;
  String email;
  String password;
  String uid;

  UserManagement({this.firstName,this.lastName, this.username,this.email,this.password,this.uid});

  addNewUser (nameInfo, context) {
    Firestore.instance.collection("Users")
        .add({
      'email' : nameInfo.email,
      'password' : nameInfo.password,
      'uid' : nameInfo.uid,
      'first name' : nameInfo.firstName,
      'last name' : nameInfo.lastName,
      'username' : nameInfo.username
    })
        .then((value) {
      Navigator.of(context).pushReplacementNamed("/main_page");
    })
        .catchError((e) {
          debugPrint("ERROR MESSAGE: $e");
    });
  }
}