import 'package:attendances/utils/constants.dart';

class Grade {

  int grade;

  Grade(this.grade);

  Grade.fromJson(Map map):
      this.grade = map[Constants.grade];

  Map<String, int> toJson() {
    var map = Map<String, int>();
    map[Constants.grade] = this.grade;

    return map;
  }

}