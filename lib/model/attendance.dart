import 'package:attendances/utils/constants.dart';

class Attendance {

  final String _courseName;
  final String _courseType;
  final String _courseTeacher;
  final String _courseTeacherId;
  final String _courseCreatedAt;
  final String _courseNumber;
  final String _courseClass;

  Attendance(this._courseName, this._courseType, this._courseClass, this._courseTeacher, this._courseTeacherId, this._courseCreatedAt, this._courseNumber);

  String get courseNumber => _courseNumber;

  String get courseCreatedAt => _courseCreatedAt;

  String get courseTeacherId => _courseTeacherId;

  String get courseTeacher => _courseTeacher;

  String get courseType => _courseType;

  String get courseName => _courseName;

  String get courseClass => _courseClass;

  String get attendanceQR => "$_courseName + $_courseType + $_courseClass + $_courseTeacher' + $_courseTeacherId + $_courseCreatedAt + $_courseNumber";

  Map<String, dynamic> toJSON() {
    var map = Map<String, dynamic>();
    map[Constants.courseName] = this._courseName;
    map[Constants.courseType] = this._courseType;
    map[Constants.courseClass] = this._courseClass;
    map[Constants.courseTeacher] = this._courseTeacher;
    map[Constants.courseTeacherId] = this._courseTeacherId;
    map[Constants.courseCreatedAt] = this._courseCreatedAt;
    map[Constants.courseNumber] = this._courseNumber;
    map[Constants.attendanceQR] = this.attendanceQR;

    return map;
  }

  Attendance.fromJSON(Map attendance):
    this._courseName = attendance[Constants.courseName],
    this._courseType = attendance[Constants.courseType],
    this._courseClass = attendance[Constants.courseClass],
    this._courseTeacher = attendance[Constants.courseTeacher],
    this._courseTeacherId = attendance[Constants.courseTeacherId],
    this._courseCreatedAt = attendance[Constants.courseCreatedAt].toString().substring(0, 16),
    this._courseNumber = attendance[Constants.courseNumber];

}