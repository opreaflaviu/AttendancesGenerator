import 'package:attendances/utils/constants.dart';


class Student {
  final String _studentId;
  final String _studentName;
  final int _studentClass;
  final String _studentPassword;

  Student(this._studentId, this._studentName, this._studentClass, this._studentPassword);

  get studentId => this._studentId;

  get studentName => this._studentName;

  get studentClass => this._studentClass;

  get studentPassword => _studentPassword;

  Student.fromMap(Map map):
    this._studentName = map[Constants.studentName],
    this._studentId = map[Constants.studentId],
    this._studentClass = map[Constants.studentClass],
    this._studentPassword = map[Constants.studentPassword];

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[Constants.studentName] = this._studentName;
    map[Constants.studentId] = this._studentId;
    map[Constants.studentClass] = this._studentClass;
    map[Constants.studentPassword] = this._studentPassword;
    return map;
  }

  @override
  String toString() => _studentName + " " + _studentId + " " + _studentClass.toString();
}