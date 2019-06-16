import 'package:attendances/model/attendance.dart';
import 'package:attendances/pages/students_at_course_page.dart';
import 'package:attendances/presenters/generated_attendances_presenter.dart';
import 'package:attendances/utils/colors_constants.dart';
import 'package:attendances/utils/custom_icons.dart';
import 'package:attendances/views/generated_attendance_view.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class GeneratedAttendancesPage extends StatefulWidget {
  final String course;
  GeneratedAttendancesPage(this.course);

  @override
  _GeneratedAttendancesPageState createState() =>
      _GeneratedAttendancesPageState(course);
}

class _GeneratedAttendancesPageState extends State<GeneratedAttendancesPage>
    implements GeneratedAttendancesView {
  GeneratedAttendancesPresenter _generatedAttendancesPresenter;
  List<Attendance> _generatedAttendanceList;
  bool _isFetching = false;
  String course;

  _GeneratedAttendancesPageState(this.course) {
    _generatedAttendancesPresenter = GeneratedAttendancesPresenter(this);
    _generatedAttendanceList = List<Attendance>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorsConstants.customBlack),
        backgroundColor: ColorsConstants.backgroundColorYellow,
        title: Text("Generated attendances",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0, color: ColorsConstants.customBlack)),
      ),
      body: _content(),
    );
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
            title: Text(title,
                style: TextStyle(
                    fontSize: 24.0,
                    color: ColorsConstants.customBlack,
                    fontWeight: FontWeight.bold)),
            content: Text(content,
                style: TextStyle(
                    fontSize: 20.0, color: ColorsConstants.customBlack)),
            actions: <Widget>[
              FlatButton(
                  child: Text('Ok',
                      style: TextStyle(
                          fontSize: 16.0, color: ColorsConstants.customBlack)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Widget _content() {
    if (_isFetching) {
      return SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      if (_generatedAttendanceList.isNotEmpty) {
        return _displayList();
      } else {
        return Center(
          child: Text("You have no courses for $course",
              style: TextStyle(
                  fontSize: 20.0, color: ColorsConstants.customBlack)
          ),
        );
      }
    }
  }

  Widget _displayList() {
    return SafeArea(
        child: RefreshIndicator(
      child: ListView.builder(
          itemCount: _generatedAttendanceList.length,
          itemBuilder: (context, index) {
            var attendance = _generatedAttendanceList.elementAt(index);
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            StudentsAtCoursePage(attendance)));
              },
              child: Card(
                margin: EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 0.0),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                elevation: 1.0,
                color: ColorsConstants.purple,
                child: Container(
                  margin: EdgeInsets.only(top: 8.0, bottom: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(attendance.courseName,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Divider(
                        color: ColorsConstants.customBlack,
                        height: 8.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                        attendance.courseType.startsWith('L') ||
                                                attendance.courseType
                                                    .startsWith('l')
                                            ? CustomIcons.computer
                                            : CustomIcons.pen,
                                        size: 18.0,
                                        color: ColorsConstants.customBlack),
                                    Padding(
                                        padding: EdgeInsets.only(right: 8.0)),
                                    Text(
                                        "${attendance.courseType} ${attendance.courseNumber}",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color:
                                                ColorsConstants.customBlack)),
                                  ],
                                ),
                                Padding(padding: EdgeInsets.all(6.0)),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(CustomIcons.calendar,
                                        size: 18.0,
                                        color: ColorsConstants.customBlack),
                                    Padding(
                                        padding: EdgeInsets.only(right: 8.0)),
                                    Text(
                                        "${attendance.courseCreatedAt.substring(0, 10)}",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color:
                                                ColorsConstants.customBlack)),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(Icons.people,
                                        size: 18.0,
                                        color: ColorsConstants.customBlack),
                                    Padding(
                                        padding: EdgeInsets.only(right: 8.0)),
                                    Text("${attendance.courseClass}",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color:
                                                ColorsConstants.customBlack)),
                                  ],
                                ),
                                Padding(padding: EdgeInsets.all(6.0)),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(Icons.access_time,
                                        size: 18.0,
                                        color: ColorsConstants.customBlack),
                                    Padding(
                                        padding: EdgeInsets.only(right: 8.0)),
                                    Text(
                                        "${attendance.courseCreatedAt.substring(11, 16)}",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color:
                                                ColorsConstants.customBlack)),
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
      _showAlertDialog(
          'No internet connection', 'Please connect wi-fi or mobile data');
    }
  }

  _getGeneratedAttendances() async {
    _generatedAttendancesPresenter.getGeneratedAttendances(course);
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
