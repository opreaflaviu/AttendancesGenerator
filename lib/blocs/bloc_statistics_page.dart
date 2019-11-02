
import 'package:attendances/blocs/bloc_provider/bloc_base.dart';
import 'package:attendances/repository/statistics_repository.dart';
import 'package:attendances/repository/teacher_repository.dart';
import 'package:rxdart/rxdart.dart';


class BlocStatisticsPage extends BlocBase {

  final teachersRepository = TeacherRepository();
  final statisticsRepository = StatisticsRepository();

  var _selectedCourseName = "";
  ReplaySubject<String> _selectedCourseNameReplaySubject;
  Sink<String> get _selectedCourseNameSink => _selectedCourseNameReplaySubject.sink;
  Stream<String> get _selectedCourseNameStream => _selectedCourseNameReplaySubject.stream;

  var _fileName = "";
  ReplaySubject<String> _fileNameReplaySubject;
  Sink<String> get _fileNameSink => _fileNameReplaySubject.sink;
  Stream<String> get _fileNameStream => _fileNameReplaySubject.stream;

  @override
  void initState() async {
    _selectedCourseNameReplaySubject = ReplaySubject<String>();
    _fileNameReplaySubject = ReplaySubject<String>();
  }

  @override
  void dispose() {
    _selectedCourseNameReplaySubject.close();
    _fileNameReplaySubject.close();
  }

  setSelectedCourseName(String courseName) {
    _selectedCourseName = courseName;
    _selectedCourseNameSink.add(_selectedCourseName);
  }

  Stream<String> getSelectedCourseName() {
    _selectedCourseNameSink.add(_selectedCourseName);
    return _selectedCourseNameStream;
  }
  
  _setFileName(String filename) {
    _fileName = filename;
    _fileNameSink.add(filename);
  }

  Stream<String> getFileName() {
    _fileNameSink.add(_fileName);
    return _fileNameStream;
  }

  List<String> getAllCourses() => teachersRepository.getCourses();

  downloadStatisticsFile(String classId) {
    statisticsRepository.downloadStatisticsFile(_selectedCourseName, classId)
        .then((filename) {
          //TODO: set location for iOS also
          _setFileName("You can find $filename in Download folder");
    });
  }
}