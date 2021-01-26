import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:surgerychkd/DoctorHome.dart';
import 'package:surgerychkd/createsurgery.dart';
import 'package:surgerychkd/doctorVideo.dart';
import 'package:surgerychkd/Login.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:surgerychkd/preopDrawerFile.dart';
import 'Globals.dart';
import 'doctorInfoPage.dart';
import 'home.dart';
import 'package:http/http.dart';
import 'dart:convert';

class analytics extends StatefulWidget {
  final Widget child;

  analytics({Key key, this.child}) : super(key: key);
  @override
  _analyticsState createState() => _analyticsState();
}

class _analyticsState extends State<analytics> {
  List<charts.Series<Sales, int>> _seriesLineData;
  int count1 = 0;
  TextEditingController _textEditingController = new TextEditingController();
  List<String> _values = new List();
  List<bool> _selected = new List();

  var loremIpsum1 = surgeryTypeNames;
  final List<DropdownMenuItem> items1 = [];
  String dropDown;

  _generateData(data, name) {
    var linesalesdata = [
      new Sales(0, data["avg_checkin"].toDouble()),
      new Sales(1, data["avg_Insurgery"].toDouble()),
      new Sales(2, data["avg_postSurgery"].toDouble()),
      new Sales(3, data["avg_discharged"].toDouble()),
    ];
    setState(() {
      print("%%%%%%");
      print(linesalesdata);
      if (name == "Adenotonsillectomy") {
        print("*******************");
        print(data);
        print(name);
        print("Inside count 0 of generate");
        _seriesLineData.add(
          charts.Series(
            colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.red),
            id: 'Adenotonsillectomy',
            data: linesalesdata,
            domainFn: (Sales sales, _) => sales.yearval,
            measureFn: (Sales sales, _) => sales.salesval,
          ),
        );
      } else if (name == "Orthopedic Surgery") {
        print("*******************");
        print(data);
        print(name);
        print("Inside count 1 of generate");
        _seriesLineData.add(
          charts.Series(
            colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.blue),
            id: 'Orthopedic Surgery',
            data: linesalesdata,
            domainFn: (Sales sales, _) => sales.yearval,
            measureFn: (Sales sales, _) => sales.salesval,
          ),
        );
      } else if (name == "Inguinal Hernia") {
        print("*******************");
        print(data);
        print(name);
        print("Inside count 1 of generate");
        _seriesLineData.add(
          charts.Series(
            colorFn: (__, _) =>
                charts.ColorUtil.fromDartColor(Colors.purpleAccent),
            id: 'Inguinal Hernia',
            data: linesalesdata,
            domainFn: (Sales sales, _) => sales.yearval,
            measureFn: (Sales sales, _) => sales.salesval,
          ),
        );
      }
      print("&&&&&");
      print(_seriesLineData);
    });

//    _seriesLineData.add(
//      charts.Series(
//        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
//        id: 'Air Pollution',
//        data: linesalesdata1,
//        domainFn: (Sales sales, _) => sales.yearval,
//        measureFn: (Sales sales, _) => sales.salesval,
//      ),
//    );
//    _seriesLineData.add(
//      charts.Series(
//        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
//        id: 'Air Pollution',
//        data: linesalesdata2,
//        domainFn: (Sales sales, _) => sales.yearval,
//        measureFn: (Sales sales, _) => sales.salesval,
//      ),
//    );
  }

  void getData() async {
    setState(() {
      _seriesLineData = List<charts.Series<Sales, int>>();
    });

    for (int i = 0; i < _values.length; i++) {
      var url = hostName + '/analytics/average/' + _values[i];
      print(url);
      Response response = await get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)["data"][0];
        print(data);
        _generateData(data, _values[i]);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesLineData = List<charts.Series<Sales, int>>();

    var wordPair = "";
    loremIpsum1.forEach((word) {
      wordPair = word;
      if (items1.indexWhere((item) {
            return (item.value == wordPair);
          }) ==
          -1) {
        items1.add(DropdownMenuItem(
          child: Text(wordPair),
          value: wordPair,
        ));
      }
      wordPair = "";
    });
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  Widget buildChips() {
    List<Widget> chips = new List();

    for (int i = 0; i < _values.length; i++) {
      InputChip actionChip = InputChip(
        label: Text(_values[i]),
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.teal,
        onDeleted: () {
          _values.removeAt(i);
          _selected.removeAt(i);

          setState(() {
            _values = _values;
            _selected = _selected;
            print(_values);
            print(_selected);
            getData();
          });
        },
      );

      chips.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: actionChip,
      ));
    }

    return Wrap(
      // This next line does the trick.
      children: chips,
    );
  }

  Future<int> handleSignOut() async {
    firebaseAuthGlobal.signOut();
  }

  int selectedIndex = 3;
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    Map<String, Widget> widgets;
    widgets = {
      "Select Surgery Type": SearchableDropdown.single(
        items: items1,
        value: dropDown,
        hint: "Select one",
        searchHint: null,
        onChanged: (value) {
          _values.add(value);
          _selected.add(true);
          _textEditingController.clear();

          setState(() {
            _values = _values;
            _selected = _selected;
            print(_values);
            print(_selected);
            getData();
            dropDown = '';
          });
        },
        dialogBox: false,
        isExpanded: true,
        menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
      ),
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analytics',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: new Text("Logout confirmation"),
                      content: new Text("Are you sure?"),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        new FlatButton(
                          child: new Text("Yes"),
                          onPressed: () {
                            handleSignOut().then((int val) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                  ModalRoute.withName("/Login"));
                            });
                          },
                        ),
                        new FlatButton(
                          child: new Text("No"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      drawer: preopDrawer(context),

      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: ListView(
              children: <Widget>[
                Column(
                  children: widgets
                      .map((k, v) {
                        return (MapEntry(
                            k,
                            Center(
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    margin: EdgeInsets.all(20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text("$k:"),
                                          v,
                                        ],
                                      ),
                                    )))));
                      })
                      .values
                      .toList(),
                ),
                Container(
                  child: buildChips(),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  '    Time taken for each process in surgery',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
                Container(
                  height: 400.0,
                  child: charts.LineChart(_seriesLineData,
                      defaultRenderer: new charts.LineRendererConfig(
                        includeArea: false,
                        stacked: false,
                        includePoints: true,
                      ),
                      animate: true,
                      animationDuration: Duration(seconds: 2),
                      behaviors: [
                        new charts.SeriesLegend(desiredMaxColumns: 2),
                        new charts.ChartTitle('Stages',
                            behaviorPosition: charts.BehaviorPosition.bottom,
                            titleOutsideJustification:
                                charts.OutsideJustification.middleDrawArea),
                        new charts.ChartTitle('Duration',
                            behaviorPosition: charts.BehaviorPosition.start,
                            titleOutsideJustification:
                                charts.OutsideJustification.middleDrawArea),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   // backgroundColor: Colors.amberAccent,
      //   // unselectedItemColor: Colors.black,
      //   // selectedItemColor: Colors.amber,
      //
      //   backgroundColor: Colors.amberAccent,
      //   selectedItemColor: Colors.blue,
      //   unselectedItemColor: Colors.black,
      //   type: BottomNavigationBarType.fixed,
      //
      //   items: [
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.assignment,
      //         ),
      //         title: Text(
      //           "Surgeries",
      //           style: TextStyle(color: Colors.black),
      //         )),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.border_color,
      //       ),
      //       title: Text(
      //         "Create",
      //         style: TextStyle(color: Colors.black),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.attach_file,
      //         ),
      //         title: Text(
      //           "Docs",
      //           style: TextStyle(color: Colors.black),
      //         )),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.info,
      //       ),
      //       title: Text(
      //         "Doctor Info",
      //         style: TextStyle(color: Colors.black),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.message,
      //         ),
      //         title: Text(
      //           "Message",
      //           style: TextStyle(color: Colors.black),
      //         )),
      //   ],
      //   currentIndex: selectedIndex,
      //   onTap: onItemTapped,
      // ),
    );
  }

  void onItemTapped(int index) {
    print("Inside function");
    print(index);
    setState(() {
      selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => DoctorHome()));
    } else if (index == 1) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => createSurgery()));
    } else if (index == 2) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => doctorVideo()));
    } else if (index == 3) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => doctorInfo()));
    } else {
      print("Messaging");
    }
  }

  Widget headerChild(String header, int value) => new Expanded(
          child: new Column(
        children: <Widget>[
          new Text(header),
          new SizedBox(
            height: 8.0,
          ),
          new Text(
            '$value',
            style: new TextStyle(
                fontSize: 14.0,
                color: const Color(0xFF26CBE6),
                fontWeight: FontWeight.bold),
          )
        ],
      ));

  Widget infoChild(double width, IconData icon, data) => new Padding(
        padding: new EdgeInsets.only(bottom: 8.0),
        child: new InkWell(
          child: new Row(
            children: <Widget>[
              new SizedBox(
                width: width / 10,
              ),
              new Icon(
                icon,
                color: Colors.black,
                size: 36.0,
              ),
              new SizedBox(
                width: width / 20,
              ),
              new Text(
                data,
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
          onTap: () {
            print('Info Object selected');
          },
        ),
      );
}

//
//
//import 'package:flutter/material.dart';
//import 'package:charts_flutter/flutter.dart' as charts;
//
//class HomePage extends StatefulWidget {
//  final Widget child;
//
//  HomePage({Key key, this.child}) : super(key: key);
//
//  _HomePageState createState() => _HomePageState();
//}
//
//class _HomePageState extends State<HomePage> {
//  List<charts.Series<Sales, int>> _seriesLineData;
//
//  _generateData() {
//    var linesalesdata = [
//      new Sales(0, 45),
//      new Sales(1, 56),
//      new Sales(2, 55),
//      new Sales(3, 60),
//      new Sales(4, 61),
//      new Sales(5, 70),
//    ];
//    var linesalesdata1 = [
//      new Sales(0, 35),
//      new Sales(1, 46),
//      new Sales(2, 45),
//      new Sales(3, 50),
//      new Sales(4, 51),
//      new Sales(5, 60),
//    ];
//
//    var linesalesdata2 = [
//      new Sales(0, 20),
//      new Sales(1, 24),
//      new Sales(2, 25),
//      new Sales(3, 40),
//      new Sales(4, 45),
//      new Sales(5, 60),
//    ];
//
//    _seriesLineData.add(
//      charts.Series(
//        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
//        id: 'Air Pollution',
//        data: linesalesdata,
//        domainFn: (Sales sales, _) => sales.yearval,
//        measureFn: (Sales sales, _) => sales.salesval,
//      ),
//    );
//    _seriesLineData.add(
//      charts.Series(
//        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
//        id: 'Air Pollution',
//        data: linesalesdata1,
//        domainFn: (Sales sales, _) => sales.yearval,
//        measureFn: (Sales sales, _) => sales.salesval,
//      ),
//    );
//    _seriesLineData.add(
//      charts.Series(
//        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
//        id: 'Air Pollution',
//        data: linesalesdata2,
//        domainFn: (Sales sales, _) => sales.yearval,
//        measureFn: (Sales sales, _) => sales.salesval,
//      ),
//    );
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    _seriesData = List<charts.Series<Pollution, String>>();
//    _seriesPieData = List<charts.Series<Task, String>>();
//    _seriesLineData = List<charts.Series<Sales, int>>();
//    _generateData();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Padding(
//        padding: EdgeInsets.all(8.0),
//        child: Container(
//          child: Center(
//            child: Column(
//              children: <Widget>[
//                Text(
//                  'Sales for the first 5 years',
//                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//                ),
//                Expanded(
//                  child: charts.LineChart(_seriesLineData,
//                      defaultRenderer: new charts.LineRendererConfig(
//                          includeArea: true, stacked: true),
//                      animate: true,
//                      animationDuration: Duration(seconds: 5),
//                      behaviors: [
//                        new charts.ChartTitle('Years',
//                            behaviorPosition: charts.BehaviorPosition.bottom,
//                            titleOutsideJustification:
//                                charts.OutsideJustification.middleDrawArea),
//                        new charts.ChartTitle('Sales',
//                            behaviorPosition: charts.BehaviorPosition.start,
//                            titleOutsideJustification:
//                                charts.OutsideJustification.middleDrawArea),
//                        new charts.ChartTitle(
//                          'Departments',
//                          behaviorPosition: charts.BehaviorPosition.end,
//                          titleOutsideJustification:
//                              charts.OutsideJustification.middleDrawArea,
//                        )
//                      ]),
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}

class Sales {
  int yearval;
  double salesval;

  Sales(this.yearval, this.salesval);
}
