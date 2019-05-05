import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:proba/services/new_challenge.dart';

class AddChallenge extends StatefulWidget {

  AddChallenge({Key key, this.challengeDetails}) : super (key: key);
  NewChallenge challengeDetails;

  @override
  _AddChallengeState createState() => _AddChallengeState();
}

class _AddChallengeState extends State<AddChallenge> {

  static final _challengeDuration = ["Daily","Weekly","Monthly","Yearly"];
  var currentDurationSelected = _challengeDuration[0];
  TextEditingController _challengeName = TextEditingController();
  TextEditingController _challengeDescription = TextEditingController();
  File _image;
  double _minPadding = 12.0;
  var _fKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _fKey,
        child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(_minPadding),
                child: Text("Add new challenge",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22.0
                  ),
                ),
              ),
              challengeInfo("Name of the challenge"),
              challengeInfo("Description"),
              challengeDurationPicker(),
              Padding(
                padding: EdgeInsets.all(_minPadding),
                child: Center(
                  child: SizedBox(
                    height: 200.0,
                    width: 200.0,
                    child: _image == null
                        ? Center(child: Text("No image selected"),)
                        : Image.file(_image),
                  ),
                ),
              ),
              addPhotoButton(),
              postChallenge()
            ]
        ),
      ),
    );
  }


  bool validateAndSave () {
    var _fState = _fKey.currentState;
    if (_fState.validate()){
      _fState.save();
      return true;
    }
    else return false;
  }

  Future<String> uploadImage (File pic) {
    var userUid = widget.challengeDetails.giveCurrentUserUid();
    final StorageReference _fireBaseStorageRef = FirebaseStorage
        .instance
        .ref()
        .child("Challenge_pictures/${widget.challengeDetails.name}$userUid");
    StorageUploadTask task = _fireBaseStorageRef.putFile(pic);
    var imageUrl = task.onComplete.then((value) {return value.toString();});
    return imageUrl;
  }

  //upisuje podatke novog challenge u bazu trenutnog usera
  validateAndSubmit () async {
    if (validateAndSave()){
      widget.challengeDetails.name = _challengeName.text;
      widget.challengeDetails.description = _challengeDescription.text;
      widget.challengeDetails.duration = currentDurationSelected;
      //widget.user.image = _image;
      //String url = await uploadImage(widget.user.image);

      await NewChallenge().addNewChallenge(widget.challengeDetails, /*url*/);
    }
  }


  Widget challengeInfo (String text) {
    return Padding(
      padding: EdgeInsets.all(_minPadding),
      child: TextFormField(
        controller: text == "Description" ? _challengeDescription : _challengeName,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13.0)
            ),
            labelText: "$text"
        ),
        validator: (value) {
          if (value.length < 1){
            return "Requies at least one character";
          }
          else return null;
        },
      ),
    );
  }

  Widget addPhotoButton () {
    return Padding(
      padding: EdgeInsets.all(_minPadding),
      child: Container(
        alignment: Alignment.topLeft,
        child: FloatingActionButton(
          mini: true,
          onPressed: getImage,
          child: Icon(
            Icons.add_a_photo,
            color: Theme.of(context).textSelectionColor,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          tooltip: "Click to add photo",
          elevation: 0.0,
        ),
      ),
    );
  }

  Future getImage () async {
    var image = await ImagePicker.pickImage(source:
    ImageSource.gallery,
    );
    setState(() {
      _image = image;
    });
  }



  Widget challengeDurationPicker() {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 110.0, right: 110.0),
      child: DropdownButton<String>(
        items: _challengeDuration.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (String value) {
          setState(() {
            this.currentDurationSelected = value;
          });
        },
        hint: Text("Select duration"),
        value: currentDurationSelected,
      ),
    );
  }

  Widget postChallenge () {
    return Padding(
      padding: EdgeInsets.only(left: 120.0, right: 120.0),
      child: RaisedButton(
        onPressed: validateAndSubmit,
        child: Text("Post"),
        color: Theme.of(context).buttonColor,
        textColor: Theme.of(context).textSelectionColor,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(23.0)
        ),
      ),
    );
  }
}
