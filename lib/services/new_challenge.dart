import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proba/services/userManagement.dart';

class NewChallenge {

  String name;
  String description;
  String duration;
  //File image;

  NewChallenge({this.name, this.description, this.duration});

  //daje uid trenutnog user
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
        var tempOutput = new List<dynamic>.from(docs.documents[0].data["challenges"]);
        tempOutput.add({
          'name': details.name,
          'description': details.description,
          'duration': details.duration,
          //'image' : imageUrl
        });
        Firestore.instance
            .document("Users/${docs.documents[0].documentID}")
            .setData({"challenges": tempOutput}, merge: true);
      }).then((_) {
        UserManagement().updateTotalChallengesNumber();
        print("USPELO!!!");
      }).catchError((e) {
        print("ERROR MESSAGE 1: $e");
      });
    }).catchError((e) {
      print("ERROR MESSAGE 2: $e");
    });
  }
}