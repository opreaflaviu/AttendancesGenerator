import 'package:attendances/model/attendance.dart';
import 'package:quiver/collection.dart';

abstract class GeneratedAttendancesView {
  onLoadAttendancesComplete(List<Attendance> generatedAttendanceList);
  onLoadAttendancesError();
}