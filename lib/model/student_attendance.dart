import 'package:attendances/model/course.dart';
import 'package:attendances/model/student.dart';
import 'package:attendances/utils/constants.dart';

class StudentAttendance {
  final String _eventCreatedAt;
  final String _attendanceQR;
  final Course _course;
  final Student _student;

  StudentAttendance(
    this._eventCreatedAt,
    this._course,
    this._student,
    this._attendanceQR,
  );

  Student get student => _student;

  Course get course => _course;

  String get attendanceQR => _attendanceQR;

  String get eventCreatedAt => _eventCreatedAt;

  StudentAttendance.fromJSON(Map map):
    this._eventCreatedAt = map[Constants.eventCreatedAt],
    this._student = Student.fromMap(map['student']),
    this._course = Course.fromJSON(map['course']),
    this._attendanceQR = map[Constants.attendanceQR];
}
