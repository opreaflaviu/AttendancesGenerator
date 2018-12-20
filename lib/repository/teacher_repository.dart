import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../model/teacher.dart';


class TeacherRepository {

  Future<Teacher> loginTeacher(teacherId, teacherPassword) async {
    var response = await http.post(
        Uri.encodeFull(Constants.rootApi + '/teachers/login'),
        headers: {
          "Accept": "application/json"
        },
        body: {
          Constants.teacherId: "$teacherId",
          Constants.teacherPassword: "$teacherPassword"
        });

    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);
      if (responseData['result'] == 'false') {
        return new Teacher('', '', '');
      } else {
        var teacherName = responseData['result'][Constants.teacherName];
        return new Teacher(teacherId, teacherName, teacherPassword);
      }
    } else {
      throw Exception("Error");
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

    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);

      if (responseData['result'] == 'false') {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

}