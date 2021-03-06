import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:proba/services/userManagement.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:proba/services/current_user_challenges.dart';
import 'package:proba/services/new_challenge.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, this.challengesInfo}) : super(key: key);

  UserChallenges challengesInfo;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File newProfileImage;
  bool _picFlag = false;
  List<UserChallenges> challenges = [];


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserManagement>(
          builder: (BuildContext context, Widget child, UserManagement model) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      _picFlag ? _progressIndicator : getImage(model.photoUrl),
                      showUser(model),
                    ]),
                    //changePicButton(model.photoUrl),
                    Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text("User info")),
                    Divider(color: Theme.of(context).primaryColor, indent: 80.0),
                    showUserInfo("${model.firstName} ${model.lastName}",
                        Icons.account_circle),
                    showUserInfo("${model.birthDate}", Icons.date_range),
                    showUserInfo("${model.email}", Icons.email),
                    //showUserInfo("${model.totalChallenges}", Icons.assignment_turned_in),
                    challengeHistory(model.totalChallenges, Icons.assignment_turned_in)
                  ],
                ),
              ),
            ),
          ),
        );}
      );
  }

  void imageIsUploading() {
    setState(() {
      _picFlag = true;
    });
  }

  void imageDoneUpload() {
    setState(() {
      _picFlag = false;
    });
  }

  Widget _progressIndicator() {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        strokeWidth: 4.0,
      ),
    );
  }

  /*uploadImage (String photoUrl) async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      newProfileImage = tempImage;
      imageIsUploading();
    });

    if (_picFlag == true){
      FirebaseAuth.instance.currentUser()
          .then((user) {
        final StorageReference _fireBaseStorageRef = FirebaseStorage.instance.ref().child(
            "Profile_pictures/${user.uid.toString()}");

        StorageUploadTask task = _fireBaseStorageRef.putFile(newProfileImage);

        task.onComplete
            .then((value) async {
          await UserManagement().updateProfileImage(value.toString());
          setState(() {
            photoUrl = user.photoUrl;
          });
          imageDoneUpload();
        })
            .catchError((e) {
          imageDoneUpload();
          debugPrint("ERROR MESSAGE: $e");
        });
          })
          .catchError((e) {
            imageDoneUpload();
            print("ERROR MESSAGE: $e");
          });

    }
  }*/

  /*Widget changePicButton (String photoUrl) {
    return Container(
      alignment: Alignment.topLeft,
      child: FlatButton(
          onPressed: uploadImage(photoUrl),
          child: Icon(Icons.edit),
      ),
    );
  }*/

  Widget getImage(String imageUrl) {
    /*AssetImage assetImage = AssetImage(model.photoUrl);*/
    Image image =
        Image.network(imageUrl, height: 140.0, width: 140.0, fit: BoxFit.fill);
    return Padding(
      padding: EdgeInsets.only(top: 8.0, left: 14.0, bottom: 8.0),
      child: CircleAvatar(
        child: ClipOval(child: image),
        radius: 70.0,
      ),
    );
  }

  Widget showUser(UserManagement model) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 38.0),
        child: Column(
          children: <Widget>[
            Text(
              model.username ?? "",
              style: TextStyle(fontSize: 23.0),
            ),
            Text("${model.firstName ?? ""} ${model.lastName ?? ""}"),
          ],
        ),
      ),
    );
  }

  Widget showUserInfo(String text, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(text),
              leading: Icon(icon),
            )),
      ],
    );
  }

  Future<List<UserChallenges>> currentUserChallenges() async {
    String currUserId = await NewChallenge().giveCurrentUserUid();
    var queryResult = await Firestore.instance
        .collection("Users")
        .where("uid", isEqualTo: currUserId)
        .getDocuments();

    if (queryResult.documents.isNotEmpty) {
      for (int i = 0;
          i < queryResult.documents[0].data['total_challenges'];
          ++i) {
        widget.challengesInfo.challengeName =
            queryResult.documents[0].data['challenges'][i]['name'];
        print(widget.challengesInfo.challengeName);
        widget.challengesInfo.challengeDuration =
            queryResult.documents[0].data['challenges'][i]['duration'];
        print(widget.challengesInfo.challengeDuration);
        widget.challengesInfo.challengeDesc =
            queryResult.documents[0].data['challenges'][i]['description'];
        print(widget.challengesInfo.challengeDesc);
        print("------------------------------------------");

        challenges.add(widget.challengesInfo);
      }
    }
    return challenges;
  }

  Widget challengeHistory(int totalChallenges, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ExpansionTile(
            title: Text("Total number of challenges posted: $totalChallenges"),
            trailing: Icon(Icons.keyboard_arrow_down),
            leading: Icon(icon),
            children: <Widget>[
              FutureBuilder<List<UserChallenges>>(
                future: currentUserChallenges(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: Text("Loading..."),
                    );
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(snapshot.data[index].challengeName),
                          trailing: Text(snapshot.data[index].challengeDuration),
                          subtitle: Text(snapshot.data[index].challengeDesc),
                        );
                      });
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
