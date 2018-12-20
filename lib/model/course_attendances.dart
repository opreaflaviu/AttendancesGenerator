import 'course.dart';

class CourseAttendances {
  final _courseName;
  List<Course> _attendanceList;

  CourseAttendances(this._courseName) {
    this._attendanceList = List();
  }

  get courseName => _courseName;

  List<Course> get attendanceList => _attendanceList;

  addCourse(Course course) {
    this._attendanceList.add(course);
  }

  getCourseData(int index) => this._attendanceList.elementAt(index).createdAt;

  getCourseType(int index) => this._attendanceList.elementAt(index).type;

  getCourseNumber(int index) => this._attendanceList.elementAt(index).number;

  @override
  String toString() {
    return 'CourseAttendances{_courseName: $_courseName, _attendanceList: $_attendanceList}';
  }


}