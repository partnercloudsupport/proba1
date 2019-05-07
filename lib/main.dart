import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pages/login.dart';
import './pages/registration.dart';
import './pages/main_page/main_screen.dart';
import 'package:proba/services/userManagement.dart';
import './pages/main_page/edit_profile.dart';
import './pages/first_time_opening_app.dart';


void main () => runApp(Challenger());


class Challenger extends StatefulWidget {

  @override
  _ChallengerState createState() => _ChallengerState();
}

class _ChallengerState extends State<Challenger> {
  bool _alreadyInstalled = false;


  @override
  void initState() {
    super.initState();
    _checkIfSeen();

  }

  Future _checkIfSeen() async {
    final prefs = await SharedPreferences.getInstance();
    final _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
        setState(() {
          _alreadyInstalled = true;
        });
    }
    else {prefs.setBool('seen', true);}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Color(0xFFE8290B),
              buttonColor: Colors.red,
              textSelectionColor: Colors.white
          ),
          title: "Challenger",
          home: _alreadyInstalled ? LoginPage() : OpenForFirstTime(),
          routes: <String, WidgetBuilder> {
            "/login" : (BuildContext context) => LoginPage(),
            "/registration" : (BuildContext context) => RegistrationPage(user: UserManagement(),),
            "/main_page" : (BuildContext context) => MainScreen(user: UserManagement(),),
            "/edit_profile" : (BuildContext context) => EditProfile(),
            "/open_first_time" : (BuildContext context) => OpenForFirstTime()
          }
    );
  }
}
