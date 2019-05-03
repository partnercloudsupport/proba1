import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  var allChallenges = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: challengesToFeed(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return cardBuilder(snapshot);
        },
      ),
    );
  }

  challengesToFeed () async {
    var queryResult = await Firestore.instance.collection("Users")
        .where("challenges", isGreaterThanOrEqualTo: 1)
        .getDocuments();
    if (queryResult.documents.isNotEmpty){
      for (int i=0; i <= queryResult.documents.length; ++i){
        allChallenges.add(queryResult.documents[i].data);
      }
    }
  }

  Widget cardBuilder (snapshot) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Card(
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("username"),
                ],
              ),
              Container(
                alignment: Alignment.center,
                color: Colors.blue,
                width: 350.0,
                height: 300.0,
                child: Text("IMAGE"),
              ),
              ExpansionTile(
                title: Text("Name of the challenge"),
                trailing: Icon(Icons.keyboard_arrow_down),
                children: <Widget>[
                  ListTile(
                    title: Text("Duration"),
                    subtitle: Text("Description of the challenge"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
