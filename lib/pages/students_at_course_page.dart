import 'package:attendances/model/attendance.dart';
import 'package:attendances/model/student.dart';
import 'package:attendances/model/student_attendance.dart';
import 'package:attendances/repository/attendance_repository.dart';
import 'package:attendances/utils/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StudentsAtCoursePage extends StatelessWidget {
  final Attendance _attendance;
  final _attendanceRepository = AttendanceRepository();

  StudentsAtCoursePage(this._attendance);

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
            title: Text(
              '${studentAttendance.student.studentName}',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Row(children: <Widget>[
                      Text('Id ',
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.black54)),
                      Text('${studentAttendance.student.studentId}',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: ColorsConstants.ColorBlue)),
                    ])),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(children: <Widget>[
                    Text('Class ',
                        style:
                            TextStyle(fontSize: 16.0, color: Colors.black54)),
                    Text('${studentAttendance.student.studentClass}',
                        style: TextStyle(
                            fontSize: 16.0, color: ColorsConstants.ColorBlue))
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(children: <Widget>[
                    Text('Date ',
                        style:
                            TextStyle(fontSize: 16.0, color: Colors.black54)),
                    Text('${studentAttendance.eventCreatedAt.substring(0, 16)}',
                        style: TextStyle(
                            fontSize: 16.0, color: ColorsConstants.ColorBlue))
                  ]),
                ),
              ],
            )));
  }
}
