import 'dart:async';

import 'package:attendances/repository/teacher_repository.dart';
import 'package:attendances/utils/constants.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc_provider/bloc_base.dart';

class BlocHistoryPage implements BlocBase {

  final teachersRepository = TeacherRepository();
  var _teacherCoursesList = Set<String>();

  ReplaySubject<Set<String>> _courseListReplaySubject;
  Sink<Set<String>> get _courseSink => _courseListReplaySubject.sink;
  Stream<Set<String>> get _courseStream => _courseListReplaySubject.stream;

  @override
  void initState() async {
    _courseListReplaySubject = ReplaySubject<Set<String>>();
    var teacherId = await _getTeacherId();
    _teacherCoursesList = await teachersRepository.getTeachersCourses(teacherId);
    _courseSink.add(_teacherCoursesList);
  }

  @override
  void dispose() {
    _courseListReplaySubject.close();
  }

  addCourse(String courseName) async {
    if (!_teacherCoursesList.contains(courseName)) {
      var teacherId = await _getTeacherId();
      _teacherCoursesList.add(courseName);
      _courseSink.add(_teacherCoursesList);
      await teachersRepository.addCourse(teacherId, courseName);
    }
  }

  deleteCourse(String courseName) async {
    if (_teacherCoursesList.contains(courseName)) {
      var teacherId = await _getTeacherId();
      _teacherCoursesList.remove(courseName);
      _courseSink.add(_teacherCoursesList);
      await teachersRepository.deleteCourse(teacherId, courseName);
    }
  }

  Stream<Set<String>> getCourses() => _courseStream;

  List<String> getAllCourses() => teachersRepository.getCourses();

  Future<String> _getTeacherId() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var teacherId = sharedPreferences.get(Constants.teacherId);
    return teacherId;
  }
}
