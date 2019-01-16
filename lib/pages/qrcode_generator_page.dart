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
    return SafeArea(
      minimum: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
                decoration: new InputDecoration(
                    labelText: 'Course Name',
                    hintText: 'ex: OOP',
                    contentPadding: new EdgeInsets.only(top: 8.0),
                    labelStyle: new TextStyle(fontSize: 16.0)),
                style: new TextStyle(fontSize: 20.0, color: Colors.black),
                controller: _courseName),
            TextField(
                decoration: new InputDecoration(
                    labelText: 'Course Type',
                    hintText: 'ex: Laboratory',
                    contentPadding: new EdgeInsets.only(top: 8.0),
                    labelStyle: new TextStyle(fontSize: 16.0)),
                style: new TextStyle(fontSize: 20.0, color: Colors.black),
                controller: _courseType),
            TextField(
                decoration: new InputDecoration(
                    labelText: 'Course Class',
                    hintText: 'ex: 222',
                    contentPadding: new EdgeInsets.only(top: 8.0),
                    labelStyle: new TextStyle(fontSize: 16.0)),
                style: new TextStyle(fontSize: 20.0, color: Colors.black),
                controller: _courseClass),
            TextField(
                decoration: new InputDecoration(
                    labelText: 'Course number',
                    hintText: '1',
                    contentPadding: new EdgeInsets.only(top: 8.0),
                    labelStyle: new TextStyle(fontSize: 16.0)),
                style: new TextStyle(fontSize: 20.0, color: Colors.black),
                controller: _courseNumber),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    padding: new EdgeInsets.only(left: 32.0, right: 32.0),
                    child: new Text("Generate QR", textScaleFactor: 1.2),
                    onPressed: () {
                      _generateQR();
                    },
                    splashColor: ColorsConstants.backgroundColorYellow,
                    color: ColorsConstants.backgroundColorYellow,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                  ),
                  RaisedButton(
                    padding: new EdgeInsets.only(left: 32.0, right: 32.0),
                    child: new Text("   Clear QR    ", textScaleFactor: 1.2),
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
            qrWidgets(),
            saveButtonWidget()
          ],
        ),
      ),
    );
  }

  _generateQR() async {
    if (_courseName.text != '' &&
        _courseType.text != '' &&
        _courseNumber.text != '') {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      _teacherName = sharedPreferences.get(Constants.teacherName);
      _teacherId = sharedPreferences.get(Constants.teacherId);
      _courseCreatedAt = DateTime.now().toIso8601String();

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

  Widget qrWidgets() {
    if (_enableWidgets) {
      return Expanded(
          child: Center(
        widthFactor: 250.0,
        heightFactor: 250.0,
        child: RepaintBoundary(
          child: QrImage(
            data: _attendance.attendanceQR,
            size: 250.0,
          ),
        ),
      ));
    }

    return Padding(padding: new EdgeInsets.all(0.0));
  }

  Widget saveButtonWidget() {
    if (_enableWidgets) {
      return RaisedButton(
        padding: new EdgeInsets.only(left: 140.0, right: 140.0),
        child: new Text("Save QR", textScaleFactor: 1.2),
        onPressed: () {
          _saveQR();
        },
        splashColor: ColorsConstants.backgroundColorBlue,
        color: ColorsConstants.backgroundColorBlue,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
      );
    }

    return Padding(padding: new EdgeInsets.all(0.0));
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
