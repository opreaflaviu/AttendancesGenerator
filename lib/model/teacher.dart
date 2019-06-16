import 'package:attendances/utils/constants.dart';

class Teacher {
  final String _teacherId;
  final String _teacherName;
  final String _teacherPassword;
  List<String> _coursesList;

  Teacher(this._teacherId, this._teacherName, this._teacherPassword) {
    _coursesList = [];
  }

  Teacher.withCourses(this._teacherId, this._teacherName, this._teacherPassword,
      this._coursesList);

  String get teacherId => _teacherId;

  String get teacherName => _teacherName;

  String get teacherPassword => _teacherPassword;

  List<String> get coursesList => _coursesList;

  set coursesList(List<String> courses) {
    _coursesList = courses;
  }

  Teacher.fromJson(Map map):
    this._teacherName = map[Constants.teacherName],
    this._teacherId = map[Constants.teacherId],
    this._teacherPassword = map[Constants.teacherPassword],
    this._coursesList = map[Constants.teacherCourses];

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map[Constants.teacherName] = this._teacherName;
    map[Constants.teacherId] = this._teacherId;
    map[Constants.teacherPassword] = this._teacherPassword;
    map[Constants.teacherCourses] = this._coursesList;
    return map;
  }

  @override
  String toString() => _teacherName + " " + _teacherId + " " + _teacherPassword;
}