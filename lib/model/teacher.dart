import 'package:attendances/utils/constants.dart';


class Teacher {
  final String _teacherId;
  final String _teacherName;
  final String _teacherPassword;

  Teacher(this._teacherId, this._teacherName, this._teacherPassword);

  String get teacherId => _teacherId;

  String get teacherName => _teacherName;

  String get teacherPassword => _teacherPassword;

  Teacher.fromMap(Map map):
    this._teacherName = map[Constants.teacherName],
    this._teacherId = map[Constants.teacherId],
    this._teacherPassword = map[Constants.teacherPassword];

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[Constants.teacherName] = this._teacherName;
    map[Constants.teacherId] = this._teacherId;
    map[Constants.teacherPassword] = this._teacherPassword;
    return map;
  }

  @override
  String toString() => _teacherName + " " + _teacherId + " " + _teacherPassword;

}