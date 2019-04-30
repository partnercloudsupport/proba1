import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './new_challenge.dart';
import 'package:scoped_model/scoped_model.dart';

class UserManagement extends Model with NewChallenge {
  String firstName;
  String lastName;
  String username;
  String uid;
  String email;
  String photoUrl;
  String birthDate;

  UserManagement(
      {this.firstName,
      this.lastName,
      this.username,
      this.uid,
      this.email,
      this.photoUrl,
      this.birthDate});

  //daje trenutnog user
  Future<String> giveCurrentUserUid() {
    var user = FirebaseAuth.instance.currentUser().then((_currentUser) {
      return _currentUser.uid;
    });
    return user;
  }

  //upis podataka novog user u bazu
  Future addNewUser(user) async {
    await Firestore.instance.collection("Users").add({
      'email': user.email,
      'uid': user.uid,
      'first_name': user.firstName,
      'last_name': user.lastName,
      'username': user.username,
      'photo_url': user.photoUrl,
      'birth_date': user.birthDate,
      'challenges': [
        {'name': "", 'description': "", 'duration': "", 'image': ""}
      ]
    }).catchError((e) {
      debugPrint("ERROR MESSAGE: $e");
    });
  }

  //upis url-a nove slike u bazu trenutnog usera
  Future updateProfileImage(String picUrl) {
    var userInfo = UserUpdateInfo();
    userInfo.photoUrl = picUrl;

    FirebaseAuth.instance.currentUser().then((_currentUser) {
      _currentUser.updateProfile(userInfo).then((value) {
        Firestore.instance
            .collection("Users")
            .where("uid", isEqualTo: _currentUser.uid)
            .getDocuments()
            .then((docs) {
          Firestore.instance
              .document("Users/${docs.documents[0].documentID}")
              .updateData({"photo_url": picUrl}).then((val) {
            print("UPDATED!!!");
          }).catchError((e) {
            print("ERROR MESSAGE 1: $e");
          });
        }).catchError((e) {
          print("ERROR MESSAGE 2: $e");
        });
      }).catchError((e) {
        print("ERROR MESSAGE 3: $e");
      });
    }).catchError((e) {
      print("ERROR MESSAGE 4: $e");
    });
  }

  //dodaje novi challenge u bazu trenutnog usera
  addNewChallenge(
    UserManagement details,
    /*String imageUrl*/
  ) {
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection("Users")
          .where("uid", isEqualTo: user.uid)
          .getDocuments()
          .then((docs) {
        Firestore.instance
            .document("Users/${docs.documents[0].documentID}")
            .setData({
          'challenges': [
            {
              'name': details.name,
              'description': details.description,
              'duration': details.duration,
              //'image' : imageUrl
            }
          ]
        }, merge: true);
      }).then((_) {
        print("USPELO!!!");
      }).catchError((e) {
        print("ERROR MESSAGE 1: $e");
      });
    }).catchError((e) {
      print("ERROR MESSAGE 2: $e");
    });
  }

  addToModel(UserManagement model) async {
    await FirebaseAuth.instance.currentUser().then((_currentUser) {
      Firestore.instance
          .collection("Users")
          .where("uid", isEqualTo: _currentUser.uid)
          .getDocuments()
          .then((QuerySnapshot docs) {
        if (docs.documents.isNotEmpty) {
          var userData;
          userData = docs.documents[0].data;
          model.firstName = userData["first_name"];
          model.lastName = userData["last_name"];
          model.username = userData["username"];
          model.email = userData["email"];
          model.birthDate = userData["birth_date"];
          model.uid = userData["uid"];
          notifyListeners();
        }
      }).catchError((e) {
        debugPrint("ERROR MESSAGE 1: $e");
      });
    }).catchError((e) {
      debugPrint("ERROR MESSAGE 2: $e");
    });
  }

  Future updateUserInfo(TextEditingController firstName,
      TextEditingController lastName, String birth) async {

    await FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection("Users")
          .where("uid", isEqualTo: user.uid)
          .getDocuments()
          .then((docs) {
        Firestore.instance
            .document("Users/${docs.documents[0].documentID}")
            .updateData({
          'first_name': firstName.text,
          'last_name': lastName.text,
          'birth_date': birth,
        }).then((val) {
          print("USPELO!!!!!");
        }).catchError((e) {
          print("ERROR MESSAGE 1: $e");
        });
      }).catchError((e) {
        print("ERROR MESSAGE 2: $e");
      });
    }).catchError((e) {
      print("ERROR MESSAGE 3: $e");
    });
  }

}
