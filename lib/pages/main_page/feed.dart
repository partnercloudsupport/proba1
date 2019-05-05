import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proba/services/all_challenges_storage.dart';

class Feed extends StatefulWidget {

  Feed({Key key, this.challengesInfo}) : super (key: key);

  AllChallengesStorage challengesInfo;

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  List<AllChallengesStorage> allChallenges = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AllChallengesStorage>>(
        future: challengesToFeed(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              _cardBuilder(context, snapshot, index);
            },
          );
        },
      ),
    );
  }


  Future<List<AllChallengesStorage>> challengesToFeed () async {
    var queryResult = await Firestore.instance.collection("Users")
        .where("challenges", isGreaterThanOrEqualTo: 1)
        .getDocuments();
    if (queryResult.documents.isNotEmpty){
      for (int i=0; i < queryResult.documents.length; ++i){
        for (int j=0; j < queryResult.documents[i].data['total_challenges']; ++j){
          widget.challengesInfo.username = queryResult.documents[i].data['username'];
          widget.challengesInfo.name = queryResult.documents[i].data['challenges'][j]['name'];
          widget.challengesInfo.description = queryResult.documents[i].data['challenges'][j]['description'];
          widget.challengesInfo.duration = queryResult.documents[i].data['challenges'][j]['duration'];

          allChallenges.add(widget.challengesInfo);
        }
      }
    }

    return allChallenges;
  }

  Widget _cardBuilder (BuildContext context, AsyncSnapshot snapshot, int index) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(snapshot.data[index].username),
              ],
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.blue,
              width: double.infinity,
              height: 200.0,
              child: Text("IMAGE"),
            ),
            ExpansionTile(
              title: Text(snapshot.data[index].name),
              trailing: Icon(Icons.keyboard_arrow_down),
              children: <Widget>[
                ListTile(
                  title: Text(snapshot.data[index].duration),
                  subtitle: Text(snapshot.data[index].description),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
