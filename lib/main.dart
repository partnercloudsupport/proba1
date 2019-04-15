import 'package:flutter/material.dart';
import './pages/login.dart';
import './pages/registration.dart';
import './pages/main_page/main_screen.dart';

void main () => runApp(Challenger());


class Challenger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.red[700],
            buttonColor: Colors.red[700],
            textSelectionColor: Colors.white
        ),
        title: "Challenger",
        home: LoginPage(),
        routes: <String, WidgetBuilder> {
          "/login" : (BuildContext context) => LoginPage(),
          "/registration" : (BuildContext context) => RegistrationPage(),
          "/main_page" : (BuildContext context) => MainScreen()
        }
    );
  }
}
