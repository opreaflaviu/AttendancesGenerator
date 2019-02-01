import 'package:attendances/utils/colors_constants.dart';
import 'package:flutter/material.dart';
import '../repository/teacher_repository.dart';
import '../utils/colors_constants.dart';
import '../model/teacher.dart';
import '../utils/shared_preferences_utils.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => new RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  static final TextEditingController _name = new TextEditingController();
  static final TextEditingController _class = new TextEditingController();
  static final TextEditingController _number = new TextEditingController();
  static final TextEditingController _password = new TextEditingController();
  static final TextEditingController _confirmPassword =
      new TextEditingController();

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

    return Scaffold(
        backgroundColor: ColorsConstants.backgroundColorYellow,
        key: _scaffoldState,
        appBar: AppBar(
            title: Text("Register",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 32.0, color: ColorsConstants.customBlack)),
            centerTitle: true,
            backgroundColor: ColorsConstants.backgroundColorYellow,
            elevation: 2.0,
            automaticallyImplyLeading: false),
        body: Center(
          child: SingleChildScrollView(
              child: Container(
            margin: EdgeInsets.only(right: 32.0, left: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading:
                      Icon(Icons.person, color: ColorsConstants.customBlack),
                  title: TextField(
                      cursorColor: ColorsConstants.customBlack,
                      decoration: new InputDecoration(
                          hintText: 'Name',
                          contentPadding: EdgeInsets.only(bottom: 4.0),
                          hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: ColorsConstants.customBlack),
                          labelStyle: TextStyle(
                              fontSize: 16.0,
                              color: ColorsConstants.customBlack)),
                      style: TextStyle(
                          fontSize: 16.0, color: ColorsConstants.customBlack),
                      controller: _name),
                ),
                ListTile(
                    leading:
                        Icon(Icons.label, color: ColorsConstants.customBlack),
                    title: TextField(
                        cursorColor: ColorsConstants.customBlack,
                        decoration: InputDecoration(
                            hintText: 'Teacher id',
                            contentPadding: EdgeInsets.only(bottom: 4.0),
                            hintStyle: TextStyle(
                                fontSize: 16.0,
                                color: ColorsConstants.customBlack),
                            labelStyle: TextStyle(
                                fontSize: 16.0,
                                color: ColorsConstants.customBlack)),
                        style: TextStyle(
                            fontSize: 16.0, color: ColorsConstants.customBlack),
                        controller: _number)),
                ListTile(
                    leading:
                        Icon(Icons.lock, color: ColorsConstants.customBlack),
                    title: TextField(
                        cursorColor: ColorsConstants.customBlack,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            contentPadding: EdgeInsets.only(bottom: 4.0),
                            hintStyle: TextStyle(
                                fontSize: 16.0,
                                color: ColorsConstants.customBlack),
                            labelStyle: TextStyle(
                                fontSize: 16.0,
                                color: ColorsConstants.customBlack)),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                        obscureText: false,
                        controller: _password)),
                ListTile(
                    leading:
                        Icon(Icons.lock, color: ColorsConstants.customBlack),
                    title: TextField(
                      cursorColor: ColorsConstants.customBlack,
                      decoration: InputDecoration(
                          hintText: 'Confirm password',
                          contentPadding: EdgeInsets.only(bottom: 4.0),
                          hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: ColorsConstants.customBlack),
                          labelStyle: TextStyle(
                              fontSize: 16.0,
                              color: ColorsConstants.customBlack)),
                      obscureText: true,
                      style: TextStyle(
                          fontSize: 16.0, color: ColorsConstants.customBlack),
                      controller: _confirmPassword,
                    )),
                new Container(
                  padding: new EdgeInsets.only(top: 16.0),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new RaisedButton(
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
                      padding: new EdgeInsets.fromLTRB(_widthDP * 0.07,
                          _heightDP * 0.01, _widthDP * 0.07, _heightDP * 0.01),
                      child: new Text("Register",
                          style: TextStyle(
                              color: ColorsConstants.customBlack,
                              fontSize: 16.0)),
                      onPressed: _onRegisterClick,
                      splashColor: Colors.white,
                      color: Colors.white,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                  ],
                )
              ],
            ),
          )),
        ));
  }

  void _clearTextFields() {
    _name.clear();
    _class.clear();
    _number.clear();
    _password.clear();
    _confirmPassword.clear();
  }

  void _onBackClick(BuildContext context) {
    _clearTextFields();
    Navigator.of(context).pop(true);
  }

  void _onRegisterClick() {
    if (_password.text == _confirmPassword.text) {
      if (true) {
        Teacher teacher = new Teacher(_number.text, _name.text, _password.text);
        var teacherResponse = new TeacherRepository().registerTeacher(teacher);
        teacherResponse.then((response) {
          if (response) {
            _saveInSharedPrefs(teacher);
            Navigator.of(context).pushNamedAndRemoveUntil(
                'main_page', (Route<dynamic> route) => false);
          } else {
            print(response.toString());
            _onChange('User already exist');
            _showSnackBar();
          }
        });
      } else {
        print("Invalid password");
        _onChange("Invalid password");
        _showSnackBar(); //example: Aa@^1AfaA  Aaa111aAa
      }
    } else {
      print("Wrong credentials");
      _onChange("Wrong credentials");
      _showSnackBar();
    }
    _clearTextFields();
  }

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
