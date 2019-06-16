import 'package:attendances/blocs/bloc_provider/bloc_provider.dart';
import 'package:attendances/blocs/bloc_qrcode_generator_page.dart';
import 'package:flutter/material.dart';
import '../utils/colors_constants.dart';

class QRCodeGeneratorPage extends StatefulWidget {
  @override
  QRCodeGeneratorPageState createState() => QRCodeGeneratorPageState();
}

class QRCodeGeneratorPageState extends State<QRCodeGeneratorPage> {
  var _courseClass = TextEditingController();
  var _courseNumber = TextEditingController();

  var _blocQrCodeGeneratorPage;

  QRCodeGeneratorPageState() {
    _courseClass.text = "";
    _courseNumber.text = "";
  }

  @override
  Widget build(BuildContext context) {

    _blocQrCodeGeneratorPage = BlocProvider.of<BlocQRCodeGeneratorPage>(context);
    var _mediaQuery = MediaQuery.of(context);
    var _widthDP = _mediaQuery.size.width;
    var _heightDP = _mediaQuery.size.height;
    _blocQrCodeGeneratorPage.widthDP = _widthDP;
    _blocQrCodeGeneratorPage.heightDP = _heightDP;

    return SafeArea(
        minimum: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                StreamBuilder<Set<String>>(
                  stream: _blocQrCodeGeneratorPage.getCourses(),
                  builder: (BuildContext buildContext, AsyncSnapshot<Set<String>> snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;
                      return _coursesMenu(data);
                    } else {
                      return _coursesMenu(Set<String>());
                    }
                  }
                ),
                StreamBuilder<List<String>>(
                    stream: _blocQrCodeGeneratorPage.getCourseTypes(),
                    builder: (BuildContext buildContext, AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data;
                        return _courseTypesMenu(data);
                      } else {
                        return _courseTypesMenu([]);
                      }
                    }
                ),
                TextField(
                    cursorColor: ColorsConstants.customBlack,
                    decoration: new InputDecoration(
                        labelText: 'Course class',
                        hintText: 'ex: 222',
                        contentPadding:
                            new EdgeInsets.only(bottom: 2.0, top: 8.0),
                        hintStyle: TextStyle(
                            fontSize: 16.0, color: ColorsConstants.customBlack),
                        labelStyle: TextStyle(
                            fontSize: 16.0,
                            color: ColorsConstants.customBlack)),
                    style: new TextStyle(fontSize: 16.0, color: Colors.black),
                    controller: _courseClass
                ),
                TextField(
                    cursorColor: ColorsConstants.customBlack,
                    decoration: new InputDecoration(
                        labelText: 'Course number',
                        hintText: '1',
                        contentPadding:
                            new EdgeInsets.only(bottom: 2.0, top: 8.0),
                        hintStyle: TextStyle(
                            fontSize: 16.0, color: ColorsConstants.customBlack),
                        labelStyle: new TextStyle(
                            fontSize: 16.0,
                            color: ColorsConstants.customBlack)),
                    style: new TextStyle(fontSize: 16.0, color: Colors.black),
                    controller: _courseNumber),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        padding: new EdgeInsets.fromLTRB(
                            _widthDP * 0.05,
                            _heightDP * 0.01,
                            _widthDP * 0.05,
                            _heightDP * 0.01),
                        child: new Text("Generate QR",
                            style: TextStyle(
                                color: ColorsConstants.customBlack,
                                fontSize: 16.0)),
                        onPressed: _generateQR,
                        splashColor: ColorsConstants.backgroundColorYellow,
                        color: ColorsConstants.backgroundColorYellow,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      ),
                      RaisedButton(
                        padding: new EdgeInsets.fromLTRB(
                            _widthDP * 0.08,
                            _heightDP * 0.01,
                            _widthDP * 0.09,
                            _heightDP * 0.01),
                        child: new Text("Clear QR",
                            style: TextStyle(
                                color: ColorsConstants.customBlack,
                                fontSize: 16.0)),
                        onPressed: () {
                          _clearQR();
                        },
                        splashColor: ColorsConstants.backgroundColorYellow,
                        color: ColorsConstants.backgroundColorYellow,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      ),
                    ],
                  ),
                ),

                StreamBuilder<Widget>(
                    initialData: Container(width: 0, height: 0),
                    stream: _blocQrCodeGeneratorPage.getQrWidget(),
                    builder: (BuildContext buildContext, AsyncSnapshot<Widget> snapshot) => snapshot.data
                ),
                StreamBuilder<Widget>(
                    initialData: Container(width: 0, height: 0),
                    stream: _blocQrCodeGeneratorPage.getSaveButton(),
                    builder: (BuildContext buildContext, AsyncSnapshot<Widget> snapshot) => snapshot.data
                ),
              ],
            ),
          ),
        );
  }

  @override
  void dispose() {
    _courseNumber.dispose();
    _courseClass.dispose();
    super.dispose();
  }

  Widget _coursesMenu(Set<String> data) {
    List<DropdownMenuItem<String>> listDrop = [];

    listDrop.add(DropdownMenuItem(
      child: Text("Select course name",
          style: TextStyle(fontSize: 16, color: ColorsConstants.customBlack)),
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
            stream: _blocQrCodeGeneratorPage.getSelectedCourseName(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return DropdownButton(
                  value: snapshot.data,
                  items: listDrop,
                  hint: Text("Select course name",
                      style: TextStyle(fontSize: 16, color: ColorsConstants.customBlack)),
                  isExpanded: true,
                  onChanged: (value) {
                    _blocQrCodeGeneratorPage.setCourseName(value);
                  });
            })
    );
  }

  Widget _courseTypesMenu(List<String> data) {
    List<DropdownMenuItem<String>> listDrop = [];

    listDrop.add(DropdownMenuItem(
      child: Text("Select course type",
          style: TextStyle(fontSize: 16, color: ColorsConstants.customBlack)),
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
            stream: _blocQrCodeGeneratorPage.getSelectedCourseType(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return DropdownButton(
                  value: snapshot.data,
                  items: listDrop,
                  hint: Text("Select course type",
                    style: TextStyle(fontSize: 16, color: ColorsConstants.customBlack)),
                  isExpanded: true,
                  onChanged: (value) {
                    _blocQrCodeGeneratorPage.setCourseType(value);

                  });
            })
    );
  }

  _clearQR() {
    FocusScope.of(context).requestFocus(new FocusNode());
    _blocQrCodeGeneratorPage.setCourseName("");
    _blocQrCodeGeneratorPage.setCourseType("");
    _blocQrCodeGeneratorPage.setCourseNumber("");
    _blocQrCodeGeneratorPage.setCourseClass("");
    _courseClass.text = "";
    _courseNumber.text = "";
    _blocQrCodeGeneratorPage.setQrWidgetAndSaveButton();
  }

  Future<Null> _showAlertDialog(String title, String content) {
    return showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _generateQR() {
    _blocQrCodeGeneratorPage.setCourseClass(_courseClass.text);
    _blocQrCodeGeneratorPage.setCourseNumber(_courseNumber.text);
    _blocQrCodeGeneratorPage.setQrWidgetAndSaveButton();
  }
}
