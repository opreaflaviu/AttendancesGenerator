import 'package:flutter/material.dart';
import 'package:attendances/repository/teacher_repository.dart';
import 'package:attendances/utils/colors_constants.dart';
import '../model/teacher.dart';
import '../utils/shared_preferences_utils.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  static final TextEditingController _name = new TextEditingController();
  static final TextEditingController _number = new TextEditingController();
  static final TextEditingController _password = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  String _snackBarText = '';

  void _onChange(String snackBarText) {
    setState(() {
      _snackBarText = snackBarText;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    var _widthDP = _mediaQuery.size.width;
    var _heightDP = _mediaQuery.size.height;

    return new Scaffold(
        backgroundColor: ColorsConstants.backgroundColorYellow,
        key: _scaffoldState,
        appBar: new AppBar(
            title: new Text("Login",
                textAlign: TextAlign.center,
                style: new TextStyle(
                    fontSize: 32.0, color: ColorsConstants.customBlack)),
            centerTitle: true,
            backgroundColor: ColorsConstants.backgroundColorYellow,
            elevation: 2.0,
            automaticallyImplyLeading: false),
        body: new Center(
          child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
            margin: new EdgeInsets.only(right: 32.0, left: 32.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading:
                      Icon(Icons.person, color: ColorsConstants.customBlack),
                  title: TextField(
                      cursorColor: ColorsConstants.customBlack,
                      decoration: new InputDecoration(
                        hintText: 'Name',
                        contentPadding: new EdgeInsets.only(bottom: 4.0),
                        hintStyle: TextStyle(
                            fontSize: 16.0, color: ColorsConstants.customBlack),
                        labelStyle: new TextStyle(
                            fontSize: 16.0, color: ColorsConstants.customBlack),
                      ),
                      style: new TextStyle(fontSize: 16.0, color: Colors.black),
                      controller: _name),
                ),
                ListTile(
                  leading:
                      Icon(Icons.label, color: ColorsConstants.customBlack),
                  title: TextField(
                      cursorColor: ColorsConstants.customBlack,
                      decoration: new InputDecoration(
                          hintText: 'Number',
                          contentPadding: new EdgeInsets.only(bottom: 4.0),
                          hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: ColorsConstants.customBlack),
                          labelStyle: new TextStyle(
                              fontSize: 16.0,
                              color: ColorsConstants.customBlack)),
                      style: new TextStyle(fontSize: 16.0, color: Colors.black),
                      controller: _number),
                ),
                ListTile(
                  leading: Icon(Icons.lock, color: ColorsConstants.customBlack),
                  title: TextField(
                      cursorColor: ColorsConstants.customBlack,
                      decoration: new InputDecoration(
                          hintText: 'Password',
                          contentPadding: new EdgeInsets.only(bottom: 4.0),
                          hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: ColorsConstants.customBlack),
                          labelStyle: new TextStyle(
                              fontSize: 16.0,
                              color: ColorsConstants.customBlack)),
                      style: new TextStyle(fontSize: 16.0, color: Colors.black),
                      obscureText: true,
                      controller: _password),
                ),
                Container(
                  padding: new EdgeInsets.only(top: 16.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new RaisedButton(
                      highlightColor: ColorsConstants.backgroundColor,
                      padding: new EdgeInsets.fromLTRB(_widthDP * 0.10,
                          _heightDP * 0.01, _widthDP * 0.10, _heightDP * 0.01),
                      child: new Text("Back",
                          style: TextStyle(
                              color: ColorsConstants.customBlack,
                              fontSize: 16.0)),
                      onPressed: (() => _onBackClick(context)),
                      splashColor: Colors.white,
                      color: Colors.white,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                    new RaisedButton(
                      highlightColor: ColorsConstants.backgroundColor,
                      padding: new EdgeInsets.fromLTRB(_widthDP * 0.10,
                          _heightDP * 0.01, _widthDP * 0.10, _heightDP * 0.01),
                      child: new Text("Login",
                          style: TextStyle(
                              color: ColorsConstants.customBlack,
                              fontSize: 16.0)),
                      onPressed: _onLoginClick,
                      splashColor: Colors.white,
                      color: Colors.white,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    )
                  ],
                )
              ],
            ),
          )),
        ));
  }

  void _clearTextFields() {
    _name.clear();
    _number.clear();
    _password.clear();
  }

  void _onBackClick(BuildContext context) {
    _clearTextFields();
    Navigator.of(context).pop(true);
  }

  void _onLoginClick() {
    var teacherResponse =
        new TeacherRepository().loginTeacher(_number.text, _password.text);
    teacherResponse.then((student) {
      print(student);
      _studentIsValid(student) ? _validStudent(student) : _invalidStudent();
    });
  }

  void _invalidStudent() {
    _onChange("Wrong Credentials");
    _showSnackBar();
    _clearTextFields();
  }

  void _validStudent(Teacher teacher) {
    _saveInSharedPrefs(teacher);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('main_page', (Route<dynamic> route) => false);
  }

  bool _studentIsValid(Teacher teacher) => teacher.teacherName == _name.text &&
          teacher.teacherPassword == _password.text
      ? true
      : false;

  void _showSnackBar() {
    _scaffoldState.currentState
        .showSnackBar(new SnackBar(content: new Text(_snackBarText)));
  }

  void _saveInSharedPrefs(Teacher teacher) async {
    SharedPreferencesUtils sharedPreferencesUtils =
        new SharedPreferencesUtils();
    sharedPreferencesUtils.saveTeacher(teacher);
  }
}
