import 'dart:convert';
import 'dart:async';
import 'package:attendances/model/attendance.dart';
import 'package:attendances/model/course.dart';
import 'package:attendances/model/course_attendances.dart';
import 'package:attendances/model/student.dart';
import 'package:http/http.dart' as http;
import 'package:quiver/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../model/attendance.dart';

class AttendanceRepository {
  Future<bool> saveAttendance(Attendance attendance) async {
    try {
      var response = await http.post(
          Uri.encodeFull(Constants.rootApi + '/generated-attendance/add'),
          headers: {"Accept": "application/json"},
          body: {'attendance': json.encode(attendance.toJSON())});
    } catch (e) {
      print("error ${e.toString()}");
      throw Exception("Error");
    }
    return true;
  }

  Future<List<CourseAttendances>> getStudentAttendances(String studentId) async {

    var response = await http.get(
        Uri.encodeFull(Constants.rootApi + '/attendance/$studentId'),
        headers: {
          "Accept": "application/json"
        });

    var responseData = jsonDecode(response.body);

    List<CourseAttendances> courseAttendancesList = List();
    for (var data in responseData['result']){
      var courseName = data[Constants.courseName];
      var courseAttendance = CourseAttendances(courseName);
      for (var attendance in data['attendances']){
        var courseDate = attendance[Constants.courseCreatedAt];
        var courseType = attendance[Constants.courseType];
        var courseNumber = attendance[Constants.courseNumber];
        var courseTeacher = attendance[Constants.courseTeacher];
        var course = Course(null, courseType, courseTeacher, null, courseDate, courseNumber);
        courseAttendance.addCourse(course);
      }
      courseAttendancesList.add(courseAttendance);
    }
    return courseAttendancesList;
  }

  Future<List<Attendance>> getGeneratedAttendances() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var teacherId = sharedPreferences.get(Constants.teacherId);

    var response = await http.get(
        Uri.encodeFull(Constants.rootApi + '/generated-attendance/$teacherId'),
        headers: {
          "Accept": "application/json"
        });

    var responseData = jsonDecode(response.body);

    var attendanceList = List<Attendance>();
    for (var data in responseData['result']) {
      attendanceList.add(Attendance.fromJSON(data));
    }
    return attendanceList;
  }


  Future<List<Student>> getStudentsAtCourse(String attendanceQR) async {
    return [];
  }
}
