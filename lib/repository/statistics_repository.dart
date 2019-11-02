import 'package:attendances/utils/constants.dart';
import 'package:dio/dio.dart';

class StatisticsRepository {
  Future<String> downloadStatisticsFile(String courseName, String classId) async {
  var downloadsDir = '/storage/emulated/0/download';
  var filename = 'Statistics_' + courseName + '_' + classId + '.xlsx';

    var dio = Dio();
    var response = await dio.download(
      Constants.rootApi + '/downloads',
      '$downloadsDir/$filename',
      options: Options(
        headers: {
          "Accept": "application/json",
          Constants.courseName: "$courseName",
          Constants.studentClass: "$classId"
        },
      ),
    );

    if (response.statusCode == 200) {
      var responseData = response.headers;
      final filename = responseData['filename'];
      return filename[0];
    } else {
      return " ";
    }
  }
}
