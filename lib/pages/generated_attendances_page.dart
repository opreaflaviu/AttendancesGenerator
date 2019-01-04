import 'package:attendances/model/attendance.dart';
import 'package:attendances/pages/students_at_course_page.dart';
import 'package:attendances/presenters/generated_attendances_presenter.dart';
import 'package:attendances/utils/colors_constants.dart';
import 'package:attendances/utils/custom_icons.dart';
import 'package:attendances/views/generated_attendance_view.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quiver/collection.dart';

class GeneratedAttendancesPage extends StatefulWidget {
  @override
  _GeneratedAttendancesPageState createState() =>
      _GeneratedAttendancesPageState();
}

class _GeneratedAttendancesPageState extends State<GeneratedAttendancesPage>
    implements GeneratedAttendancesView {
  GeneratedAttendancesPresenter _generatedAttendancesPresenter;
  List<Attendance> _generatedAttendanceList;
  bool _isFetching = false;

  _GeneratedAttendancesPageState() {
    _generatedAttendancesPresenter = GeneratedAttendancesPresenter(this);
    _generatedAttendanceList = List<Attendance>();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetching) {
      return SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return SafeArea(
          child: RefreshIndicator(
        child: ListView.builder(
            itemCount: _generatedAttendanceList == null
                ? 0
                : _generatedAttendanceList.length,
            itemBuilder: (context, index) {
              var attendance = _generatedAttendanceList.elementAt(index);
              return InkWell(
                onTap: () {

                  print("open: ${attendance.attendanceQR}");
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudentsAtCoursePage(attendance)));
                },
                child: Card(
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  elevation: 1.5,
                  color: ColorsConstants.backgroundColorBlue,
                  child: Container(
                    margin: EdgeInsets.only(top: 8.0, bottom: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          attendance.courseName,
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                          attendance.courseType == 'Laborator'
                                              ? CustomIcons.computer
                                              : CustomIcons.pen,
                                          size: 18.0,
                                          color: Colors.black38),
                                      Padding(
                                          padding: EdgeInsets.only(right: 8.0)),
                                      Text(
                                          "${attendance.courseType} ${attendance.courseNumber}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  ColorsConstants.ColorBlue)),
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.all(6.0)),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(CustomIcons.calendar,
                                          size: 18.0, color: Colors.black38),
                                      Padding(
                                          padding: EdgeInsets.only(right: 8.0)),
                                      Text(
                                          "${attendance.courseCreatedAt.substring(0, 10)}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  ColorsConstants.ColorBlue)),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.people,
                                          size: 18.0, color: Colors.black38),
                                      Padding(
                                          padding: EdgeInsets.only(right: 8.0)),
                                      Text("${attendance.courseClass}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  ColorsConstants.ColorBlue)),
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.all(6.0)),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.access_time,
                                          size: 18.0, color: Colors.black38),
                                      Padding(
                                          padding: EdgeInsets.only(right: 8.0)),
                                      Text(
                                          "${attendance.courseCreatedAt.substring(11, 16)}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  ColorsConstants.ColorBlue)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        onRefresh: _getAttendanceOnRefresh,
      ));
    }
  }

  @override
  void initState() {
    checkConnectivity();
    super.initState();
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

  openStudentListPage(Attendance attendance) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StudentsAtCoursePage(attendance)));
  }

  Future<bool> _getAttendanceOnRefresh() async {
    await new Future.delayed(Duration(seconds: 1));
    _getGeneratedAttendances();
    return true;
  }

  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        _isFetching = true;
      });
      _getGeneratedAttendances();
    } else {
      _showAlertDialog('No internet connection', 'Please connect wi-fi or mobile data');
    }
  }

  _getGeneratedAttendances() async {
    _generatedAttendancesPresenter.getGeneratedAttendances();
  }

  @override
  onLoadAttendancesComplete(List<Attendance> generatedAttendanceList) {
    setState(() {
      _generatedAttendanceList = generatedAttendanceList;
      _isFetching = false;
    });
  }

  @override
  onLoadAttendancesError() {
    _showAlertDialog('Error', 'Cannot fetch data');
  }
}
