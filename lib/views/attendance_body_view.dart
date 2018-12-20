import 'package:quiver/collection.dart';

abstract class AttendanceBodyView {
  void onSaveAttendanceComplete();
  void onSaveAttendancesError();

  void onLoadStudentAttendancesComplete(Multimap<String, String> attendanceList);
  void onLoadStudentAttendancesError();
}