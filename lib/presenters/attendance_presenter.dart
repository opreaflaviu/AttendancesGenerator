import 'package:attendances/model/attendance.dart';
import 'package:attendances/repository/attendance_repository.dart';
import 'package:attendances/views/attendance_body_view.dart';

class AttendancePresenter {
  AttendanceBodyView _attendanceBodyView;
  AttendanceRepository _attendanceRepository;

  AttendancePresenter(this._attendanceBodyView) {
    _attendanceRepository = AttendanceRepository();
  }

  void saveAttendance(Attendance attendance) {
    _attendanceRepository.saveAttendance(attendance)
        .then((response) => _attendanceBodyView.onSaveAttendanceComplete())
        .catchError((e) => _attendanceBodyView.onSaveAttendancesError());
  }


}