import 'package:attendances/utils/constants.dart';


class Student {
  final String _studentId;
  final String _studentName;
  final String _studentClass;

  Student(this._studentId, this._studentName, this._studentClass);

  get studentId => this._studentId;

  get studentName => this._studentName;

  get studentClass => this._studentClass;

  Student.fromJson(Map map):
    this._studentName = map[Constants.studentName],
    this._studentId = map[Constants.studentId],
    this._studentClass = map[Constants.studentClass];

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map[Constants.studentName] = this._studentName;
    map[Constants.studentId] = this._studentId;
    map[Constants.studentClass] = this._studentClass;
    return map;
  }

  @override
  String toString() => _studentName + " " + _studentId + " " + _studentClass.toString();
}