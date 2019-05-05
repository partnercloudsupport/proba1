import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpenForFirstTime extends StatefulWidget {
  @override
  _OpenForFirstTimeState createState() => _OpenForFirstTimeState();
}

class _OpenForFirstTimeState extends State<OpenForFirstTime> {
  
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
          pageFour()
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _incrementStartupNumber();
    super.dispose();
  }

  Future<int> _getTotalStartupNumber () async {
    final prefs = await SharedPreferences.getInstance();
    final startupNumber = prefs.getInt('startupNumber');

    if (startupNumber == null) return 0;
    else return startupNumber;
  }

  Future<void> _incrementStartupNumber () async {
    final prefs = await SharedPreferences.getInstance();

    int lasStartupNumber = await _getTotalStartupNumber();
    int currentStartupNumber = ++lasStartupNumber;

    await prefs.setInt('startupNumber', currentStartupNumber);

    //TODO proveriti koliko puta se aplikacija upalila i prebaciti na odredjeni page
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

  Widget pageFour() {
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
                  onPressed: null
              )
            ],
          ),
        )
    );
  }
}
