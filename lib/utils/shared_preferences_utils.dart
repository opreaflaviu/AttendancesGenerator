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

  saveTeacher(Teacher teacher) {
    _sharedPreferences.then((sharedPrefs) {
      sharedPrefs.setString(Constants.teacherName, teacher.teacherName);
      sharedPrefs.setString(Constants.teacherId, teacher.teacherId);
      sharedPrefs.setString(Constants.teacherPassword, teacher.teacherPassword);
      print('shared' + sharedPrefs.getString(Constants.teacherName));
    });
  }


}