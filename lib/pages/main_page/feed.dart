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
          if (!snapshot.hasData) return Center(child: Text("Loading..."));
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _cardBuilder(context, snapshot, index);
            },
          );
        },
      ),
    );
  }


  Future<List<AllChallengesStorage>> challengesToFeed () async {
    var queryResult = await Firestore.instance.collection("Users")
        .where("total_challenges", isGreaterThanOrEqualTo: 1)
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
            Container(
              alignment: Alignment.center,
              color: Colors.blue,
              width: MediaQuery.of(context).size.width,
              height: 200.0,
              child: Text("IMAGE"),
            ),
            ExpansionTile(
              title: Text(snapshot.data[index].username),
              trailing: Icon(Icons.keyboard_arrow_down),
              children: <Widget>[
                ListTile(
                  title: Text(snapshot.data[index].name),
                  subtitle: Text(snapshot.data[index].description),
                  trailing: Text(snapshot.data[index].duration),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
