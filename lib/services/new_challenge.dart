import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewChallenge {

  String name;
  String description;
  String duration;
  //File image;

//daje trenutnog user
  Future<String> giveCurrentUserUid() {
    var userId = FirebaseAuth.instance.currentUser().then((_currentUser) {
      return _currentUser.uid;
    });
    return userId;
  }

  //dodaje novi challenge u bazu trenutnog usera
  addNewChallenge(
      NewChallenge details,
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
}