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
//    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//    var teacherId = sharedPreferences.get(Constants.teacherId);
//
//    var response = await http.get(
//        Uri.encodeFull(Constants.rootApi + '/generated-attendance/$teacherId'),
//        headers: {
//          "Accept": "application/json"
//        });
//
//    var responseData = jsonDecode(response.body);
//
//    var attendanceList = List<Attendance>();
//    for (var data in responseData['result']) {
//      attendanceList.add(Attendance.fromJSON(data));
//    }
//    return attendanceList;

    var attendanceList = [
      Attendance('IA', 'Seminar', '223', 'George', 'ppT0001', '2018-09-30 16:00:12', '1'),
      Attendance('Geometrie', 'Seminar', '223', 'Iancu', 'ppT0001', '2018-09-30 18:00:12', '1'),
      Attendance('IA', 'Laborator', '221', 'Ion', 'ppT0001', '2018-09-30 16:00:12', '1'),
      Attendance('OOP', 'Laborator', '233', 'George', 'ppT0001', '2018-10-11 10:05:12', '2'),
      Attendance('Geometrie', 'Laborator', '223', 'George', 'ppT0001', '2018-10-30 16:00:12', '4'),
    ];

    await Future.delayed(Duration(seconds: 5));

    return attendanceList;
  }


  Future<List<Student>> getStudentsAtCourse(String attendanceQR) async {
    var studentList = [
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
      Student('ofir1929', 'Oprea Flaviu', '223', ''),
      Student('grir1900', 'Gheorghe Radu', '212', ''),
    ];

//    await Future.delayed(Duration(seconds: 5));
    return studentList;
  }
}
