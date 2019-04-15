import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

class AddChallenge extends StatefulWidget {
  @override
  _AddChallengeState createState() => _AddChallengeState();
}

class _AddChallengeState extends State<AddChallenge> {

  File _image;
  double _minPadding = 12.0;

  @override
  Widget build(BuildContext context) {
    return Form(
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
            Padding(
              padding: EdgeInsets.all(_minPadding),
              child: Center(
                child: _image == null
                      ? Text("No image selected")
                      : Image.file(_image),
              ),
            ),
            addPhotoButton(),
          ]
      ),
    );
  }

  Widget challengeInfo (String text) {
    return Padding(
      padding: EdgeInsets.all(_minPadding),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13.0)
            ),
            labelText: "$text"
        ),
      ),
    );
  }

  Widget addPhotoButton () {
    return Padding(
      padding: EdgeInsets.all(_minPadding),
      child: FloatingActionButton(
        onPressed: getImage,
        child: Icon(
          Icons.add_a_photo,
          color: Theme.of(context).textSelectionColor,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: "Click to add photo",
        elevation: 0.0,
      ),
    );
  }

  Future getImage () async {
    var image = await ImagePicker.pickImage(source:
    ImageSource.gallery,
        maxHeight: 200.0,
        maxWidth: 200.0
    );
    setState(() {
      _image = image;
    });
  }
}
