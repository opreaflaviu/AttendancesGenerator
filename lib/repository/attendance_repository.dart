import 'dart:async';
import 'dart:convert';

import 'package:attendances/model/attendance.dart';
import 'package:attendances/model/course.dart';
import 'package:attendances/model/course_attendances.dart';
import 'package:attendances/model/student_attendance.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/attendance.dart';
import '../utils/constants.dart';

class AttendanceRepository {
  Future<bool> saveAttendance(Attendance attendance) async {

    var response = await http.post(
        Uri.encodeFull(Constants.rootApi + '/generated-attendance/add'),
        headers: {"Accept": "application/json"},
        body: {'attendance': json.encode(attendance.toJson())});

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData['result'] == 'true')
        return true;
      else
        return false;
    } else {
      throw Exception("Error");
    }
  }

  Future<List<CourseAttendances>> getStudentAttendances(String studentId) async {

    var response = await http.get(
        Uri.encodeFull(Constants.rootApi + '/attendance/$studentId'),
        headers: {
          "Accept": "application/json"
        });

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      List<CourseAttendances> courseAttendancesList = List();
      for (var data in responseData['result']) {
        var courseName = data[Constants.courseName];
        var courseAttendance = CourseAttendances(courseName);
        for (var attendance in data['attendances']) {
          var courseDate = attendance[Constants.courseCreatedAt];
          var courseType = attendance[Constants.courseType];
          var courseNumber = int.parse(attendance[Constants.courseNumber]);
          var courseTeacher = attendance[Constants.courseTeacher];
          var course = Course(null, courseType, courseTeacher, null, courseDate, courseNumber);
          courseAttendance.addCourse(course);
        }
        courseAttendancesList.add(courseAttendance);
      }
      return courseAttendancesList;
    } else {
      throw Exception("Error");
    }
  }

  Future<List<Attendance>> getGeneratedAttendances(String course) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var teacherId = sharedPreferences.get(Constants.teacherId);

    var response = await http.get(
        Uri.encodeFull(Constants.rootApi + '/generated-attendance/$teacherId/$course'),
        headers: {
          "Accept": "application/json"
        });

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      var attendanceList = List<Attendance>();
      for (var data in responseData['result']) {
        attendanceList.add(Attendance.fromJson(data));
      }
      return attendanceList;
    } else {
      throw Exception("Error");
    }
  }


  Future<List<StudentAttendance>> getStudentsAtCourse(String attendanceQR) async {
    var response = await http.get(
        Uri.encodeFull(Constants.rootApi + '/attendance/at-course/$attendanceQR'),
        headers: {
          "Accept": "application/json"
        });

    if (response.statusCode == 200) {
      List<StudentAttendance> studentAttendanceList = List();

      var responseData = jsonDecode(response.body);
      for (var data in responseData['result']) {
        studentAttendanceList.add(StudentAttendance.fromJson(data));
      }
      return studentAttendanceList;

    } else {
      throw Exception("Error");
    }
  }
  
  Future<bool> updateStudentGrade(String attendanceQR, String studentId, int
  grade) async {
    var response = await http.patch(
      Uri.encodeFull(Constants.rootApi + '/attendance/update-student-attendance'),
      headers: {
        "Accept": "application/json"
      },
      body: {
        Constants.attendanceQR: "$attendanceQR",
        Constants.studentId: "$studentId",
        Constants.grade: "$grade"
      }
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var status = responseData['result'];
      if (status == 'true') {
        return true;
      } else {
        throw Exception("Error");
      }

    } else {
      throw Exception("Error");
    }
  }

  Future<bool> deleteGeneratedAttendance(Attendance attendance) async {
    var response = await http.post(
        Uri.encodeFull(Constants.rootApi + '/generated-attendance/remove'),
        headers: {"Accept": "application/json"},
        body: {'attendanceQR': attendance.attendanceQR}
        );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData['deletedCount'] == 1)
        return true;
      else
        return false;
    } else {
      throw Exception("Error");
    }
  }
}
