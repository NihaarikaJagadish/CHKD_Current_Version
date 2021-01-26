import 'dart:async';
import 'package:calendar_widget/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:surgerychkd/createsurgery.dart';
import 'package:surgerychkd/doctorVideo.dart';
import 'package:surgerychkd/editSurgery.dart';
import 'package:surgerychkd/patientInfoDash.dart';
import 'package:surgerychkd/procedureTab.dart';
import 'package:web_socket_channel/io.dart';
import 'DoctorHome.dart';
import 'package:badges/badges.dart';
import 'Globals.dart';
import 'PatientHome.dart';
import 'Patientchat.dart';
import 'SURGERY.dart';
import 'aboutInfo.dart';
import 'doctorInfoPage.dart';
import 'home.dart';
import 'surgeryinfo.dart';
import 'package:surgerychkd/Login.dart';
import 'dart:math';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:surgerychkd/surgeryinfo.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Globals.dart';
import 'package:surgerychkd/Adminchat.dart';

class Post {
  final String sn;
  final String t;
  final String pid;
  final String na;
  final String a;
  final String d;
  final String venue;
  final String presc;
  final String instr;
  final String surgeon;
  final String status;
  final String phone;
  final String surgeryID;

  Post(
      this.sn,
      this.t,
      this.pid,
      this.na,
      this.a,
      this.d,
      this.venue,
      this.presc,
      this.instr,
      this.surgeon,
      this.status,
      this.phone,
      this.surgeryID);
}

class Surgeon extends StatefulWidget {
  @override
  _SurgeonState createState() => _SurgeonState();
}

class _SurgeonState extends State<Surgeon> {
  bool terminate = false;
  int selectedIndex = 0;
  DateTime selectedDate = DateTime.now();
  String _date = 'Today';
  final SearchBarController<Post> _searchBarController = SearchBarController();
  bool isReplay = false;
  var displayData;
  bool check = false;
  String titleString = 'List of Surgeries';
  int counter = 0;
  var noText = false;
  List surgeryHighlightedDates = [];
  SocketIO socket;
  CalendarHighlighter highlighter;

  String _dateTime = DateFormat("MM/dd/yyyy").format(new DateTime.now());

  void initState() {
    super.initState();
    print("in init");
    print(surgeryVariable.finalArr);
    surgeryDates();
    getData1();
    waitAndExecute();
  }

  Future<void> clearMsgs(String surID) async {
    var url = hostName + '/messages/';
    print(url);
    var bodyData = {};
    bodyData["id"] = surID + ",999";
    final Response response = await post(url, body: bodyData);
  }

  Future<void> getBadgeInfo() async {
    var url = hostName + '/messages/count';
    print(url);
    Response response = await get(url);
    var data = jsonDecode(response.body)["data"];
    setState(() {
      badgeCount = data;
      print("llllllllll");
      print(badgeCount);
    });
  }

  Future<void> getData1() async {
    getBadgeInfo();
    var url = hostName + '/surgery/surgeonsurgery';
    print(url);
    Response response = await get(
      url,
      headers: <String, String>{
        "Content-Type": "application/json",
        "X-auth-header": surgeonUUID,
        "data": _dateTime
      },
    );
    var data = jsonDecode(response.body)["data"];
    print(data);
    setState(() {
      surgeryVariable.finalArr = data;
      print("uuu");
      print(surgeryVariable.finalArr.length);
      if (surgeryVariable.finalArr.length == 0) {
        var a = [
          1,
          2,
          3,
        ];
        surgeryVariable.finalArr.add(a);
        noText = true;
      } else {
        noText = false;
      }
    });
//    var jsonData = jsonDecode(data)["data"];
//    setState(() {
//      surgeryVariable.finalArr = jsonData;
//    });
//    if (surgeryVariable.finalArr.toString() != jsonData.toString()) {
//      print("True");
//
//      print(surgeryVariable.finalArr);
//    }
  }

  void waitAndExecute() {
//    var future =
//        new Future.delayed(const Duration(milliseconds: 5000), getData1());
    const oneSec = const Duration(seconds: 3);
    new Timer.periodic(
        oneSec,
        (Timer t) => {
              if (terminate) {t.cancel()} else {getData1()}
            });
  }

  void surgeryDates() async {
    var url = hostName + '/surgery/surgerydates';
    print(url);
    Response response = await get(
      url,
      headers: <String, String>{
        "Content-Type": "application/json",
        "X-auth-header": surgeonUUID,
      },
    );
    var data = jsonDecode(response.body)["data"];
    print("gggggggg");
    print(data);
    if (response.statusCode == 200) {
      setState(() {
        surgeryHighlightedDates = data;
        print(surgeryHighlightedDates);
      });
    }
  }

  Future<List<Post>> _getALlPosts(String text) async {
    await Future.delayed(Duration(seconds: text.length == 4 ? 1 : 1));
    List<Post> posts = [];

    var random = new Random();
    for (int i = 0; i < surgeryVariable.finalArr.length; i++) {
      var temp = surgeryVariable.finalArr[i];
      var temp1 = temp.values.toList();
      // print(temp1[5]);
      // print(temp1.length);
      for (var j = 0; j < temp1.length; j++) {
        // print(temp1[j]);
        // print(j);
        if (temp1[j]
            .toString()
            .contains(new RegExp(text, caseSensitive: false))) {
          // print("Inside the if condition");
          String sn = temp["type"];
          String t = temp["dateTime"].toString();
          String pid = temp["patientDetails"][0]["id"];
          var fname = temp["patientDetails"][0]["fname"];
          var lname = temp["patientDetails"][0]["lname"];
          String na = fname + " " + lname;
          String a = patientDOB;
          String d = temp["dateTime"].toString();
          String venue = temp["venue"];
          String presc = temp["prescription"];
          String instr = temp["instructions"];
          String surgeon = temp["surgeon"];
          String status = temp["status"];
          String ph = temp["patientDetails"][0]["contact"];
          String id = temp["id"];
          posts.add(Post("$sn", "$t", "$pid", "$na", "$a", "$d", "$venue",
              "$presc", "$instr", "$surgeon", "$status", "$ph", "$id"));
          check = true;
//          break;
        }
      }
    }
    return posts;
  }

  // ignore: missing_return
  Future<int> handleSignOut() async {
    firebaseAuthGlobal.signOut();
  }

  @override
  Widget build(BuildContext context) {
    CalendarHighlighter highlighter = (DateTime dt) {
      // randomly generate a boolean list of length monthLength + 1 (because months start at 1)
      var checkVariable;
      return List.generate(Calendar.monthLength(dt) + 1, (index) {
//        return (Random().nextDouble() < 0.3);
        print("Hello");
        print(index);
//        print(dt);
        var finalDate = dt.toString().split(" ")[0];
        var finalMonth = finalDate.split("-")[1];
        var finalYear = finalDate.split("-")[0];
        var finalDay =
            (int.parse(finalDate.split("-")[2]) + index - 1).toString();

        checkVariable = false;
        for (var element in surgeryHighlightedDates) {
//          print(element["dateTime"]);
          int timeInMillis = element["dateTime"];
          var date1 = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
          var formattedDate = DateFormat.yMd().add_yMd().format(date1);
//          print(formattedDate);
          formattedDate = formattedDate.split(" ")[0];
          var month = formattedDate.split("/")[0];
          var day = formattedDate.split("/")[1];
          var year = formattedDate.split("/")[2];
          if ((month == finalMonth) &&
              (day == finalDay) &&
              (year == finalYear)) {
            checkVariable = true;
            print(formattedDate);
            print(finalMonth + "/" + finalDay + "/" + finalYear);
            break;
          } else {
            checkVariable = false;
          }
        }
        return (checkVariable == true);
      });
    };
    // print("Inside the list of surgeries page");
    // print(surgeryVariable.surgery);
    return new WillPopScope(
      onWillPop: () async {
        Fluttertoast.showToast(
          msg: 'Click logout to exit',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "List of Surgeries",
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
                              terminate = true;
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
//      drawer: Drawer(
//        // Add a ListView to the drawer. This ensures the user can scroll
//        // through the options in the drawer if there isn't enough vertical
//        // space to fit everything.
//        child: ListView(
//          // Important: Remove any padding from the ListView.
//          padding: EdgeInsets.zero,
//          children: <Widget>[
//            UserAccountsDrawerHeader(
//              accountName: Text("CHKD Surgery POC"),
//              accountEmail: Text("Menu"),
//              currentAccountPicture: CircleAvatar(
//                backgroundColor:
//                    Theme.of(context).platform == TargetPlatform.iOS
//                        ? Colors.blue
//                        : Colors.white,
//                child: Text(
//                  "P",
//                  style: TextStyle(fontSize: 40.0),
//                ),
//              ),
//            ),
//            ListTile(
//              title: Text('About CHKD'),
//              onTap: () {
//                Navigator.push(context,
//                    new MaterialPageRoute(builder: (context) => CHKD()));
//              },
//            ),
//            ListTile(
//              title: Text('Surgeries'),
//              onTap: () {
//                Navigator.push(context,
//                    new MaterialPageRoute(builder: (context) => Surgery()));
//              },
//            ),
////            ListTile(
////              title: Text('Surgery Information'),
////              onTap: () {
////                Navigator.push(
////                    context, new MaterialPageRoute(builder: (context) => Reports()));
////              },
////            ),
//            ListTile(
//              title: Text('Profile'),
//              onTap: () {
//                Navigator.push(context,
//                    new MaterialPageRoute(builder: (context) => PatientInfo()));
//              },
//            ),
//
//            ListTile(
//              title: Text('Logout'),
//              onTap: () {
//                Navigator.push(context,
//                    new MaterialPageRoute(builder: (context) => LoginScreen()));
//              },
//            ),
//            ListTile(
//              title: Text('Exit Menu'),
//              onTap: () {
//                Navigator.pop(context);
//              },
//            ),
//          ],
//        ),
//      ),
        floatingActionButton: RaisedButton(
          elevation: 3.0,
          padding: EdgeInsets.all(15.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.amberAccent,
//        onPressed: () => _selectTime(context),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          right: -40.0,
                          top: -40.0,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: CircleAvatar(
                              child: Icon(Icons.close),
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                        Container(
                          height: 300.0,
                          margin: EdgeInsets.only(top: 16),
                          alignment: Alignment.topCenter,
                          child: Calendar(
                            width: 300.0,
                            height: 300.0,
                            enableFuture: true,
                            onTapListener: (DateTime dt) {
                              _dateTime = DateFormat("MM/dd/yyyy").format(dt);
                              Navigator.of(context).pop();
                            },
                            highlighter: highlighter,
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Text(
            _dateTime,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: SearchBar<Post>(
            searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
            headerPadding: EdgeInsets.symmetric(horizontal: 10),
            listPadding: EdgeInsets.symmetric(horizontal: 10),
            onSearch: _getALlPosts,
            searchBarController: _searchBarController,
            placeHolder: ListView.builder(
                shrinkWrap: true,
                itemCount: (surgeryVariable.finalArr.length),
                itemBuilder: (
                  BuildContext ctxt,
                  int index,
                ) {
                  print("Nihaarika");
                  print(surgeryVariable.finalArr.length);
                  if (noText) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(90, 220, 90, 120),
                      child: Text(
                        "No Records To Display",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  } else {
                    return _addCard1(ctxt, index);
                  }
                  // print(index);
                }),
            cancellationWidget: Text("Cancel"),
            emptyWidget: Container(
              padding: EdgeInsets.fromLTRB(120, 220, 10, 120),
              child: Text(
                "No Records To Display",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
            ),
            onCancelled: () {
              print("Cancelled triggered");
            },
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 1,
            onItemFound: (Post post, int index) {
              if (check == false) {
                return Container(
                  padding: EdgeInsets.fromLTRB(120, 220, 10, 120),
                  child: Text(
                    "No Records To Display",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                return _addCard(post, index);
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> getPreviousData() async {
    var url = hostName + '/surgery/previous';
    // print(url);
    Response response = await get(url);
    var data = response.body;
    // print(response.body);
    setState(() {
      surgeryVariable.finalArr = jsonDecode(data)["data"];
    });

    // print(surgeryVariable.finalArr);
  }

  Future<void> getUpcomingData() async {
    var url = hostName + '/surgery/upcoming';
    // print(url);
    Response response = await get(url);
    var data = response.body;
    setState(() {
      surgeryVariable.finalArr = jsonDecode(data)["data"];
    });

    // print(surgeryVariable.finalArr);
  }

  CupertinoStepper _buildStepper(StepperType type, int currentStep) {
    var statusList = [
      "Surgery Scheduled",
      "Patient Checked in",
      "Patient In Surgery",
      "Post Surgery",
      "Patient Discharged"
    ];
    return CupertinoStepper(
      type: type,
      currentStep: currentStep,
      onStepTapped: (step) {
        setState(() => currentStep = step);
      },
      steps: [
        for (var i = 0; i < 3; ++i)
          _buildStep(
            title: Text(statusList[i]),
            isActive: i == currentStep,
            state: i == currentStep
                ? StepState.editing
                : i < currentStep ? StepState.complete : StepState.indexed,
          ),
      ],
    );
  }

  Step _buildStep({
    @required Widget title,
    StepState state = StepState.indexed,
    bool isActive = false,
  }) {
    return Step(
        title: title,
        subtitle: Text(''),
        state: state,
        isActive: isActive,
        content: SizedBox(
          height: 10.0,
        ));
  }

  _selectTime(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019), // Refer step 1
      lastDate: DateTime(2025),
      helpText: 'Select Surgery Date',
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.amber,
          ), // This will change to light theme.
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        var pick = "${picked.toLocal()}".split(' ')[0];
        print(pick);
        selectedDate = picked;
        _date = pick;
//        _dateTime = _date.toString();
        _dateTime = DateFormat("MM/dd/yyyy").format(picked);

        getData1();
      });
  }

  _addCard(Post ctxt, int index) {
    // print(ctxt);
    //this.sn, this.t, this.pid, this.na, this.a, this.d, this.venue,
    //      this.presc, this.instr, this.surgeon

    int timeInMillis = int.parse(ctxt.t);
    var date1 = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    var formattedDate = DateFormat.yMd().add_Hm().format(date1); // Apr 8, 2020
    print(formattedDate);
    var date = formattedDate.split(" ")[0];
    var time = formattedDate.split(" ")[1];
    var surgeryName1 = ctxt.sn;
    var pid = ctxt.pid;
    var pname = ctxt.na;
    var page = ctxt.a;
    var venue = ctxt.venue;
    var prescription = ctxt.presc;
    var instructions = ctxt.instr;
    var surgeonName = ctxt.surgeon;
    var st = ctxt.status;
    var phone = ctxt.phone;
    var surID = ctxt.surgeryID;
    var message_count = 0;
    var message_count_status = 0;
    badgeCount.forEach((element) {
      print("ppppppp");

      if (element["id"].split(",")[0] == surID) {
        print(element["id"].split(",")[0]);
        message_count = element["count"];
        print("kkkkk");
        print(message_count);
        print(element["count"]);
      }
      if (element["id"].split(",")[1] == surID) {
        message_count_status = element["count"];
      }
    });
    var statusList = [
      "Surgery Scheduled",
      "Patient Checked in",
      "Patient In Surgery",
      "Post Surgery",
      "Patient Discharged"
    ];
    var status = statusList.indexOf(st);
    //{patient two: [[cardiac surgery, 04:19 am, patient two, Patient Two, 42, 2020-09-22, venue, prescription, instruction, surgeon name]]}

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            // SizedBox(
            //   height: 200,
            //   width: 1000,
            //   child: Container(
            //     child: Image.asset(
            //       "./assets/images/heart.jpg",
            //     ),
            //   ),
            // ),
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          surgeryName1 + "\n" + date + "\n" + time,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.blueAccent),
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Container(
                            height: 3,
                          ),
                        ),

                        GestureDetector(
                          child: Badge(
                            toAnimate: false,
                            badgeContent: Text((message_count).toString()),
                            child: Icon(
                              Icons.message,
                              size: 30.0,
                              color: (message_count_status > 0)
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              message_count = 0;
                              clearMsgs(surID);
                            });
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        AdminChat(surgeryID: surID)));
                          },
                        ),

//                        GestureDetector(
//                          child: Icon(
//                            Icons.info,
//                            size: 30.0,
//                          ),
//                          onTap: () {
//                            surgeryName = surgeryName1;
//                            Navigator.push(
//                                context,
//                                new MaterialPageRoute(
//                                    builder: (context) => procedure()));
//                          },
//                        ),
                      ],
                    )),
                collapsed: Text(
                  pname + '\n' + surgeonName + "\n" + venue,
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15.0),
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    myItems(date, time, venue, pname, page, prescription,
                        instructions, surgeonName, status, surID, st),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> getData() async {
    var url = hostName + '/surgery/upcoming';
    // print(url);
    Response response = await get(url);
    var data = response.body;
    setState(() {
      surgeryVariable.finalArr = jsonDecode(data)["data"];
    });
    print(surgeryVariable.finalArr);
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => Surgery()));
  }

  Future<int> deleteSurgery(id) async {
    var url = hostName + '/surgery/delete/' + id;
    // print(url);
    final Response response = await delete(url);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      await getData();
      return 0;
    }
  }

  void onItemTapped(int index) {
    print("Inside function");
    // print(index);
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

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      helpText: 'Select Surgery Date',
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.amber,
          ), // This will change to light theme.
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        var pick = "${picked.toLocal()}".split(' ')[0];
        // print(pick);
        _date = pick;
        selectedDate = picked;
      });
  }

  Material myItems(
      String date,
      String time,
      String venue,
      String pname,
      String page,
      String prescription,
      String instructions,
      String surgeonName,
      int status,
      String surID,
      String st) {
    Color color = Colors.black;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date: " + date,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nTime: " + time,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nSurgeon Name :" + surgeonName,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nVenue: " + venue,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nPatient Name: " + pname,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nPatient DOB: " + page,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nPrescription: " + prescription,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nInstructions: " + instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nStatus: " + st,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            progressBar(s: status, id: surID),
          ],
        ),
      ),
    );
  }

  Material myItems1(
      String surgeryN,
      String date,
      String time,
      String venue,
      String pname,
      String page,
      String prescription,
      String instructions,
      String surgeonName,
      int status,
      String surID,
      String st) {
    Color color = Colors.black;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(children: [
//            Text(
//              "Date: " + date,
//              style: TextStyle(color: color, fontSize: 15.0),
//              textAlign: TextAlign.left,
//            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date: " + date,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nTime: " + time,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nSurgeon Name :" + surgeonName,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nVenue: " + venue,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nPatient Name: " + pname,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nPatient DOB: " + page,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nPrescription: " + prescription,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nInstructions: " + instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nStatus: " + st,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            progressBar(s: status, id: surID),
          ])),
    );
  }

  Row progressBar({int s = 0, String id}) {
    // print("The value of s is ");
    // print(s);
    counter = s;
    var statusList = [
      "Patient Checked in",
      "Patient In Surgery",
      "Post Surgery",
      "Patient Discharged"
    ];
    final int firstSet = 1;
    final int secondSet = 2;
    final int thirdSet = 3;
    final int fourthSet = 4;
    return Row(
      children: [
        Container(
          color: Colors.green,
          height: 30.0,
          width: 30.0,
          child: Icon(
            Icons.access_alarm,
          ),
        ),
        Expanded(
          child: Container(
            height: 3,
            color: firstSet <= counter ? Colors.green : Colors.grey,
          ),
        ),
        GestureDetector(
          child: Container(
            height: 30.0,
            width: 30.0,
            color: firstSet <= counter ? Colors.green : Colors.grey,
            child: Icon(
              Icons.directions_walk,
            ),
          ),
          onTap: () {
            // print(counter);
          },
        ),
        Expanded(
          child: Container(
            height: 3,
            color: secondSet <= counter ? Colors.green : Colors.grey,
          ),
        ),
        GestureDetector(
          child: Container(
            height: 30.0,
            width: 30.0,
            color: secondSet <= counter ? Colors.green : Colors.grey,
            child: Icon(
              Icons.airline_seat_flat,
            ),
          ),
          onTap: () {
            setState(() {
              print(counter);
            });
          },
        ),
        Expanded(
          child: Container(
            height: 3,
            color: thirdSet <= counter ? Colors.green : Colors.grey,
          ),
        ),
        GestureDetector(
          child: Container(
            height: 30.0,
            width: 30.0,
            color: thirdSet <= counter ? Colors.green : Colors.grey,
            child: Icon(
              Icons.accessible_forward,
            ),
          ),
          onTap: () {
            setState(() {
              print(counter);
            });
          },
        ),
        Expanded(
          child: Container(
            height: 3,
            color: fourthSet <= counter ? Colors.green : Colors.grey,
          ),
        ),
        GestureDetector(
          child: Container(
            height: 30.0,
            width: 30.0,
            color: fourthSet <= counter ? Colors.green : Colors.grey,
            child: Icon(
              Icons.check_box,
            ),
          ),
          onTap: () {
            setState(() {
              print(counter);
            });
          },
        ),
      ],
    );
  }

//  void updateStatus(String status, String id) async {
//    print("****\n\n\n\n\n\n\n\n\n\n");
//    var tempDict = {};
//    tempDict["id"] = id;
//    tempDict["status"] = status;
//    var url = hostName;
//    SocketIOManager manager = SocketIOManager();
//    socket = await manager.createInstance(SocketOptions(url));
//    socket.on("connection", (data) {
//      //sample event
//      print("news");
//      print(data);
//    });
//  }

  _addCard1(BuildContext ctxt, int index) {
    // print(index);

    // print(surgeryVariable.finalArr);
    var surgeryName1 = surgeryVariable.finalArr[index]["type"];
    int timeInMillis = surgeryVariable.finalArr[index]["dateTime"];
    var date1 = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    var formattedDate = DateFormat.yMd().add_Hm().format(date1); // Apr 8, 2020
    print(formattedDate);
    var surgery_date = formattedDate.split(" ")[0];
    var time = formattedDate.split(" ")[1];
    print(surgeryVariable.finalArr[index]["patientDetails"][0]["lname"]);
    var fname = surgeryVariable.finalArr[index]["patientDetails"][0]["fname"];
    var lname = surgeryVariable.finalArr[index]["patientDetails"][0]["lname"];
    var pname = fname + " " + lname;
//    var pname = patientName;
    var page = surgeryVariable.finalArr[index]["patientDetails"][0]["dob"];
    var venue = surgeryVariable.finalArr[index]["venue"];
    var prescription = surgeryVariable.finalArr[index]['prescription'];
    var instructions = surgeryVariable.finalArr[index]["instructions"];
    var surgeonName = surgeryVariable.finalArr[index]["surgeon"];
    var st = surgeryVariable.finalArr[index]["status"];
    // var phone = surgeryVariable.finalArr[index]["patientDetails"][0]["contact"];
    // var patientID = surgeryVariable.finalArr[index]["patientDetails"][0]["id"];
    var surgeryID = surgeryVariable.finalArr[index]["id"];
    var message_count = 0;
    var message_count_status = 0;
    badgeCount.forEach((element) {
      print("ppppppp");

      if (element["id"].split(",")[0] == surgeryID) {
        message_count = element["count"];
      }
      if (element["id"].split(",")[1] == surgeryID) {
        print(element);
        message_count_status = element["count"];
      }
    });
    var statusList = [
      "Surgery Scheduled",
      "Patient Checked in",
      "Patient In Surgery",
      "Post Surgery",
      "Patient Discharged"
    ];
    var status = statusList.indexOf(st);
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          surgeryName1 + "\n" + surgery_date + "\n" + time,
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.blueAccent),
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Container(
                            height: 3,
                          ),
                        ),

                        GestureDetector(
                          child: Badge(
                            toAnimate: false,
                            badgeContent: Text((message_count).toString()),
                            child: Icon(
                              Icons.message,
                              size: 30.0,
                              color: (message_count_status > 0)
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              message_count = 0;
                              clearMsgs(surgeryID);
                            });
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        AdminChat(surgeryID: surgeryID)));
                          },
                        ),

//                        StreamBuilder<QuerySnapshot>(
//                          stream: Firestore.instance
//                              .collection('messages')
//                              .document(surgeryID)
//                              .collection(surgeryID)
//                              .snapshots(),
//                          builder: (BuildContext context,
//                              AsyncSnapshot<QuerySnapshot> snapshot) {
//                            if (!snapshot.hasData) {
//                              return new Text('Loading...');
//                            } else {
//                              message_count += 1;
//                              // if(message_count == 1){
//                              //   message_count = 0;
//                              // }
//                              return new GestureDetector(
//                                child: Badge(
//                                  toAnimate: false,
//                                  badgeContent:
//                                      Text((message_count).toString()),
//                                  child: Icon(
//                                    Icons.message,
//                                    size: 30.0,
//                                  ),
//                                ),
//                                onTap: () {
//                                  setState(() {
//                                    message_count = -1;
//                                  });
//                                  Navigator.push(
//                                      context,
//                                      new MaterialPageRoute(
//                                          builder: (context) =>
//                                              Chat(surgeryID: surgeryID)));
//                                },
//                              );
//                            }
//                          },
//                        ),
                      ],
                    )),
                // collapsed: Text(
                //   pname + '\n' + surgeonName + "\n" + venue,
                //   softWrap: true,
                //   maxLines: 3,
                //   overflow: TextOverflow.ellipsis,
                //   style: TextStyle(fontSize: 15.0),
                // ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    myItems1(
                        surgeryName1,
                        surgery_date,
                        time,
                        venue,
                        pname,
                        page,
                        prescription,
                        instructions,
                        surgeonName,
                        status,
                        surgeryID,
                        st),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

//import 'package:flutter/material.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:surgerychkd/aboutInfo.dart';
//import 'package:surgerychkd/REPORTS.dart';
//import 'package:surgerychkd/patientInfoDash.dart';
//import 'package:expandable/expandable.dart';
//
//import 'Globals.dart';
//import 'Login.dart';
//import 'home.dart';
//
//class Surgery extends StatefulWidget {
//  @override
//  _SurgeryState createState() => _SurgeryState();
//}
//
//class _SurgeryState extends State<Surgery> {
//
//
//  // ignore: missing_return
//  Future<int> handleSignOut() async {
//    firebaseAuthGlobal.signOut();
//  }
//
//
//  int selectedIndex = 1;
//  String instructions = "Drink plenty of water before surgery";
//  Material myItems(String date, String time, String venue) {
//    Color color = Colors.black;
//    return Material(
//      color: Colors.white,
//      borderRadius: BorderRadius.circular(5),
//        child: Padding(
//          padding: const EdgeInsets.all(1.0),
//             child:  Text(
//               "Date: "+ date+"\nTime: "+time+"\nVenue: "+venue+"\nPrescription: Simvastatin 40mg, Sig: Take 1 tablet per day, Disp: 90 tabs\nInstructions: "+instructions+"\n\n#Related Information is presented here.",
//               style:
//               TextStyle(color: color, fontSize: 15.0),
//             ),
//          ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(
//          'Upcoming Surgeries',
//          style: TextStyle(
//            color: Colors.black,
//          ),
//        ),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.exit_to_app),
//            onPressed: () {
//              showDialog(
//                  context: context,
//                  builder: (context) {
//                    return AlertDialog(
//                      title: new Text("Logout confirmation"),
//                      content: new Text("Are you sure?"),
//                      actions: <Widget>[
//                        // usually buttons at the bottom of the dialog
//                        new FlatButton(
//                          child: new Text("Yes"),
//                          onPressed: () {
//                            handleSignOut().then((int val){
//                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()),
//                                  ModalRoute.withName("/Login"));
//                            });
//                          },
//                        ),
//                        new FlatButton(
//                          child: new Text("No"),
//                          onPressed: () {
//                            Navigator.pop(context);
//                          },
//                        ),
//                      ],
//                    );
//                  }
//              );
//            },
//          ),
//        ],
//      ),
//      drawer: Drawer(
//        // Add a ListView to the drawer. This ensures the user can scroll
//        // through the options in the drawer if there isn't enough vertical
//        // space to fit everything.
//        child: ListView(
//          // Important: Remove any padding from the ListView.
//          padding: EdgeInsets.zero,
//          children: <Widget>[
//            UserAccountsDrawerHeader(
//              accountName: Text("CHKD Surgery POC"),
//              accountEmail: Text("Menu"),
//              currentAccountPicture: CircleAvatar(
//                backgroundColor:
//                Theme.of(context).platform == TargetPlatform.iOS
//                    ? Colors.blue
//                    : Colors.white,
//                child: Text(
//                  "P",
//                  style: TextStyle(fontSize: 40.0),
//                ),
//              ),
//            ),
//            ListTile(
//              title: Text('About CHKD'),
//              onTap: () {
//                Navigator.push(
//                    context, new MaterialPageRoute(builder: (context) => CHKD()));
//              },
//            ),
//            ListTile(
//              title: Text('Surgeries'),
//              onTap: () {
//                Navigator.push(
//                    context, new MaterialPageRoute(builder: (context) => Surgery()));
//              },
//            ),
//            ListTile(
//              title: Text('Surgery Information'),
//              onTap: () {
//                Navigator.push(
//                    context, new MaterialPageRoute(builder: (context) => Reports()));
//              },
//            ),
//            ListTile(
//              title: Text('Profile'),
//              onTap: () {
//                Navigator.push(
//                    context, new MaterialPageRoute(builder: (context) => PatientInfo()));
//              },
//            ),
//            ListTile(
//              title: Text('Messaging Portal'),
//              onTap: () {
//                Navigator.push(
//                    context, new MaterialPageRoute(builder: (context) => HomeScreenChat(currentUserId: firebaseUserID.toString())));
//              },
//            ),
//            ListTile(
//              title: Text('Logout'),
//              onTap: () {
//                Navigator.push(
//                    context, new MaterialPageRoute(builder: (context) => LoginScreen()));
//              },
//            ),
//            ListTile(
//              title: Text('Exit Menu'),
//              onTap: () {
//                Navigator.pop(context);
//              },
//            ),
//          ],
//        ),
//      ),
//      body: ExpandableTheme(
//        data:
//        const ExpandableThemeData(
//          iconColor: Colors.blue,
//          useInkWell: true,
//        ),
//        child: ListView(
//          physics: const BouncingScrollPhysics(),
//          children: <Widget>[
//        ExpandableNotifier(
//        child: Padding(
//            padding: const EdgeInsets.all(10),
//        child: Card(
//          clipBehavior: Clip.antiAlias,
//          child: Column(
//            children: <Widget>[
//              // SizedBox(
//              //   height: 180,
//              //   width: 1000,
//              //   child: Container(
//              //     child: Image.asset("./assets/images/NEUROLOG.png",),
//              //   ),
//              // ),
//              ScrollOnExpand(
//                scrollOnExpand: true,
//                scrollOnCollapse: false,
//                child: ExpandablePanel(
//                  theme: const ExpandableThemeData(
//                    headerAlignment: ExpandablePanelHeaderAlignment.center,
//                    tapBodyToCollapse: true,
//                  ),
//                  header: Padding(
//                      padding: EdgeInsets.all(10),
//                      child: Text(
//                        "Neurosurgery",
//                        style: TextStyle(fontSize: 18.0), textAlign: TextAlign.left ,
//                      )),
//                  collapsed: Text(
//                    "September 5th",
//                    softWrap: true,
//                    maxLines: 2,
//                    overflow: TextOverflow.ellipsis,
//                    style: TextStyle(fontSize: 15.0),
//                  ),
//                  expanded: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                    myItems(
//                              "September 5th", "12:30 pm", "OP Theater No 2"),
//                    ],
//                  ),
//                  builder: (_, collapsed, expanded) {
//                    return Padding(
//                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                      child: Expandable(
//                        collapsed: collapsed,
//                        expanded: expanded,
//                        theme: const ExpandableThemeData(crossFadePoint: 0),
//                      ),
//                    );
//                  },
//                ),
//              ),
//            ],
//          ),
//        ),
//      )),
//            ExpandableNotifier(
//                child: Padding(
//                  padding: const EdgeInsets.all(10),
//                  child: Card(
//                    clipBehavior: Clip.antiAlias,
//                    child: Column(
//                      children: <Widget>[
//                        // SizedBox(
//                        //   height: 200,
//                        //   width: 1000,
//                        //   child: Container(
//                        //     child: Image.asset("./assets/images/heart.jpg",),
//                        //   ),
//                        // ),
//                        ScrollOnExpand(
//                          scrollOnExpand: true,
//                          scrollOnCollapse: false,
//                          child: ExpandablePanel(
//                            theme: const ExpandableThemeData(
//                              headerAlignment: ExpandablePanelHeaderAlignment.center,
//                              tapBodyToCollapse: true,
//                            ),
//                            header: Padding(
//                                padding: EdgeInsets.all(10),
//                                child: Text(
//                                  "Cardiac Surgery",
//                                  style: TextStyle(fontSize: 18.0), textAlign: TextAlign.left ,
//                                )),
//                            collapsed: Text(
//                              "September 27th",
//                              softWrap: true,
//                              maxLines: 2,
//                              overflow: TextOverflow.ellipsis,
//                              style: TextStyle(fontSize: 15.0),
//                            ),
//                            expanded: Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                myItems(
//                                    "September 27th", "10:00 am", "OP Theater No 3"),
//                              ],
//                            ),
//                            builder: (_, collapsed, expanded) {
//                              return Padding(
//                                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                                child: Expandable(
//                                  collapsed: collapsed,
//                                  expanded: expanded,
//                                  theme: const ExpandableThemeData(crossFadePoint: 0),
//                                ),
//                              );
//                            },
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                )),
//            // Card3(),
//          ],
//        ),
//      ),
//
//
//      // Container(
//      //   child: StaggeredGridView.count(
//      //     crossAxisCount: 2,
//      //     crossAxisSpacing: 12.0,
//      //     mainAxisSpacing: 12.0,
//      //     padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//      //     children: [
//      //
//      //       myItems(
//      //           "Cardiac Surgery", "September 27th", "10:00 am", "OP Theater No 3"),
//      //     ],
//      //     staggeredTiles: [
//      //       StaggeredTile.extent(2, 250.0),
//      //       StaggeredTile.extent(2, 250.0),
//      //       StaggeredTile.extent(2, 250.0),
//      //     ],
//      //   ),
//      // ),
//      // bottomNavigationBar: BottomNavigationBar(
//      //
//      //   backgroundColor: Colors.amberAccent,
//      //   selectedItemColor:  Colors.blue,
//      //   unselectedItemColor: Colors.black,
//      //   type:BottomNavigationBarType.fixed,
//      //
//      //   items: [
//      //     BottomNavigationBarItem(
//      //         icon: Icon(
//      //           Icons.business,
//      //         ),
//      //         title: Text(
//      //           "CHKD",
//      //           style: TextStyle(color: Colors.black),
//      //         )),
//      //     BottomNavigationBarItem(
//      //         icon: Icon(
//      //           Icons.assignment,
//      //         ),
//      //         title: Text(
//      //           "Surgeries",
//      //           style: TextStyle(color: Colors.black),
//      //         )),
//      //     BottomNavigationBarItem(
//      //         icon: Icon(
//      //           Icons.archive,
//      //         ),
//      //         title: Text(
//      //           "Reports",
//      //           style: TextStyle(color: Colors.black),
//      //         )),
//      //     BottomNavigationBarItem(
//      //         icon: Icon(
//      //           Icons.info,
//      //         ),
//      //         title: Text(
//      //           "Profile",
//      //           style: TextStyle(color: Colors.black),
//      //         )),
//      //     BottomNavigationBarItem(
//      //         icon: Icon(
//      //           Icons.message,
//      //         ),
//      //         title: Text(
//      //           "Message",
//      //           style: TextStyle(color: Colors.black),
//      //         )),
//      //   ],
//      //   currentIndex: selectedIndex,
//      //   // fixedColor: Colors.blue,
//      //   onTap: onItemTapped,
//      // ),
//    );
//  }
//
//  void onItemTapped(int index) {
//    print("Inside function");
//    print(index);
//    setState(() {
//      selectedIndex = index;
//    });
//    if (index == 0) {
//      Navigator.push(
//          context, new MaterialPageRoute(builder: (context) => CHKD()));
//    } else if (index == 1) {
//      Navigator.push(
//          context, new MaterialPageRoute(builder: (context) => Surgery()));
//    } else if (index == 2) {
//      Navigator.push(
//          context, new MaterialPageRoute(builder: (context) => Reports()));
//    } else if (index == 3) {
//      Navigator.push(
//          context, new MaterialPageRoute(builder: (context) => PatientInfo()));
//    } else {
//      print("Messaging");
//    }
//  }
//}
//
