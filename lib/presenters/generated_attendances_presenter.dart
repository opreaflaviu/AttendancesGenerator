import 'package:attendances/repository/attendance_repository.dart';
import 'package:attendances/views/generated_attendance_view.dart';

class GeneratedAttendancesPresenter {
  GeneratedAttendancesView _attendancesView;
  AttendanceRepository _attendanceRepository;

  GeneratedAttendancesPresenter(this._attendancesView) {
    _attendanceRepository = AttendanceRepository();
  }

  getGeneratedAttendances() {
    _attendanceRepository.getGeneratedAttendances()
        .then((generatedAttendanceList) => _attendancesView.onLoadAttendancesComplete(generatedAttendanceList))
        .catchError((error) => _attendancesView.onLoadAttendancesError());
  }
}