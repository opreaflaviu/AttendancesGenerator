

import 'package:attendances/blocs/bloc_provider/bloc_base.dart';
import 'package:attendances/model/attendance.dart';
import 'package:attendances/repository/attendance_repository.dart';
import 'package:rxdart/rxdart.dart';

class BlocGeneratedAttendancesPage extends BlocBase {

  final _attendanceRepository = AttendanceRepository();

  ReplaySubject<List<Attendance>> _attendancesListReplaySubject;
  Sink<List<Attendance>> get _attendancesSink => _attendancesListReplaySubject.sink;
  Stream<List<Attendance>> get _attendancesStream => _attendancesListReplaySubject.stream;

  ReplaySubject<bool> _isFetchingReplaySubject;
  Sink<bool> get _isFetchingSink => _isFetchingReplaySubject.sink;
  Stream<bool> get _isFetchingStream => _isFetchingReplaySubject.stream;

  @override
  void initState() {
    _attendancesListReplaySubject = ReplaySubject<List<Attendance>>();
    _isFetchingReplaySubject = ReplaySubject<bool>();
    setIsFetching(true);
  }

  @override
  void dispose() {
    _attendancesListReplaySubject.close();
    _isFetchingReplaySubject.close();
  }

  fetchGeneratedAttendances(String course) {
    print("fetchGeneratedAttendances");
    _attendanceRepository.getGeneratedAttendances(course)
        .then((generatedAttendanceList) => _setGeneratedAttendances(generatedAttendanceList));
  }

  _setGeneratedAttendances(List<Attendance> generatedAttendanceList) {
    print("_setGeneratedAttendances");
    _attendancesSink.add(generatedAttendanceList);
    setIsFetching(false);
  }

  Stream<List<Attendance>> getGeneratedAttendances() {
    print("getGeneratedAttendances");
    return _attendancesStream;
  }
    setIsFetching(bool isFetching) {
      _isFetchingSink.add(isFetching);
    }

    Stream<bool> getIsFetching() {
      return _isFetchingStream;
    }




}