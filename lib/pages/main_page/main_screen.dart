import 'package:flutter/material.dart';
import './profile.dart' as profile;
import './add_challenge.dart' as add;
import './feed.dart' as feed;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {

  TabController _tabController;

  var _settingsOptions = ["Edit profile","Sign out"];

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
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
      },
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
              add.AddChallenge(),
              feed.Feed(),
              profile.ProfileScreen()
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
      onSelected: (_) {debugPrint("STISO");},
      itemBuilder: (BuildContext context) {
        return _settingsOptions.map((String item) {
          return PopupMenuItem<String>(
              value: item,
              child: Text(item)
          );
        }).toList();
      },
    );
  }
}