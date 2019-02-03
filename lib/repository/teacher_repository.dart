import 'dart:convert';
import 'dart:async';
import 'package:attendances/utils/custom_error.dart';
import 'package:attendances/utils/shared_preferences_utils.dart';
import 'package:password/password.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../model/teacher.dart';


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
      print("response data: $responseData");
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
          Constants.teacherId: "${teacher.teacherId}"
        });
    print("response code: ${response.statusCode.toString()}");
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

  bool _validLogin(teacherPassword, passwordResponse, teacherName, nameResponse) {
    return (Password.verify(teacherPassword, passwordResponse) && teacherName ==
        nameResponse);
  }

  void _saveInSharedPrefs(Teacher teacher) async {
    SharedPreferencesUtils sharedPreferencesUtils = SharedPreferencesUtils();
    sharedPreferencesUtils.saveTeacher(teacher);
  }
}