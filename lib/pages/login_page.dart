import 'package:flutter/material.dart';
import 'package:attendances/repository/teacher_repository.dart';
import 'package:attendances/utils/colors_constants.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  static final TextEditingController _name = TextEditingController();
  static final TextEditingController _id = TextEditingController();
  static final TextEditingController _password = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  bool passwordVisibility = true;

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    var _widthDP = _mediaQuery.size.width;
    var _heightDP = _mediaQuery.size.height;

    return Scaffold(
        backgroundColor: ColorsConstants.backgroundColorYellow,
        key: _scaffoldState,
        appBar: AppBar(
            title: Text("Login",
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
                  contentPadding: EdgeInsets.all(0.0),
                  leading:
                      Icon(Icons.person, color: ColorsConstants.customBlack),
                  title: TextField(
                      cursorColor: ColorsConstants.customBlack,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        contentPadding: EdgeInsets.only(bottom: 4.0, top: 8.0),
                        hintStyle: TextStyle(
                            fontSize: 16.0, color: ColorsConstants.customBlack),
                        labelStyle: TextStyle(
                            fontSize: 16.0, color: ColorsConstants.customBlack),
                      ),
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      controller: _name),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  leading:
                      Icon(Icons.label, color: ColorsConstants.customBlack),
                  title: TextField(
                      cursorColor: ColorsConstants.customBlack,
                      decoration: InputDecoration(
                          hintText: 'Number',
                          contentPadding:
                              EdgeInsets.only(bottom: 4.0, top: 8.0),
                          hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: ColorsConstants.customBlack),
                          labelStyle: TextStyle(
                              fontSize: 16.0,
                              color: ColorsConstants.customBlack)),
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      controller: _id),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  leading: Icon(Icons.lock, color: ColorsConstants.customBlack),
                  title: TextField(
                      cursorColor: ColorsConstants.customBlack,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          contentPadding:
                              EdgeInsets.only(bottom: 4.0, top: 8.0),
                          hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: ColorsConstants.customBlack),
                          labelStyle: TextStyle(
                              fontSize: 16.0,
                              color: ColorsConstants.customBlack),
                          suffix: GestureDetector(
                            child: Icon(this.passwordVisibility
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onTap: () {
                              setState(() {
                                this.passwordVisibility =
                                    !this.passwordVisibility;
                              });
                            },
                          )),
                      style: TextStyle(
                          fontSize: 16.0, color: ColorsConstants.customBlack),
                      obscureText: this.passwordVisibility,
                      controller: _password),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      highlightColor: ColorsConstants.backgroundColor,
                      padding: EdgeInsets.fromLTRB(_widthDP * 0.10,
                          _heightDP * 0.01, _widthDP * 0.10, _heightDP * 0.01),
                      child: Text("Back",
                          style: TextStyle(
                              color: ColorsConstants.customBlack,
                              fontSize: 16.0)),
                      onPressed: (() => _onBackClick(context)),
                      splashColor: Colors.white,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                    RaisedButton(
                      highlightColor: ColorsConstants.backgroundColor,
                      padding: EdgeInsets.fromLTRB(_widthDP * 0.10,
                          _heightDP * 0.01, _widthDP * 0.10, _heightDP * 0.01),
                      child: Text("Login",
                          style: TextStyle(
                              color: ColorsConstants.customBlack,
                              fontSize: 16.0)),
                      onPressed: _onLoginClick,
                      splashColor: Colors.white,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
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
    var response =
        TeacherRepository().loginTeacher(_name.text, _password.text, _id.text);
    response.then((result) {
      _navigateToMainPage();
    }).catchError((error) {
      if (error.runtimeType.toString() == 'SocketException') {
        _showAlertDialog('Error', 'Cannot connect to server');
      }
      _showAlertDialog('Error', error.toString());
    });
  }

  void _navigateToMainPage() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('main_page', (Route<dynamic> route) => false);
  }

  Future<Null> _showAlertDialog(String title, String content) {
    return showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title,
                style: TextStyle(
                    fontSize: 24.0, color: ColorsConstants.customBlack,
                    fontWeight: FontWeight.bold)),
            content: Text(content,
                style: TextStyle(
                    fontSize: 20.0, color: ColorsConstants.customBlack)),
            actions: <Widget>[
              FlatButton(
                  child: Text('Ok',
                      style: TextStyle(
                          fontSize: 16.0, color: ColorsConstants.customBlack)),
                  onPressed: (){
                    Navigator.of(context).pop();
                  }
              ),
            ],
          );
        }
    );
  }
}
