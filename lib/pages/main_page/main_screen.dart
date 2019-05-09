import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './profile.dart' as profile;
import './add_challenge.dart' as add;
import './feed.dart' as feed;
import 'package:proba/services/userManagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/all_challenges_storage.dart';
import 'package:proba/services/new_challenge.dart';
import 'package:proba/services/current_user_challenges.dart';

class MainScreen extends StatefulWidget {

  MainScreen({Key key, this.user}) : super (key: key);

  UserManagement user;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {

  TabController _tabController;
  final _settingsOptions = ["Edit profile","Sign out"];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //Upisuje podatke trenutnog usera u Scope Model
    UserManagement().addToModel(widget.user);
    return ScopedModel<UserManagement>(
      model: widget.user,
      child: Scaffold(
            appBar: AppBar(
              title: Text("Challenger"),
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 0.0,
              backgroundColor: Theme.of(context).primaryColor,
              actions: <Widget>[
                showActions()
              ],
            ),
            bottomNavigationBar: Material(
              color: Theme.of(context).primaryColor,
              child: TabBar(
                  controller: _tabController,
                  tabs: buildTabs()
              ),
            ),

            body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  add.AddChallenge(challengeDetails: NewChallenge(),),
                  feed.Feed(challengesInfo: AllChallengesStorage(),),
                  profile.ProfileScreen(challengesInfo: UserChallenges(),)
                ]
            ),
      ),
    );
  }

  List<Tab> buildTabs () {
    return [
      Tab(icon: Icon(Icons.add),),
      Tab(icon: Icon(Icons.new_releases),),
      Tab(icon: Icon(Icons.person_outline),)
    ];
  }

  Widget showActions () {
    return PopupMenuButton<String>(
      icon: Icon(Icons.settings),
      onSelected: _takeAction,
      itemBuilder: (BuildContext context) {
        return _settingsOptions.map((String item) {
          return PopupMenuItem<String>(
              value: item,
              child: Text(item),
              );
        }).toList();
      },
    );
  }

  void _takeAction (String item) {
    if (item == _settingsOptions[0]){
      editProfile();
    }
    else signOut();
  }

  signOut () async {
    await FirebaseAuth.instance.signOut()
        .then((_) {
          Navigator.of(context).pop();
        })
        .catchError((e) {
          debugPrint("ERROR MESSAGE: $e");
        });
  }

  editProfile () {
    Navigator.of(context).pushNamed("/edit_profile");
  }
}