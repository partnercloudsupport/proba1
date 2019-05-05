import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpenForFirstTime extends StatefulWidget {
  @override
  _OpenForFirstTimeState createState() => _OpenForFirstTimeState();
}

class _OpenForFirstTimeState extends State<OpenForFirstTime> {

  //POKRECE SE SAMO PRVI PUT KAD SE PALI APP...
  
  PageController _pageController;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          pageOne(),
          pageTwo(),
          pageThree(),
          pageFour(context)
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    Timer(Duration(milliseconds: 200), () {
      _checkIfSeen();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future _checkIfSeen () async {
    final prefs = await SharedPreferences.getInstance();
    final _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {Navigator.of(context).pushReplacementNamed("/main_page");}
    else {
      prefs.setBool('seen', true);
      //Navigator.of(context).pushReplacement(
        //  new MaterialPageRoute(builder: (context) => new IntroScreen()));
    }
  }

  Widget pageOne () {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text("Welcome to Challenger \n Place to find all kinds of challenges"),
            SizedBox(height: 40.0),
            Text("Try it and see if you are next challenge master")
          ],
        ),
      ),
    );
  }
  Widget pageTwo () {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: Icon(Icons.add)),
                Text("Add new challenge")
              ],
            ),
            SizedBox(height: 20.0),
            Text("Clicking on this button you will start proces of adding new challenge \n"
                "Enter name, description and duration of the challenge and photo of course")
          ],
        ),
      )
    );
  }
  Widget pageThree () {
    return Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: Icon(Icons.new_releases)),
                  Text("Challenges feed")
                ],
              ),
              SizedBox(height: 20.0),
              Text("Place where all the challenges on the world will be posted \n"
                  "Keep scrolling and you might find perfect challenge for you")
            ],
          ),
        )
    );
  }

  Widget pageFour(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: Icon(Icons.person_outline)),
                  Text("Challenges feed")
                ],
              ),
              SizedBox(height: 20.0),
              Text("You can visit your profile and see your challenge history \n"
                  "Also you can edit your profile at any time by clicking on the ${Icon(Icons.settings)}"),
              SizedBox(height: 20.0),
              RaisedButton(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Let's start"),
                  color: Theme.of(context).primaryColor,
                  shape: CircleBorder(side: BorderSide(style: BorderStyle.solid)),
                  onPressed: () {Navigator.of(context).pushReplacementNamed("/main_page");}
              )
            ],
          ),
        )
    );
  }
}
