import 'package:attendances/model/attendance.dart';
import 'package:attendances/model/student.dart';
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
            _attendanceRepository.getStudentsAtCourse(_attendance.attendanceQR),
        initialData: [],
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator()
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError)
                return Scaffold(
                  body: Center(
                    child: Text('An error was encountered'),
                  ),
                );
              else
                return _displayList(snapshot.data);
          }
        });
  }

  Widget _displayList(dynamic data) =>
      Scaffold(
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
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                  background: Center(
                    child: QrImage(
                      data: _attendance.attendanceQR,
                      size: 180.0,
                    ),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate(data
                      .map<Widget>((Student student) =>
                          studentInformationCard(student))
                      .toList()))
            ],
          ),
        )
      );


  Widget studentInformationCard(Student student){
    return Card(
        shape:  new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        margin: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        elevation: 1.0,
        color: ColorsConstants.backgroundColorBlue,
        child: Padding(padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${student.studentName}',
                style: TextStyle(fontSize: 18.0, color: Colors.black87, fontWeight: FontWeight.bold),),
              Padding(padding: EdgeInsets.all(4.0)),
              Row(
                children: <Widget>[
                  Row(
                      children: <Widget>[
                        Text('Id ', style: TextStyle(fontSize: 16.0, color: Colors.black54)),
                        Text('${student.studentId}', style: TextStyle(fontSize: 16.0, color: ColorsConstants.ColorBlue)),
                      ]
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  Row(
                      children: <Widget>[
                        Text('Class ',style: TextStyle(fontSize: 16.0, color: Colors.black54)),
                        Text('${student.studentClass}', style: TextStyle(fontSize: 16.0, color: ColorsConstants.ColorBlue))
                      ]
                  ),
                ],
              )
            ],
          ),
        )
    );
  }

}
