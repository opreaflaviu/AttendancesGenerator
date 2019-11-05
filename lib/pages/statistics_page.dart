import 'package:attendances/blocs/bloc_provider/bloc_provider.dart';
import 'package:attendances/blocs/bloc_statistics_page.dart';
import 'package:attendances/utils/colors_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class StatisticsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  var _studentsClassId = TextEditingController();
  var _blocStatisticsPage;

  @override
  Widget build(BuildContext context) {
    _blocStatisticsPage = BlocProvider.of<BlocStatisticsPage>(context);

    var _mediaQuery = MediaQuery.of(context);
    var _widthDP = _mediaQuery.size.width;
    var _heightDP = _mediaQuery.size.height;

    return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text("Select course name and class number", style:
                TextStyle
                  (fontSize: 20)),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: _coursesMenu(_blocStatisticsPage.getAllCourses()),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                    cursorColor: ColorsConstants.customBlack,
                    decoration: new InputDecoration(
                        labelText: 'Class number',
                        hintText: '222',
                        contentPadding:
                        new EdgeInsets.only(bottom: 2.0, top: 8.0),
                        hintStyle: TextStyle(
                            fontSize: 16.0, color: ColorsConstants.customBlack),
                        labelStyle: new TextStyle(
                            fontSize: 16.0,
                            color: ColorsConstants.customBlack),
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.black26,
                                width: 1.5
                            )
                        )),

                    style: new TextStyle(fontSize: 16.0, color: Colors.black),
                    controller: _studentsClassId),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: RaisedButton(
                  padding: new EdgeInsets.fromLTRB(
                      _widthDP * 0.35, _heightDP * 0.01, _widthDP * 0.35,
                      _heightDP * 0.01),
                  child: new Text("Download",
                      style: TextStyle(
                          color: ColorsConstants.customBlack, fontSize: 16.0)),
                  onPressed: () {
                    _handlePermission(PermissionGroup.storage)
                    .then((hasPermission) {
                      if (hasPermission) {
                        _blocStatisticsPage.downloadStatisticsFile(_studentsClassId.text);
                      }
                    });
                  },
                  splashColor: ColorsConstants.backgroundColorPurple,
                  color: ColorsConstants.backgroundColorPurple,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                )
              ),

              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: StreamBuilder(
                    stream: _blocStatisticsPage.getFileName(),
                    builder: (BuildContext context, AsyncSnapshot<String>
                    snapshot) {
                      var text = "";
                      if (snapshot.data != null) {
                        text = snapshot.data;
                      }
                      return Text(text, style:
                      TextStyle
                        (fontSize: 20));
                    },
                  )

                ),
              ),


            ],
          ),
        )
    );
  }

   Future<bool> _handlePermission(PermissionGroup permissionName) async {
    ServiceStatus serviceStatus = await PermissionHandler().checkServiceStatus(permissionName);
    if (serviceStatus.value != ServiceStatus.enabled) {
      PermissionStatus permissionStatus = await PermissionHandler().checkPermissionStatus(permissionName);
      if (permissionStatus != PermissionStatus.granted) {
        print("Permission: $permissionName has status: $permissionStatus");
        Map<PermissionGroup, PermissionStatus> permissionRequestStatus = await PermissionHandler().requestPermissions([permissionName]);
        print("Permission: $permissionName has permissionRequestStatus: ${permissionRequestStatus[permissionName]}");
        if (permissionRequestStatus[permissionName] != PermissionStatus.granted)
          return false;
      }
    }
    print("Permission: $permissionName granted");
    return true;
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

    return DropdownButtonHideUnderline(
        child: StreamBuilder(
            stream: _blocStatisticsPage.getSelectedCourseName(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return DropdownButton(
                  value: snapshot.data,
                  items: listDrop,
                  hint: Text("Select course name",textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: ColorsConstants
                          .customBlack)),
                  isExpanded: true,
                  onChanged: (value) {
                    _blocStatisticsPage.setSelectedCourseName(value);
                   });
            })
    );
  }

}