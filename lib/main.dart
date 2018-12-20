import 'package:attendances/pages/students_at_course_page.dart';
import 'package:flutter/material.dart';
import 'package:attendances/pages/landing_page.dart';
import 'package:attendances/pages/login_page.dart';
import 'package:attendances/pages/register_page.dart';
import 'package:attendances/pages/main_page.dart';

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
//      'students_at_course_page': (BuildContext context) => StudentsAtCoursePage()
    }, home: LandingPage());
  }
}
