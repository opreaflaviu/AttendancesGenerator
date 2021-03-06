
import 'package:attendances/blocs/bloc_history_page.dart';
import 'package:attendances/blocs/bloc_provider/bloc_provider.dart';
import 'package:attendances/blocs/bloc_qrcode_generator_page.dart';
import 'package:attendances/blocs/bloc_statistics_page.dart';
import 'package:attendances/model/attendance.dart';
import 'package:attendances/model/course.dart';
import 'package:attendances/pages/history_page.dart';
import 'package:attendances/pages/statistics_page.dart';
import 'package:attendances/repository/attendance_repository.dart';
import 'package:attendances/utils/custom_icons.dart';
import 'package:flutter/material.dart';

import '../pages/qrcode_generator_page.dart';
import '../utils/colors_constants.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _tabIndex = 0;
  final List<Widget> _tabItem = [
    BlocProvider(
      bloc: BlocQRCodeGeneratorPage(),
      child: QRCodeGeneratorPage()),
    BlocProvider(
      bloc: BlocHistoryPage(),
      child: HistoryPage()),
    BlocProvider(
        bloc: BlocStatisticsPage(),
        child: StatisticsPage()),
  ];

  final List<String> _titleList = ['Attendances', 'History', 'Statistics'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: _tabItem[_tabIndex],
        appBar: AppBar(
          title: Text(_titleList[_tabIndex],
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 32.0, color: ColorsConstants.customBlack)),
          centerTitle: true,
          backgroundColor: ColorsConstants.backgroundColorYellow,
          elevation: 2.0,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search, color: ColorsConstants.customBlack),
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
                      icon: Icon(Icons.history),
                      title: Text('History')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.insert_chart),
                      title: Text('Statistics')),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('${course.type} ${course.number}'),
                                Padding(padding: EdgeInsets.all(8.0)),
                                Text('${course.teacher}')
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(4.0)),
                            Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('${course.createdAt}'.substring(0, 16)),
                              ],
                            )
                          ],
                        ),
                      ))
                  .toList(),
            ));
  }
}
