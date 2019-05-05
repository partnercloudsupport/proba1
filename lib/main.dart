import 'package:flutter/material.dart';
import './pages/login.dart';
import './pages/registration.dart';
import './pages/main_page/main_screen.dart';
import 'package:proba/services/userManagement.dart';
import './pages/main_page/edit_profile.dart';
import './pages/first_time_opening_app.dart';


void main () => runApp(Challenger());


class Challenger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Colors.red[700],
              buttonColor: Colors.red[700],
              textSelectionColor: Colors.white
          ),
          title: "Challenger",
          home: LoginPage(),
          routes: <String, WidgetBuilder> {
            "/login" : (BuildContext context) => LoginPage(),
            "/registration" : (BuildContext context) => RegistrationPage(user: UserManagement(),),
            "/main_page" : (BuildContext context) => MainScreen(user: UserManagement()),
            "/edit_profile" : (BuildContext context) => EditProfile(),
            "/open_first_time" : (BuildContext context) => OpenForFirstTime()
          }
    );
  }
}
