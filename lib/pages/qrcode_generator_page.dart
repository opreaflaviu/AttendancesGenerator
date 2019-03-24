import 'package:attendances/model/attendance.dart';
import 'package:attendances/presenters/attendance_presenter.dart';
import 'package:attendances/views/attendance_body_view.dart';
import 'package:quiver/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../utils/constants.dart';
import '../utils/colors_constants.dart';

class QRCodeGeneratorPage extends StatefulWidget {
  @override
  QRCodeGeneratorPageState createState() => QRCodeGeneratorPageState();
}

class QRCodeGeneratorPageState extends State<QRCodeGeneratorPage>
    implements AttendanceBodyView {
  TextEditingController _courseName = new TextEditingController();
  TextEditingController _courseType = new TextEditingController();
  TextEditingController _courseNumber = new TextEditingController();
  TextEditingController _courseClass = new TextEditingController();
  var _teacherId = '';
  var _teacherName = '';
  var _courseCreatedAt = '';

  var _enableWidgets = false;
  Attendance _attendance;

  AttendancePresenter _attendancePresenter;

  QRCodeGeneratorPageState() {
    _attendancePresenter = AttendancePresenter(this);
    _attendance = Attendance('', '', '', '', '', '', '');
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    var _widthDP = _mediaQuery.size.width;
    var _heightDP = _mediaQuery.size.height;

    return SafeArea(
        minimum: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                    cursorColor: ColorsConstants.customBlack,
                    decoration: new InputDecoration(
                        labelText: 'Course Name',
                        hintText: 'ex: OOP',
                        contentPadding:
                            new EdgeInsets.only(bottom: 2.0, top: 8.0),
                        hintStyle: TextStyle(
                            fontSize: 16.0, color: ColorsConstants.customBlack),
                        labelStyle: TextStyle(
                            fontSize: 16.0,
                            color: ColorsConstants.customBlack)),
                    style: new TextStyle(fontSize: 16.0, color: Colors.black),
                    controller: _courseName),
                TextField(
                    cursorColor: ColorsConstants.customBlack,
                    decoration: new InputDecoration(
                        labelText: 'Course Type',
                        hintText: 'ex: Laboratory',
                        contentPadding:
                            new EdgeInsets.only(bottom: 2.0, top: 8.0),
                        hintStyle: TextStyle(
                            fontSize: 16.0, color: ColorsConstants.customBlack),
                        labelStyle: TextStyle(
                            fontSize: 16.0,
                            color: ColorsConstants.customBlack)),
                    style: new TextStyle(fontSize: 16.0, color: Colors.black),
                    controller: _courseType),
                TextField(
                    cursorColor: ColorsConstants.customBlack,
                    decoration: new InputDecoration(
                        labelText: 'Course Class',
                        hintText: 'ex: 222',
                        contentPadding:
                            new EdgeInsets.only(bottom: 2.0, top: 8.0),
                        hintStyle: TextStyle(
                            fontSize: 16.0, color: ColorsConstants.customBlack),
                        labelStyle: TextStyle(
                            fontSize: 16.0,
                            color: ColorsConstants.customBlack)),
                    style: new TextStyle(fontSize: 16.0, color: Colors.black),
                    controller: _courseClass),
                TextField(
                    cursorColor: ColorsConstants.customBlack,
                    decoration: new InputDecoration(
                        labelText: 'Course number',
                        hintText: '1',
                        contentPadding:
                            new EdgeInsets.only(bottom: 2.0, top: 8.0),
                        hintStyle: TextStyle(
                            fontSize: 16.0, color: ColorsConstants.customBlack),
                        labelStyle: new TextStyle(
                            fontSize: 16.0,
                            color: ColorsConstants.customBlack)),
                    style: new TextStyle(fontSize: 16.0, color: Colors.black),
                    controller: _courseNumber),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        padding: new EdgeInsets.fromLTRB(
                            _widthDP * 0.05,
                            _heightDP * 0.01,
                            _widthDP * 0.05,
                            _heightDP * 0.01),
                        child: new Text("Generate QR",
                            style: TextStyle(
                                color: ColorsConstants.customBlack,
                                fontSize: 16.0)),
                        onPressed: _generateQR,
                        splashColor: ColorsConstants.backgroundColorYellow,
                        color: ColorsConstants.backgroundColorYellow,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      ),
                      RaisedButton(
                        padding: new EdgeInsets.fromLTRB(
                            _widthDP * 0.08,
                            _heightDP * 0.01,
                            _widthDP * 0.09,
                            _heightDP * 0.01),
                        child: new Text("Clear QR",
                            style: TextStyle(
                                color: ColorsConstants.customBlack,
                                fontSize: 16.0)),
                        onPressed: () {
                          _clearQR();
                        },
                        splashColor: ColorsConstants.backgroundColorYellow,
                        color: ColorsConstants.backgroundColorYellow,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      ),
                    ],
                  ),
                ),
                qrWidgets(_widthDP, _heightDP),
                saveButtonWidget(_widthDP, _heightDP)
              ],
            ),
          ),
        );
  }

  _generateQR() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_courseName.text != '' &&
        _courseType.text != '' &&
        _courseNumber.text != '') {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      _teacherName = sharedPreferences.get(Constants.teacherName);
      _teacherId = sharedPreferences.get(Constants.teacherId);
      _courseCreatedAt = DateTime.now().toIso8601String().substring(0, 19);

      setState(() {
        _attendance = Attendance(
            _courseName.text,
            _courseType.text,
            _courseClass.text,
            _teacherName,
            _teacherId,
            _courseCreatedAt,
            _courseNumber.text);
        _enableWidgets = true;
      });
    } else
      _showAlertDialog('Atention!', 'You must fill all fields');
  }

  _saveQR() async {
    _attendancePresenter.saveAttendance(_attendance);
  }

  _clearQR() {
    FocusScope.of(context).requestFocus(new FocusNode());
    _courseName.clear();
    _courseType.clear();
    _courseNumber.clear();
    _courseClass.clear();
    setState(() {
      _enableWidgets = false;
    });
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

  Widget qrWidgets(double widthDP, double heightDP) {
    if (_enableWidgets) {
      print("${_attendance.toString()},  ${_attendance.attendanceQR}");
      return Expanded(
          child: Center(
            widthFactor: widthDP * 0.5,
            heightFactor: widthDP * 0.5,
            child: RepaintBoundary(
              child: QrImage(
                data: _attendance.toString(),
                size: widthDP * 0.5,
              ),
            ),
          ));
    }

    return Padding(padding: new EdgeInsets.all(0.0));
  }

  Widget saveButtonWidget(double widthDP, double heightDP) {
    if (_enableWidgets) {
      return RaisedButton(
        padding: new EdgeInsets.fromLTRB(
            widthDP * 0.35, heightDP * 0.01, widthDP * 0.35, heightDP * 0.01),
        child: new Text("Save QR",
            style:
                TextStyle(color: ColorsConstants.customBlack, fontSize: 16.0)),
        onPressed: () {
          _saveQR();
        },
        splashColor: ColorsConstants.backgroundColorBlue,
        color: ColorsConstants.backgroundColorBlue,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
      );
    }

    return Container();
  }

  @override
  void onLoadStudentAttendancesComplete(
      Multimap<String, String> attendanceList) {
    // TODO: implement onLoadStudentAttendancesComplete
  }

  @override
  void onLoadStudentAttendancesError() {
    // TODO: implement onLoadStudentAttendancesError
  }

  @override
  void onSaveAttendanceComplete() {
    _showAlertDialog('Done', 'Generated attendance was saved');
  }

  @override
  void onSaveAttendancesError() {
    _showAlertDialog('Error', 'Generated attendance was not saved');
  }
}
