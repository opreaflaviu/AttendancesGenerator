import 'package:attendances/model/attendance.dart';
import 'package:attendances/model/student.dart';
import 'package:attendances/repository/attendance_repository.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
//
//class StudentsAtCoursePage extends StatefulWidget {
//  final attendance;
//
//  StudentsAtCoursePage(this.attendance);
//
//  @override
//  _StudentsAtCoursePageState createState() =>
//      _StudentsAtCoursePageState(this.attendance);
//
//}

class StudentsAtCoursePage extends StatelessWidget {

  final Attendance _attendance;
  final _attendanceRepository = AttendanceRepository();

  StudentsAtCoursePage(this._attendance);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _attendanceRepository.getStudentsAtCourse(_attendance.attendanceQR),
        initialData: [],
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(
                  child: Text('An error was encountered'),
                );
              else
                return _displayList(snapshot.data);
          }
        }
    );
  }

  Widget _displayList(dynamic data) =>
      Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              flexibleSpace: Flexible(
                  child: Column(
                    children: <Widget>[
                      QrImage(
                        data: _attendance.attendanceQR,
                        size: 100.0,
                      ),
                      Padding(padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Text('${_attendance.courseName} ${_attendance.courseType} ${_attendance.courseNumber}'),)
                    ],
                  )
              ),

            ),
            SliverList(
                delegate: SliverChildListDelegate(
                    data.map<Widget>((Student student) =>
                        Card(child: Text(student.studentName))
                    ).toList()
                )
            )
          ],
        ),
      );


}