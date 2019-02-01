import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:attendances/utils/colors_constants.dart';
import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _connSub;

  _LandingPageState() {
    _connectivity = Connectivity();
  }

  void initState() {
    super.initState();
    _connSub =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _showSnackBar(result);
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
      body: Container(
          padding: new EdgeInsets.symmetric(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Center(
                    child: Image(
                  image:
                      AssetImage('assets/images/AttendancesGeneratorLogo.png'),
                  width: 300,
                  height: 300,
                )),
                RaisedButton(
                  elevation: 2.0,
                  padding: EdgeInsets.fromLTRB(_widthDP * 0.40,
                      _heightDP * 0.02, _widthDP * 0.40, _heightDP * 0.02),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: ColorsConstants.customBlack, fontSize: 20.0),
                  ),
                  onPressed: (() =>
                      Navigator.of(context).pushNamed('login_page')),
                  splashColor: Colors.white,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                RaisedButton(
                  elevation: 2.0,
                  padding: EdgeInsets.fromLTRB(_widthDP * 0.37,
                      _heightDP * 0.02, _widthDP * 0.37, _heightDP * 0.02),
                  child: Text(
                    "Register",
                    style: TextStyle(
                        color: ColorsConstants.customBlack, fontSize: 20.0),
                  ),
                  onPressed: (() =>
                      Navigator.of(context).pushNamed('register_page')),
                  splashColor: Colors.white,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
                Padding(padding: EdgeInsets.only(top: 50.0)),
              ],
            ),
          )),
    );
  }

  void _showSnackBar(var snackBarText) {
    _scaffoldState.currentState.showSnackBar(new SnackBar(
        content: Padding(
      padding: EdgeInsets.only(left: 32.0, top: 4.0, bottom: 6.0),
      child: Text(
        snackBarText != ConnectivityResult.none ? "Connected" : "No Connection",
        style: TextStyle(fontSize: 16.0),
      ),
    )));
  }

  @override
  void dispose() {
    _connSub?.cancel();
    super.dispose();
  }

  Future<bool> getFromSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var teacherName = sharedPreferences.getString(Constants.teacherName);
    var teacherNumber = sharedPreferences.getString(Constants.teacherId);

    return teacherName != null && teacherNumber != null;
  }
}
