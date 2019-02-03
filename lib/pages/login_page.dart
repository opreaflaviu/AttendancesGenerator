import 'package:flutter/material.dart';
import 'package:attendances/repository/teacher_repository.dart';
import 'package:attendances/utils/colors_constants.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  static final TextEditingController _name = new TextEditingController();
  static final TextEditingController _id = new TextEditingController();
  static final TextEditingController _password = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();

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
              child: Container(
            margin: new EdgeInsets.only(right: 32.0, left: 32.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  leading:
                      Icon(Icons.person, color: ColorsConstants.customBlack),
                  title: TextField(
                      cursorColor: ColorsConstants.customBlack,
                      decoration: new InputDecoration(
                        hintText: 'Name',
                        contentPadding: new EdgeInsets.only(bottom: 4.0, top:
                        8.0),
                        hintStyle: TextStyle(
                            fontSize: 16.0, color: ColorsConstants.customBlack),
                        labelStyle: new TextStyle(
                            fontSize: 16.0, color: ColorsConstants.customBlack),
                      ),
                      style: new TextStyle(fontSize: 16.0, color: Colors.black),
                      controller: _name),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  leading:
                      Icon(Icons.label, color: ColorsConstants.customBlack),
                  title: TextField(
                      cursorColor: ColorsConstants.customBlack,
                      decoration: new InputDecoration(
                          hintText: 'Number',
                          contentPadding: new EdgeInsets.only(bottom: 4.0, top: 8.0),
                          hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: ColorsConstants.customBlack),
                          labelStyle: new TextStyle(
                              fontSize: 16.0,
                              color: ColorsConstants.customBlack)),
                      style: new TextStyle(fontSize: 16.0, color: Colors.black),
                      controller: _id),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  leading: Icon(Icons.lock, color: ColorsConstants.customBlack),
                  title: TextField(
                      cursorColor: ColorsConstants.customBlack,
                      decoration: new InputDecoration(
                          hintText: 'Password',
                          contentPadding: new EdgeInsets.only(bottom: 4.0, top: 8.0),
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
    _id.clear();
    _password.clear();
  }

  void _onBackClick(BuildContext context) {
    _clearTextFields();
    Navigator.of(context).pop(true);
  }

  void _onLoginClick() {
    var response = TeacherRepository().loginTeacher(_name.text, _password.text,
        _id.text);
    response.then((result){
      _navigateToMainPage();
    }).catchError((error) {
      if( error.runtimeType.toString() == 'SocketException') {
        _showAlertDialog('Error', 'Cannot connect to server');
      }
      _showAlertDialog('Error', error.toString());
    });
  }

  void _navigateToMainPage() {
    Navigator.of(context).pushNamedAndRemoveUntil('main_page',
            (Route<dynamic> route) => false);
  }

  Future<Null> _showAlertDialog(String title, String content) {
    return showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
