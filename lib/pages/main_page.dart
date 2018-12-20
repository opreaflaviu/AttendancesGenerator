import 'package:attendances/model/attendance.dart';
import 'package:attendances/model/course.dart';
import 'package:attendances/pages/generated_attendances_page.dart';
import 'package:attendances/repository/attendance_repository.dart';
import 'package:attendances/utils/constants.dart';
import 'package:attendances/utils/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/colors_constants.dart';
import '../pages/qrcode_generator_page.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _tabIndex = 0;
  final List<Widget> _tabItem = [
    QRCodeGeneratorPage(),
    GeneratedAttendancesPage(),
  ];

  final List<String> _titleList = [
    'Attendances',
    'History'
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: _tabItem[_tabIndex],
        appBar: AppBar(
          title: new Text(_titleList[_tabIndex],
              textAlign: TextAlign.center,
              style: new TextStyle(fontSize: 24.0, color: Colors.black87)),
          centerTitle: true,
          backgroundColor: ColorsConstants.backgroundColorYellow,
          elevation: 2.0,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search, color: Colors.black87),
                onPressed: () {
                  showSearch(
                      context: context, delegate: StudentAttendanceSearch());
                })
          ],
        ),
        bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: ColorsConstants.backgroundColorYellow,
            ),
            child: BottomNavigationBar(
                fixedColor: Colors.black87,
                onTap: onTabTapped,
                currentIndex: _tabIndex,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(CustomIcons.qr_code),
                      title: Text('Generator')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.history), title: Text('History')),
                ])));
  }

  onTabTapped(int index) {
    setState(() {
      _tabIndex = index;
    });
  }
}

class StudentAttendanceSearch extends SearchDelegate<Attendance> {
  AttendanceRepository _attendanceRepository;
  var responseList = [];

  StudentAttendanceSearch() {
    this._attendanceRepository = AttendanceRepository();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: _attendanceRepository.getStudentAttendances(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) return Center();
            if (snapshot.data.length == 0)
              return Center(
                  child: Text("No attendances found for this student"));
            return _searchResultList(snapshot.data);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  _searchResultList(dynamic data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) => ExpansionTile(
              title: Text(data[index].courseName),
              children: data[index]
                  .attendanceList
                  .map<Widget>((Course course) => Padding(
                      padding: EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('${course.type} ${course.number}'),
                          Text('${course.createdAt}'.substring(0, 10)),
                          Text('${course.createdAt}'.substring(10, 16)),
                          Text('${course.teacher}'),
                        ],
                      ),)
              ).toList(),
            ));
  }
}
