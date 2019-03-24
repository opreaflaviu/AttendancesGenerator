import 'package:attendances/model/attendance.dart';
import 'package:attendances/model/student_attendance.dart';
import 'package:attendances/repository/attendance_repository.dart';
import 'package:attendances/utils/colors_constants.dart';
import 'package:attendances/utils/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StudentsAtCoursePage extends StatefulWidget {
  final Attendance _attendance;

  StudentsAtCoursePage(this._attendance);

  @override
  _StudentsAtCoursePageState createState() =>
      _StudentsAtCoursePageState(this._attendance);
}

class _StudentsAtCoursePageState extends State<StudentsAtCoursePage> {
  final Attendance _attendance;
  final _attendanceRepository = AttendanceRepository();

  _StudentsAtCoursePageState(this._attendance);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            _attendanceRepository.getStudentsAtCourse(_attendance.attendanceQr),
        initialData: [],
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Scaffold(
                body: Center(
                  child: Text('No internet connection'),
                ),
              );
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                print("Error: ${snapshot.error}");
                return Scaffold(
                  body: Center(
                    child: Text('An error was encountered'),
                  ),
                );
              } else
                return _displayList(snapshot.data);
          }
        });
  }

  Widget _displayList(dynamic data) => Scaffold(
          body: SafeArea(
        bottom: true,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: ColorsConstants.backgroundColorYellow,
              iconTheme: IconThemeData(color: Colors.black),
              expandedHeight: 250.0,
              elevation: 2.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  '${_attendance.courseName}  ${_attendance.courseType} ${_attendance.courseNumber}  Class ${_attendance.courseClass}',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                background: Center(
                  child: QrImage(
                    data: _attendance.attendanceQr,
                    size: 180.0,
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate(data
                    .map<Widget>((StudentAttendance studentAttendance) =>
                        studentInformationCard(studentAttendance))
                    .toList()))
          ],
        ),
      ));

  Widget studentInformationCard(StudentAttendance studentAttendance) {
    return Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black38))),
        child: ListTile(
            title: Row(
              children: <Widget>[
                Text(
                  '${studentAttendance.student.studentName}',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  ' (${studentAttendance.student.studentId})',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black87,),
                ),
              ],
            ),
            subtitle: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Row(children: <Widget>[
                    Text('Class ',
                        style:
                            TextStyle(fontSize: 16.0, color: Colors.black54)),
                    Text('${studentAttendance.student.studentClass}',
                        style: TextStyle(
                            fontSize: 16.0, color: ColorsConstants.customBlack))
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Row(children: <Widget>[
                    Text('Date ',
                        style:
                            TextStyle(fontSize: 16.0, color: Colors.black54)),
                    Text('${studentAttendance.eventCreatedAt.substring(0, 16)}',
                        style: TextStyle(
                            fontSize: 16.0, color: ColorsConstants.customBlack))
                  ]),
                ),
                GestureDetector(
                    onTap: () {
                      _showAlertDialog(context, 'Update or modify ',
                          studentAttendance.grade.grade)
                          .then((int grade) {
                        print("new grade: $grade");
                        _attendanceRepository.updateStudentGrade
                          (studentAttendance.attendanceQR, studentAttendance
                            .student.studentId, grade);
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Row(children: <Widget>[
                        Text('Grade ',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.black54)),
                        Text('${studentAttendance.grade.grade.toString()}',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: ColorsConstants.customBlack)),

                      ]),
                    ))
              ],
            )));
  }

  Future<int> _showAlertDialog(BuildContext context, String title, int grade) {
    var gradeController = TextEditingController();
    gradeController.text = grade.toString();
    return showDialog<int>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title,
                style: TextStyle(
                    fontSize: 20.0,
                    color: ColorsConstants.customBlack,
                    fontWeight: FontWeight.bold)),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Grade:',
                    style: TextStyle(
                        fontSize: 16.0, color: ColorsConstants.customBlack)),
                Container(
                  margin: EdgeInsets.only(left: 4.0),
                  width: 40.0,
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(signed:
                    true, decimal: true),
                    controller: gradeController,
                    decoration: InputDecoration(hintText: grade.toString(),
                    contentPadding: EdgeInsets.all(1.0)),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Save',
                      style: TextStyle(
                          fontSize: 16.0, color: ColorsConstants.customBlack)),
                  onPressed: () {
                    var newGrade = int.parse(gradeController.text);
                    Navigator.of(context).pop(newGrade);
                  }),
            ],
          );
        });
  }
}
