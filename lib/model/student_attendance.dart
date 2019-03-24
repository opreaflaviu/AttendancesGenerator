import 'package:attendances/model/course.dart';
import 'package:attendances/model/grade.dart';
import 'package:attendances/model/student.dart';
import 'package:attendances/utils/constants.dart';

class StudentAttendance {
  final String _eventCreatedAt;
  final String _attendanceQR;
  final Course _course;
  final Student _student;
  Grade grade;


  StudentAttendance(
    this._eventCreatedAt,
    this._course,
    this._student,
    this.grade,
    this._attendanceQR,
  );

  Student get student => _student;

  Course get course => _course;

  String get attendanceQR => _attendanceQR;

  String get eventCreatedAt => _eventCreatedAt;

  StudentAttendance.fromJson(Map map):
    this._eventCreatedAt = map[Constants.eventCreatedAt],
    this._student = Student.fromJson(map['student']),
    this._course = Course.fromJson(map['course']),
    this.grade = Grade.fromJson(map[Constants.grade]),
    this._attendanceQR = map[Constants.attendanceQR];
}
