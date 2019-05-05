import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/all_challenges_storage.dart';

class Feed extends StatefulWidget {

  Feed({Key key, this.storage}) : super (key: key);

  AllChallengesStorage storage;

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
          if (!snapshot.hasData){
              return Center(child: Text("Loading..."));
          }
          else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return cardBuilder(context, snapshot, index);
              },
            );
          }
        },
      ),
    );
  }

   Future<List<AllChallengesStorage>> challengesToFeed () async {
    var queryResult = await Firestore.instance.collection("Users")
        .where("total_challenges", isGreaterThanOrEqualTo: 1)
        .getDocuments();
    if (queryResult.documents.isNotEmpty){

      print("QUERY LENGTH: ${queryResult.documents.length}");

      for (int i = 0; i < queryResult.documents.length; ++i){

            for (int j = 0; j < queryResult.documents[i].data['total_challenges']; ++j){

              //TODO dobro radi, pise svaki ponaosob u niz

              widget.storage.username = queryResult.documents[i].data['username'];
              print(widget.storage.username);
              widget.storage.name = queryResult.documents[i].data['challenges'][j]['name'];
              print(widget.storage.name);
              widget.storage.description = queryResult.documents[i].data['challenges'][j]['description'];
              print(widget.storage.description);
              widget.storage.duration = queryResult.documents[i].data['challenges'][j]['duration'];
              print(widget.storage.duration);
              print("ALL CHALLENGES LENGTH: ${allChallenges.length}");
              print("-------------------------------------");

              allChallenges.add(widget.storage);
            }
      }

    }
    //TODO ovde pokazuje gresku, svaki element niza je isti, tj. ima podatke poslednje upisanog clana
    /*allChallenges.forEach((AllChallengesStorage storage) {
      print(storage.name);
      print(storage.description);
      print(storage.username);
      print(storage.duration);
      print("----------------------------------");
    });*/
    return allChallenges;
  }

  Widget cardBuilder (BuildContext context, AsyncSnapshot snapshot, int index) {
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
              width: 350.0,
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
