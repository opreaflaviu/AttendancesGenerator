import 'dart:async';
import 'dart:convert';

import 'package:attendances/utils/custom_error.dart';
import 'package:attendances/utils/shared_preferences_utils.dart';
import 'package:http/http.dart' as http;
import 'package:password/password.dart';

import '../model/teacher.dart';
import '../utils/constants.dart';


class TeacherRepository {

  Future<bool> loginTeacher(teacherName, teacherPassword, teacherId) async {
    var response = await http.post(
        Uri.encodeFull(Constants.rootApi + '/teachers/login'),
        headers: {
          "Accept": "application/json"
        },
        body: {
          Constants.teacherId: "$teacherId",
        });

    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);
      if (responseData['result'] == 'false') {
        throw CustomError('User does not exists');
      } else {
        var nameResponse = responseData['result'][Constants.teacherName];
        var passwordResponse = responseData['result'][Constants.teacherPassword];

        if(_validLogin(teacherPassword, passwordResponse, teacherName, nameResponse)) {
          Teacher teacher = Teacher(teacherId, teacherName, teacherPassword);
          _saveInSharedPrefs(teacher);
          return true;
        } else {
          throw CustomError('Wrong credentials');
        }
      }
    } else {
      throw CustomError();
    }
  }

  Future<bool> registerTeacher(Teacher teacher) async {
    var response = await http.post(
        Uri.encodeFull(Constants.rootApi + '/teachers/add'),
        headers: {
          "Accept": "application/json"
        },
        body: {
          Constants.teacherName: "${teacher.teacherName}",
          Constants.teacherPassword: "${teacher.teacherPassword}",
          Constants.teacherId: "${teacher.teacherId}",
          Constants.teacherCourses: "${teacher.coursesList}"
        });
    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);
      if(responseData['result'] == 'false') {
        throw CustomError('User already exists');
      } else {
        return true;
      }
    } else {
      throw CustomError("Network connection error");
    }
  }

  Future<bool> addCourse(String teacherId, String courseName) async {
    var response = await http.post(
      Uri.encodeFull(Constants.rootApi + '/teachers/$teacherId/courses/add'),
      headers: {
        "Accept": "application/json"
      },
      body: {
        Constants.courseName: '$courseName'
      }
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> deleteCourse(String teacherId, String courseName) async {
    var response = await http.post(
        Uri.encodeFull(Constants.rootApi + '/teachers/$teacherId/courses/delete'),
        headers: {
          "Accept": "application/json"
        },
        body: {
          Constants.courseName: '$courseName'
        }
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<Set<String>> getTeachersCourses(String teacherId) async {
    var response = await http.get(
        Uri.encodeFull(Constants.rootApi + '/teachers/$teacherId/courses'),
        headers: {
          "Accept": "application/json"
        }
    );
    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);
      var courseList = responseData['result'];
      var courseSet = fromListToSet(courseList);
      return courseSet;
    }
    throw Exception("Error");
  }

  bool _validLogin(teacherPassword, passwordResponse, teacherName, nameResponse) {
    return (Password.verify(teacherPassword, passwordResponse) && teacherName ==
        nameResponse);
  }

  void _saveInSharedPrefs(Teacher teacher) async {
    SharedPreferencesUtils sharedPreferencesUtils = SharedPreferencesUtils();
    sharedPreferencesUtils.saveTeacher(teacher);
  }

  Set<String> fromListToSet(List<dynamic> list) {
    var set = Set<String>();
    list.forEach((element) {
      set.add(element.toString());
    });
    return set;
  }

  List<String> getCourses() {
    var _allCoursesList = [
      "ASC",
      "PLF",
      "Sport",
      "Algebra",
      "Baze de date",
      "IA",
      "OOP"
    ];

    return _allCoursesList;
  }
}