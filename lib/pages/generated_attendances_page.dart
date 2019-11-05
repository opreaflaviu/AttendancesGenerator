import 'package:attendances/blocs/bloc_generated_attendances_page.dart';
import 'package:attendances/blocs/bloc_provider/bloc_provider.dart';
import 'package:attendances/model/attendance.dart';
import 'package:attendances/pages/students_at_course_page.dart';
import 'package:attendances/utils/colors_constants.dart';
import 'package:attendances/utils/custom_icons.dart';
import 'package:flutter/material.dart';

class GeneratedAttendancesPage extends StatefulWidget {
  final String course;
  GeneratedAttendancesPage(this.course);

  @override
  _GeneratedAttendancesPageState createState() =>
      _GeneratedAttendancesPageState(course);
}

class _GeneratedAttendancesPageState extends State<GeneratedAttendancesPage>{
  String course;
  var blocGeneratedAttendancesPage;

  _GeneratedAttendancesPageState(this.course);

  @override
  void initState() {
    blocGeneratedAttendancesPage = BlocProvider.of<BlocGeneratedAttendancesPage>(context);
    blocGeneratedAttendancesPage.fetchGeneratedAttendances(course);
    super.initState();
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

  Future<bool> _showAlertDialog(String title, String content) {
    return showDialog<bool>(
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
                  child: Text('No',
                      style: TextStyle(
                          fontSize: 16.0, color: ColorsConstants.customBlack)),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  }),
              FlatButton(
                  color: ColorsConstants.backgroundColorYellow,
                  child: Text('Yes',
                      style: TextStyle(
                          fontSize: 16.0, color: ColorsConstants.customBlack)),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  }),
            ],
          );
        });
  }

  Widget _content() {
    return StreamBuilder<bool>(
      stream: blocGeneratedAttendancesPage.getIsFetching(),
        builder: (BuildContext buildContext, AsyncSnapshot<bool> snapshot) {
        print("snapshot.data: ${snapshot.data}");
          if (snapshot.hasData) {
            if (snapshot.data) {
              return SafeArea(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return _displayList();
            }
          } else {
            return SafeArea(
              child: Center()
            );
          }
        }
    );
  }

  Widget _displayList() {
    return SafeArea(
        minimum: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: RefreshIndicator(
      child: StreamBuilder<List<Attendance>>(
        stream: blocGeneratedAttendancesPage.getGeneratedAttendances(),
        builder: (BuildContext buildContext, AsyncSnapshot<List<Attendance>> snapshot){
          if (snapshot.hasData) {
            var generatedAttendanceList = snapshot.data;
            return ListView.builder(
                itemCount: generatedAttendanceList.length,
                itemBuilder: (context, index) {
                  var attendance = generatedAttendanceList.elementAt(index);
                  return GestureDetector(
                      key: Key(attendance.toString()),
                      child: InkWell(
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
                          color: ColorsConstants.backgroundColorPurple,
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
                                  thickness: 0.5,
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
                      ),
                      onLongPress: () {
                        _showAlertDialog(
                            "Remove course",
                            "Are you sure you want to remove this course with all attendances?"
                        ).then((bool canBeRemoved) {
                          if (canBeRemoved) {
                            _deleteGeneratedAttendance();
                          }
                        });
                      },
                  );
                });
          } else {
            return Center(
              child: Text("You have no courses for $course",
                  style: TextStyle(
                      fontSize: 20.0, color: ColorsConstants.customBlack)
              ),
            );
          }
        }
      ),
      onRefresh: _getAttendanceOnRefresh
    ));
  }

  _deleteGeneratedAttendance() {

  }

  Future<bool> _getAttendanceOnRefresh() async {
    await new Future.delayed(Duration(seconds: 1));
    blocGeneratedAttendancesPage.fetchGeneratedAttendances(course);
    return true;
  }
}
