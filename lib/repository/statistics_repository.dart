import 'package:attendances/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';

class StatisticsRepository {
  Future<String> downloadStatisticsFile(String courseName, String classId) async {
    var downloadsDir = '/storage/emulated/0/download';
    var filename = 'Statistics_' + courseName + '_' + classId + '.xlsx';

    var dio = Dio();
    var option = Options(
      headers: {
        "Accept": "application/json",
        Constants.courseName: "$courseName",
        Constants.studentClass: "$classId"
      },
    );
    var response = await dio.download(
      Constants.rootApi + '/downloads',
      '$downloadsDir/$filename',
      options: option,
    );

    if (response.statusCode == 200) {
      var responseData = response.headers;
      final filenameResponse = responseData['filename'];
      OpenFile.open("$downloadsDir/$filename",
          type: "application/vnd.ms-excel",
          uti: "com.microsoft.excel.xls");
      return filenameResponse[0];
    } else {
      return " ";
    }
  }
}
