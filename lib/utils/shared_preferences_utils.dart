import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../model/student.dart';
import '../model/teacher.dart';
import 'dart:async';

class SharedPreferencesUtils {
  static Future<SharedPreferences> _sharedPreferences;

  SharedPreferencesUtils(){
    _initSharedPreferences();
  }

  _initSharedPreferences(){
    _sharedPreferences = SharedPreferences.getInstance();
  }

  logoutStudent(){
    _sharedPreferences.then((sharedPrefs) {
      sharedPrefs.clear();
    });
  }

  saveStudent(Student student){
    _sharedPreferences.then((sharedPrefs) {
      sharedPrefs.setString(Constants.studentName, student.studentName);
      sharedPrefs.setString(Constants.studentId, student.studentId);
      sharedPrefs.setInt(Constants.studentClass, student.studentClass);
      sharedPrefs.setInt(Constants.studentPassword, student.studentPassword);
      print('shared' + sharedPrefs.getString(Constants.studentName));
    });
  }

  saveTeacher(Teacher teacher) {
    print('teacher' + teacher.toString());
    _sharedPreferences.then((sharedPrefs) {
      sharedPrefs.setString(Constants.teacherName, teacher.teacherName);
      sharedPrefs.setString(Constants.teacherId, teacher.teacherId);
      print('shared' + sharedPrefs.getString(Constants.teacherName));
    });
  }


}