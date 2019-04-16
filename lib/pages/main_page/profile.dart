import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          getImage("lib/images/profilna_slika.jpg"),
          showUser(),
          userRating(),
          userRatingInfo(),
          showUserInfo("first name", 200.0),
          showUserInfo("last name", 250.0),
          showUserInfo("date of birth",300.0),
          showUserInfo("email", 350.0),
          showUserInfo("something else", 400.0)
        ]
    );
  }

  Widget getImage (String imageUrl) {
    AssetImage assetImage = AssetImage(imageUrl);
    Image image = Image(image: assetImage, height: 140.0, width: 1400.0,fit: BoxFit.fill);
    return Positioned(
      top: 6.0,
      left: 6.0,
      child: CircleAvatar(
        child: ClipOval(
            child: image
        ),
        radius: 70.0,
      ),
    );
  }

  Widget showUser () {
    return Positioned(
      top: 20.0,
      left: 160.0,
      child: Column(
        children: <Widget>[
          Text(
            "Username",
            style: TextStyle(
                fontSize: 26.0
            ),
          ),
          Text("Full name"),
        ],
      ),
    );
  }

  Widget showUserInfo (String text, double pos) {
    return Positioned(
      top: pos,
      left: 2.0,
      right: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("User: $text",style: TextStyle(fontSize: 25.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget userRating() {
    return Positioned(
        top: 105.0,
        right: 20.0,
        child: Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 62.0),
                  child: Icon(Icons.grade,size: 40.0,)
              ),
              Padding(
                  padding: EdgeInsets.only(right: 48.0),
                  child: Icon(Icons.confirmation_number,size: 40.0,)
              ),
            ]
        )
    );
  }

  Widget userRatingInfo () {
    return Positioned(
        top: 165.0,
        right: 20.0,
        child: Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 38.0),
                  child: Text("Rating")
              ),
              Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Text("Total challenges")
              ),
            ]
        )
    );
  }
}
