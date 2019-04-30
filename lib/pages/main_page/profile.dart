import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:proba/services/userManagement.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  var image = "lib/images/default_picture.png";
  File newProfileImage;
  bool _picFlag = false;


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
                      Row(
                          children: <Widget>[
                            _picFlag ? _progressIndicator : getImage(image),
                            showUser(model),
                          ]
                      ),
                      changePicButton(),
                      Container(
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text("User info")
                      ),
                      Divider(color: Theme.of(context).primaryColor,indent: 80.0),
                      showUserInfo("${model.firstName} ${model.lastName}", Icons.account_circle),
                      showUserInfo("${model.birthDate}", Icons.date_range),
                      showUserInfo("${model.email}", Icons.email),
                      showUserInfo("Total number of challenges", Icons.assignment_turned_in)
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }


  void imageIsUploading () {
    setState(() {
      _picFlag = true;
    });
}

void imageDoneUpload () {
    setState(() {
      _picFlag = false;
    });
}



  Widget _progressIndicator () {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        strokeWidth: 4.0,
      ),
    );
  }

  uploadImage () async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      newProfileImage = tempImage;
      imageIsUploading();
    });

    if (_picFlag == true){
      FirebaseAuth.instance.currentUser()
          .then((user) {
        final StorageReference _fireBaseStorageRef = FirebaseStorage.instance.ref().child(
            "Profile_pictures/${user.uid.toString()}.jpg");

        StorageUploadTask task = _fireBaseStorageRef.putFile(newProfileImage);

        task.onComplete
            .then((value) {
          UserManagement().updateProfileImage(value.toString());
          setState(() {
            image = user.photoUrl;
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
  }

  Widget changePicButton () {
    return Container(
      alignment: Alignment.topLeft,
      child: FlatButton(
          onPressed: uploadImage,
          child: Icon(Icons.edit),
      ),
    );
  }

  Widget getImage (String imageUrl) {
    AssetImage assetImage = AssetImage(imageUrl);
    Image image = Image(image: assetImage, height: 140.0, width: 140.0,fit: BoxFit.fill);
    return  Padding(
        padding: EdgeInsets.only(top:8.0, left: 14.0, bottom: 8.0),
        child: CircleAvatar(
            child: ClipOval(
                child: image
            ),
            radius: 70.0,

      ),
    );
  }

  Widget showUser (UserManagement model) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 38.0),
        child: Column(
                children: <Widget>[
                  Text(
                    model.username ?? "",
                    style: TextStyle(
                        fontSize: 23.0
                    ),
                  ),
                  Text("${model.firstName ?? ""} ${model.lastName ?? ""}"),
                ],
        ),
      ),
    );
  }

  Widget showUserInfo (String text, IconData icon) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
                  title: Text(text),
                  leading: Icon(icon),
                )
              ),
          ],
      );
  }

  Widget userRating() {
    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: Row(
              children: <Widget>[
                  Text("Total number of challenges"),
                  Icon(Icons.assignment_turned_in,size: 40.0,),
              ]
      ),
    );
  }
}
