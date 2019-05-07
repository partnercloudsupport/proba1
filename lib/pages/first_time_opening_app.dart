import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_indicator/page_indicator.dart';

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
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFE8290B), Color(0xFFEA7773)],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp)),
        child: PageIndicatorContainer(
          pageView: PageView(
            controller: _pageController,
            children: <Widget>[
              pageOne(),
              pageTwo(),
              pageThree(),
              pageFour(context)
            ],
          ),
          align: IndicatorAlign.bottom,
          length: 4,
          indicatorSpace: 20.0,
          padding: const EdgeInsets.all(10),
          indicatorColor: Colors.white,
          indicatorSelectorColor: Color(0xFF4C4B4B),
          shape: IndicatorShape.circle(size: 12),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
 //   Timer(Duration(milliseconds: 100), () {
   //   _checkIfSeen();
  //  });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /*Future _checkIfSeen() async {
    final prefs = await SharedPreferences.getInstance();
    final _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacementNamed("/main_page");
    } else {
      prefs.setBool('seen', true);
    }
  }*/

  Widget pageOne() {
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                 Text("Welcome to Challenger"),
                Text("Place where you can find all kinds of challenges"),
                SizedBox(height: 40.0,),
                Text("Try it and see if you are next challenge master"),
        ],
      )
    );
  }

  Widget pageTwo() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.add),
          SizedBox(height: 10.0),
          Text("Button for adding new challenge"),
          SizedBox(height: 30.0),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "Clicking on this button you will start proces of adding new challenge."
                " Enter name, description and duration of the challenge and photo of course"),
          )
        ],
      ),
    );
  }

  Widget pageThree() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.new_releases),
          SizedBox(height: 10.0),
          Text("Challenges feed"),
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Place where all the challenges on the world will be posted."
                " Keep scrolling and you might find perfect challenge for you"),
          )
        ],
      ),
    );
  }

  Widget pageFour(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.person_outline),
          SizedBox(height: 10.0),
          Text("Challenges feed"),
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("You can visit your profile and see your challenge history,"
            " set profile picture and update personal informations. Login or create"
                "new profile and LET'S START!"),
          ),
          SizedBox(height: 20.0),
          RaisedButton(
              padding: EdgeInsets.all(8.0),
              child: Text("Let's start"),
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/main_page");
              })
        ],
      ),
    );
  }
}
