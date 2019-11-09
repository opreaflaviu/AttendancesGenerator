import 'package:attendances/blocs/bloc_generated_attendances_page.dart';
import 'package:attendances/blocs/bloc_history_page.dart';
import 'package:attendances/blocs/bloc_provider/bloc_provider.dart';
import 'package:attendances/pages/generated_attendances_page.dart';
import 'package:attendances/utils/colors_constants.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var _blocHistoryPage;
  var _selectedCourse = "";

  @override
  Widget build(BuildContext context) {
    _blocHistoryPage = BlocProvider.of<BlocHistoryPage>(context);
    return Container(
        child: Column(
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Center(
          child: Text("Add your courses", style: TextStyle(fontSize: 20)),
        ),
        SizedBox(
          height: 15,
        ),
        SafeArea(
            minimum: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _coursesMenu(_blocHistoryPage.getAllCourses()),
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: MaterialButton(
                      color: ColorsConstants.backgroundColorPurple,
                      child: Text("Add",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      onPressed: () {
                        _addCourse(_selectedCourse);
                      }),
                )
              ],
            )),
        Divider(height: 20, thickness: 1.5,),
        SizedBox(
          height: 20,
        ),
        Center(
          child: Text("Your courses", style: TextStyle(fontSize: 20)),
        ),
        Expanded(
          child: SafeArea(
              minimum: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: StreamBuilder<Set<String>>(
                  stream: _blocHistoryPage.getCourses(),
                  builder: (BuildContext buildContext, AsyncSnapshot<Set<String>> snapshot) {
                    if (snapshot.hasData) {
                      Set<String> coursesList = snapshot.data;
                      return _teacherCoursesList(coursesList);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })),
        )
      ],
    ));
  }

  Widget _teacherCoursesList(Set<String> data) {
    var initialCount = 0;
    if (data != null) {
      initialCount = data.length;
      data = sortCourses(data.toList());
    }
    return ListView.builder(
        itemCount: initialCount,
        itemBuilder: (context, index) {
          return _teacherCoursesListItem(data.elementAt(index));
        });
  }

  Widget _teacherCoursesListItem(String item) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      child: Dismissible(
        key: Key(item),
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 1.0,
            color: ColorsConstants.backgroundColorPurple,
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: <Widget>[
                    Text(item, style: TextStyle(fontSize: 16))
                  ],
                ),
              ),
            )),
        background: Container(
          alignment: AlignmentDirectional.centerEnd,
          child: Icon(Icons.delete, color: ColorsConstants.customBlack),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          _deleteCourse(item);
          //TODO: fix this. Is not working when you press UNDO button
//          Scaffold.of(context).showSnackBar(SnackBar(
//              content: Text("$item deleted"),
//              backgroundColor: ColorsConstants.customBlack,
//              action: SnackBarAction(
//                textColor: ColorsConstants.backgroundColorYellow,
//                  label: "UNDO",
//                  onPressed: () {
//                    _addCourse(item);
//                  })));
        },
      ),
      onTap: () {
        _goToGenerateAttendancesPage(item);
      },
    );
  }

  Widget _coursesMenu(List<String> data) {
    List<DropdownMenuItem<String>> listDrop = [];

    listDrop.add(DropdownMenuItem(
      child: Text("Select course name", style: TextStyle(fontSize: 18)),
      value: "",
    ));

    data.forEach((element) {
      listDrop.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    });

    return Expanded(
        child: DropdownButtonHideUnderline(
            child: DropdownButton(
                value: _selectedCourse,
                items: listDrop,
                hint: Text("Select course name"),
                isExpanded: true,
                onChanged: (value) {
                  _selectedCourse = value;
                  setState(() {});
                })));
  }

  _goToGenerateAttendancesPage(String course) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => BlocProvider(
            bloc: BlocGeneratedAttendancesPage(),
            child: GeneratedAttendancesPage(course)
        )));
  }

  _deleteCourse(String course) async {
    _blocHistoryPage.deleteCourse(course);
  }

  _addCourse(String course) async {
    if (_selectedCourse.isNotEmpty) {
      _blocHistoryPage.addCourse(course);
    }
  }

  Set<String> sortCourses(List<String> list) {
    list.sort();
    return list.toSet();
  }
}
