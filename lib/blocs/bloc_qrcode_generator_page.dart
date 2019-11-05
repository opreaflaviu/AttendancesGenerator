
import 'dart:async';

import 'package:attendances/model/attendance.dart';
import 'package:attendances/repository/attendance_repository.dart';
import 'package:attendances/repository/teacher_repository.dart';
import 'package:attendances/utils/colors_constants.dart';
import 'package:attendances/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc_provider/bloc_base.dart';

class BlocQRCodeGeneratorPage extends BlocBase {

  double widthDP;
  double heightDP;

  var _attendanceRepository = AttendanceRepository();
  var _teachersRepository = TeacherRepository();

  var _attendance = Attendance('', '', '', '', '', '', 0);

  var _teacherCoursesList = Set<String>();
  ReplaySubject<Set<String>> _teacherCoursesReplaySubject;
  Sink<Set<String>> get _teacherCoursesSink => _teacherCoursesReplaySubject.sink;
  Stream<Set<String>> get _teacherCoursesStream => _teacherCoursesReplaySubject.stream;

  var _courseTypes = ['Course', 'Laboratory', 'Seminar'];
  ReplaySubject<List<String>> _courseTypesReplaySubject;
  Sink<List<String>> get _courseTypesSink => _courseTypesReplaySubject.sink;
  Stream<List<String>> get _courseTypesStream => _courseTypesReplaySubject.stream;

  ReplaySubject<Widget> _qrWidgetReplaySubject;
  Sink<Widget> get _qrWidgetSink => _qrWidgetReplaySubject.sink;
  Stream<Widget> get _qrWidgetStream => _qrWidgetReplaySubject.stream;

  ReplaySubject<Widget> _saveQrButtonReplaySubject;
  Sink<Widget> get _saveQrButtonSink => _saveQrButtonReplaySubject.sink;
  Stream<Widget> get _saveQrButtonStream => _saveQrButtonReplaySubject.stream;

  var _selectedCourseName = "";
  ReplaySubject<String> _selectedCourseNameReplaySubject;
  Sink<String> get _selectedCourseNameSink => _selectedCourseNameReplaySubject.sink;
  Stream<String> get _selectedCourseNameStream => _selectedCourseNameReplaySubject.stream;

  var _selectedCourseType = "";
  ReplaySubject<String> _selectedCourseTypeReplaySubject;
  Sink<String> get _selectedCourseTypeSink => _selectedCourseTypeReplaySubject.sink;
  Stream<String> get _selectedCourseTypeStream => _selectedCourseTypeReplaySubject.stream;

  @override
  void initState() async {
    _teacherCoursesReplaySubject = ReplaySubject<Set<String>>();
    _courseTypesReplaySubject = ReplaySubject<List<String>>();
    _qrWidgetReplaySubject = ReplaySubject<Widget>();
    _saveQrButtonReplaySubject = ReplaySubject<Widget>();
    _selectedCourseNameReplaySubject = ReplaySubject<String>();
    _selectedCourseTypeReplaySubject = ReplaySubject<String>();
    _getCoursesFromBackend();
  }

  @override
  void dispose() {
    _teacherCoursesReplaySubject.close();
    _courseTypesReplaySubject.close();
    _qrWidgetReplaySubject.close();
    _saveQrButtonReplaySubject.close();
    _selectedCourseNameReplaySubject.close();
    _selectedCourseTypeReplaySubject.close();
  }

  _getCoursesFromBackend() async {
    var teacherId = await _getFromSharedPrefs(Constants.teacherId);
    _teacherCoursesList = await _teachersRepository.getTeachersCourses(teacherId);
    _teacherCoursesSink.add(_teacherCoursesList);
  }

  Stream<Set<String>> getCourses() => _teacherCoursesStream;

  Stream<List<String>> getCourseTypes() {
    _courseTypesSink.add(_courseTypes);
    return _courseTypesStream;
  }

  Future<bool> saveGeneratedAttendance(Attendance attendance) async {
    return await _attendanceRepository.saveAttendance(attendance);
  }

  Future<String> _getFromSharedPrefs(String preference) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var teacherId = sharedPreferences.get(preference);
    return teacherId;
  }

  setCourseName(String courseName) {
    _selectedCourseName = courseName;
    _attendance.courseName = _selectedCourseName;
    _selectedCourseNameSink.add(_selectedCourseName);
  }

  setCourseType(String courseType) {
    _selectedCourseType = courseType;
    _attendance.courseType = _selectedCourseType;
    _selectedCourseTypeSink.add(_selectedCourseType);
  }

  setCourseNumber(int courseNumber) {
    _attendance.courseNumber = courseNumber;
  }

  setCourseClass(String courseClass) {
    _attendance.courseClass = courseClass;
  }

  _setTeacherId() async {
    var teacherId = await _getFromSharedPrefs(Constants.teacherId);
    _attendance.courseTeacherId = teacherId;
  }

  _setTeacherName() async {
    var teacherName = await _getFromSharedPrefs(Constants.teacherName);
    _attendance.courseTeacher = teacherName;
  }

  _setCourseCreatedAt() {
    var courseCreatedAt = DateTime.now().toIso8601String().substring(0, 19);
    _attendance.courseCreatedAt = courseCreatedAt;
  }

  Stream<String> getSelectedCourseName() {
    _selectedCourseNameSink.add(_selectedCourseName);
    return _selectedCourseNameStream;
  }

  Stream<String> getSelectedCourseType() {
    _selectedCourseTypeSink.add(_selectedCourseType);
    return _selectedCourseTypeStream;
  }

  Widget _qrWidget() {
    print("_qrWidget: ${_attendance.toString()}");
    return Expanded(
        child: Center(
          widthFactor: widthDP * 0.5,
          heightFactor: widthDP * 0.5,
          child: RepaintBoundary(
            child: QrImage(
              data: _attendance.toString(),
              size: widthDP * 0.5,
            ),
          ),
        ));
  }

  Future<void> setQrWidgetAndSaveButton() async {
    if (_attendance.courseName != '' &&
        _attendance.courseType != '' &&
        _attendance.courseNumber != 0 &&
        _attendance.courseClass != '') {
      await _setTeacherId();
      await _setTeacherName();
      _setCourseCreatedAt();
      _qrWidgetSink.add(_qrWidget());
      _saveQrButtonSink.add(_saveButton());
    } else {
      _qrWidgetSink.add(Container(width: 0.0, height: 0.0));
      _saveQrButtonSink.add(Container(width: 0.0, height: 0.0));
    }
  }

  Stream<Widget> getQrWidget() => _qrWidgetStream;

  Widget _saveButton() {
    Widget saveQrButton = RaisedButton(
      padding: new EdgeInsets.fromLTRB(
          widthDP * 0.35, heightDP * 0.01, widthDP * 0.35, heightDP * 0.01),
      child: new Text("Save QR",
          style:
          TextStyle(color: ColorsConstants.customBlack, fontSize: 16.0)),
      onPressed: () {
        saveGeneratedAttendance(_attendance);
      },
      splashColor: ColorsConstants.backgroundColorYellow,
      color: ColorsConstants.backgroundColorYellow,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
    );
    return saveQrButton;
  }

  Stream<Widget> getSaveButton() => _saveQrButtonStream;
}