
import 'package:attendances/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:attendances/pages/landing_page.dart';
import 'package:attendances/pages/login_page.dart';
import 'package:attendances/pages/register_page.dart';
import 'package:attendances/pages/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(routes: <String, WidgetBuilder>{
      'landing_page': (BuildContext context) => LandingPage(),
      'login_page': (BuildContext context) => LoginPage(),
      'register_page': (BuildContext context) => RegisterPage(),
      'main_page': (BuildContext context) => MainPage(),
    }, home: content(context));
  }

  Widget content(BuildContext context) {
    return FutureBuilder(
        future: getFromSharedPreferences(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('An error was encountered'),
                  ),
                );
              } else {
                if (snapshot.data == true) {
                  return MainPage();
                } else {
                  return LandingPage();
                }
              }
          }
        }
    );
  }

  Future<bool> getFromSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var teacherName = sharedPreferences.getString(Constants.teacherName);
    var teacherNumber = sharedPreferences.getString(Constants.teacherId);

    return teacherName != null && teacherNumber != null;
  }
}
