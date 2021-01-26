import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:surgerychkd/Adminchat.dart';
import 'package:surgerychkd/createsurgery.dart';
import 'package:surgerychkd/doctorVideo.dart';
import 'package:surgerychkd/editSurgery.dart';
import 'package:surgerychkd/preopDrawerFile.dart';
import 'package:web_socket_channel/io.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Globals.dart';
import 'analytics.dart';
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
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
//class Post {
//  final String title;
//  final String body;
//
//  Post(this.title, this.body);
//}

class DoctorHome extends StatefulWidget {
  @override
  _DoctorHomeState createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  bool terminate = false;
  int selectedIndex = 0;
  DateTime selectedDate = DateTime.now();
  String _date = 'Today';
  final SearchBarController<Post> _searchBarController = SearchBarController();
  bool isReplay = false;
  var displayData;
  bool check = false;
  String titleString = 'List of Upcoming Surgeries';
  int counter = 0;

  List<StreamSubscription<QuerySnapshot>> subscriptions =
      new List(surgeryVariable.finalArr.length);

  Future<List<Post>> _getALlPosts(String text) async {
    await Future.delayed(Duration(seconds: text.length == 4 ? 1 : 1));
    List<Post> posts = [];

    var random = new Random();
    for (int i = 0; i < surgeryVariable.finalArr.length; i++) {
      var temp = surgeryVariable.finalArr[i];
      var temp1 = temp.values.toList();
      for (var j = 0; j < temp1.length; j++) {
        if (temp1[j]
            .toString()
            .contains(new RegExp(text, caseSensitive: false))) {
          String sn = temp["type"];
          String t = temp["dateTime"].toString();
          String pid = temp["patientDetails"][0]["id"];
          var fname = temp["patientDetails"][0]["fname"];
          var lname = temp["patientDetails"][0]["lname"];
          String na = fname + " " + lname;
          String a = temp["patientDetails"][0]["dob"];
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

//  Future<void> socketConfig() async {
//    Socket socket = io('http://localhost:3000', <String, dynamic>{
//      'transports': ['websocket'],
//      'autoConnect': false,
//      'extraHeaders': {'foo': 'bar'} // optional
//    });
//    socket.connect();
//  }

  // ignore: missing_return
  Future<int> handleSignOut() async {
    firebaseAuthGlobal.signOut();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _connectSocket01();
    getData1();
    waitAndExecute();
  }

  _connectSocket01() {
    IO.Socket socket = IO.io("http://18.220.186.21:3000", <String, dynamic>{
      'autoConnect': false,
      // optional
    });
    socket.connect();
    socket.on('connect', (_) {
      print('connect');
    });
  }
//  _connectSocket01() {
//    //update your domain before using
//    /*socketIO = new SocketIO("http://127.0.0.1:3000", "/chat",
//        query: "userId=21031", socketStatusCallback: _socketStatus);*/
//    socketIO =
//        SocketIOManager().createSocketIO("http://18.220.186.21:3000", "/");
//
//    //call init socket before doing anything
//    socketIO.init();
//
//    //subscribe event
////    socketIO.subscribe("updateStatus", _onSocketInfo);
//
//    //connect socket
//    socketIO.connect();
//  }
//
//  _onSocketInfo(dynamic data) {
//    print("Socket info: " + data);
//  }
//
//  _socketStatus(dynamic data) {
//    print("Socket status: " + data);
//  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        Fluttertoast.showToast(
          msg: 'Click Logout to exit',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            titleString,
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
        drawer: preopDrawer(context),
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
                  return _addCard1(ctxt, index);
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (titleString == 'List of Upcoming Surgeries') {
              setState(() {
                titleString = 'List of Previous Surgeries';
              });

              setState(() async {
                await getPreviousData();
              });
//            Navigator.push(context,
//                new MaterialPageRoute(builder: (context) => DoctorHome()));
            } else if (titleString == 'List of Previous Surgeries') {
              setState(() {
                titleString = 'List of Upcoming Surgeries';
              });
              setState(() async {
                await getUpcomingData();
              });
//            Navigator.push(context,
//                new MaterialPageRoute(builder: (context) => DoctorHome()));
            }
          },
          child: Icon(Icons.history),
          backgroundColor: Colors.amber,
        ),
      ),
    );
  }

  Future<void> getPreviousData() async {
    var url = hostName + '/surgery/previous';
    Response response = await get(url);
    var data = response.body;
    setState(() {
      surgeryVariable.finalArr = jsonDecode(data)["data"];
    });
  }

  Future<void> getUpcomingData() async {
    var url = hostName + '/surgery/upcoming';
    Response response = await get(url);
    var data = response.body;
    setState(() {
      surgeryVariable.finalArr = jsonDecode(data)["data"];
    });
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

  _addCard(Post ctxt, int index) {
    //this.sn, this.t, this.pid, this.na, this.a, this.d, this.venue,
    //      this.presc, this.instr, this.surgeon

    int timeInMillis = int.parse(ctxt.t);
    var date1 = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    var formattedDate = DateFormat.yMd().add_jm().format(date1); // Apr 8, 2020
    var date = formattedDate.split(" ")[0];
    var time = formattedDate.split(" ")[1];
    var surgeryName = ctxt.sn;
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
      if (element["id"].split(",")[0] == surID) {
        message_count = element["count"];
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
                          surgeryName + "\n" + date + "\n" + time,
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
                          child: Icon(
                            Icons.delete,
                            size: 30.0,
                            color: Colors.red,
                          ),
                          onTap: () {
                            SweetAlert.show(context,
                                subtitle: "Do you want to delete this surgery?",
                                style: SweetAlertStyle.confirm,
                                showCancelButton: true,
                                onPress: (bool isConfirm) {
                              if (isConfirm) {
                                SweetAlert.show(context,
                                    subtitle: "Deleting...",
                                    style: SweetAlertStyle.loading);
                                Future<int> deleteStatus = deleteSurgery(surID);
                                new Future.delayed(new Duration(seconds: 4),
                                    () {
                                  SweetAlert.show(context,
                                      subtitle: "Success!",
                                      style: SweetAlertStyle.success,
                                      onPress: (bool pressed) {
                                    getData();
                                    return true;
                                  });
                                });
                              } else {
                                SweetAlert.show(context,
                                    subtitle: "Canceled!",
                                    style: SweetAlertStyle.error);
                              }
                              // return false to keep dialog
                              return false;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.edit,
                            size: 30.0,
                            color: Colors.blue,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => editSurgery(
                                        surgeryName,
                                        date,
                                        time,
                                        surgeonName,
                                        venue,
                                        pname,
                                        page,
                                        prescription,
                                        instructions,
                                        phone,
                                        surID,
                                        pid)));
                          },
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
    Response response = await get(url);
    var data = response.body;
    setState(() {
      surgeryVariable.finalArr = jsonDecode(data)["data"];
    });
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => DoctorHome()));
  }

  Future<void> getBadgeInfo() async {
    var url = hostName + '/messages/count';
    Response response = await get(url);
    var data = jsonDecode(response.body)["data"];
    setState(() {
      badgeCount = data;
    });
  }

  Future<void> clearMsgs(String surID) async {
    var url = hostName + '/messages/';
    var bodyData = {};
    bodyData["id"] = surID + ",999";
    final Response response = await post(url, body: bodyData);
  }

  Future<void> getData1() async {
    getBadgeInfo();
    if (titleString == "List of Upcoming Surgeries") {
      var url = hostName + '/surgery/upcoming';
      Response response = await get(url);
      var data = response.body;
      if (jsonDecode(data)["data"] != surgeryVariable.finalArr)
        setState(() {
          surgeryVariable.finalArr = jsonDecode(data)["data"];
        });
    } else {
      var url = hostName + '/surgery/previous';
      Response response = await get(url);
      var data = response.body;
      if (jsonDecode(data)["data"] != surgeryVariable.finalArr)
        setState(() {
          surgeryVariable.finalArr = jsonDecode(data)["data"];
        });
    }
  }

  void waitAndExecute() {
//    var future =
//        new Future.delayed(const Duration(milliseconds: 5000), getData1());
//     if(terminate)
//       {
//         t.cancel();
//       }
    const oneSec = const Duration(seconds: 3);
    new Timer.periodic(
        oneSec,
        (Timer t) => {
              if (terminate) {t.cancel()} else {getData1()}
            });
  }

  Future<int> deleteSurgery(id) async {
    var url = hostName + '/surgery/delete/' + id;
    final Response response = await delete(url);
    if (response.statusCode == 200) {
      return 0;
    }
  }

  void onItemTapped(int index) {
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
        GestureDetector(
          child: Container(
            color: Colors.green,
            height: 30.0,
            width: 30.0,
            child: Icon(
              Icons.access_alarm,
            ),
          ),
          onTap: () {
            SweetAlert.show(context,
                subtitle: "Update the status to  Surgery Scheduled ?",
                style: SweetAlertStyle.confirm,
                showCancelButton: true, onPress: (bool isConfirm) {
              if (isConfirm) {
                SweetAlert.show(context,
                    subtitle: "Updating...", style: SweetAlertStyle.loading);
                Future<int> deleteStatus =
                    updateStatus("Surgery Scheduled", id);
              } else {
                SweetAlert.show(context,
                    subtitle: "Canceled!", style: SweetAlertStyle.error);
              }
              // return false to keep dialog
              return false;
            });

//            setState(() {
//              counter = firstSet;
//
//              print("The counter value is ");
//              print(counter);
//            });
          },
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
            SweetAlert.show(context,
                subtitle:
                    "Update the status to " + statusList[firstSet - 1] + " ?",
                style: SweetAlertStyle.confirm,
                showCancelButton: true, onPress: (bool isConfirm) {
              if (isConfirm) {
                SweetAlert.show(context,
                    subtitle: "Updating...", style: SweetAlertStyle.loading);
                Future<int> deleteStatus =
                    updateStatus(statusList[firstSet - 1], id);
              } else {
                SweetAlert.show(context,
                    subtitle: "Canceled!", style: SweetAlertStyle.error);
              }
              // return false to keep dialog
              return false;
            });

//            setState(() {
//              counter = firstSet;
//
//              print("The counter value is ");
//              print(counter);
//            });
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
            SweetAlert.show(context,
                subtitle:
                    "Update the status to " + statusList[secondSet - 1] + " ?",
                style: SweetAlertStyle.confirm,
                showCancelButton: true, onPress: (bool isConfirm) {
              if (isConfirm) {
                SweetAlert.show(context,
                    subtitle: "Updating...", style: SweetAlertStyle.loading);
                Future<int> deleteStatus =
                    updateStatus(statusList[secondSet - 1], id);
              } else {
                SweetAlert.show(context,
                    subtitle: "Canceled!", style: SweetAlertStyle.error);
              }
              // return false to keep dialog
              return false;
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
            SweetAlert.show(context,
                subtitle:
                    "Update the status to " + statusList[thirdSet - 1] + " ?",
                style: SweetAlertStyle.confirm,
                showCancelButton: true, onPress: (bool isConfirm) {
              if (isConfirm) {
                SweetAlert.show(context,
                    subtitle: "Updating...", style: SweetAlertStyle.loading);
                Future<int> deleteStatus =
                    updateStatus(statusList[thirdSet - 1], id);
              } else {
                SweetAlert.show(context,
                    subtitle: "Canceled!", style: SweetAlertStyle.error);
              }
              // return false to keep dialog
              return false;
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
            SweetAlert.show(context,
                subtitle:
                    "Update the status to " + statusList[fourthSet - 1] + " ?",
                style: SweetAlertStyle.confirm,
                showCancelButton: true, onPress: (bool isConfirm) {
              if (isConfirm) {
                SweetAlert.show(context,
                    subtitle: "Updating...", style: SweetAlertStyle.loading);
                Future<int> deleteStatus =
                    updateStatus(statusList[fourthSet - 1], id);
              } else {
                SweetAlert.show(context,
                    subtitle: "Canceled!", style: SweetAlertStyle.error);
              }
              // return false to keep dialog
              return false;
            });
          },
        ),
      ],
    );
  }

  Future<int> updateStatus(String status, String id) async {
    var tempDict = {};
    tempDict["status"] = status;

    var url = hostName + '/surgery/statusUpdate/' + id;
    Response response = await put(url, body: tempDict);
    var data = response.body;
    if (response.statusCode == 200) {
      SweetAlert.show(
        context,
        subtitle: "Updated!",
        style: SweetAlertStyle.success,
        onPress: (bool pressed) {
          getData();
          return true;
        },
      );
    } else {
      SweetAlert.show(
        context,
        subtitle: "Error Updating!",
        style: SweetAlertStyle.error,
        onPress: (bool pressed) {
          getData();
          return true;
        },
      );
    }
  }

  _addCard1(BuildContext ctxt, int index) {
    var surgeryName = surgeryVariable.finalArr[index]["type"];
    int timeInMillis = surgeryVariable.finalArr[index]["dateTime"];
    var date1 = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    var formattedDate = DateFormat.yMd().add_Hm().format(date1); // Apr 8, 2020
    var surgery_date = formattedDate.split(" ")[0];
    var time = formattedDate.split(" ")[1];
    var fname = surgeryVariable.finalArr[index]["patientDetails"][0]["fname"];
    var lname = surgeryVariable.finalArr[index]["patientDetails"][0]["lname"];
    var pname = fname + " " + lname;
    var page = surgeryVariable.finalArr[index]["patientDetails"][0]["dob"];
    var venue = surgeryVariable.finalArr[index]["venue"];
    var prescription = surgeryVariable.finalArr[index]['prescription'];
    var instructions = surgeryVariable.finalArr[index]["instructions"];
    var surgeonName = surgeryVariable.finalArr[index]["surgeon"];
    var st = surgeryVariable.finalArr[index]["status"];
    var phone = surgeryVariable.finalArr[index]["patientDetails"][0]["contact"];
    var patientID = surgeryVariable.finalArr[index]["patientDetails"][0]["id"];
    var surgeryID = surgeryVariable.finalArr[index]["id"];
    var message_count = 0;
    var message_count_status = 0;
    badgeCount.forEach((element) {
      if (element["id"].split(",")[0] == surgeryID) {
        message_count = element["count"];
      }
      if (element["id"].split(",")[1] == surgeryID) {
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
                          surgeryName + "\n" + surgery_date + "\n" + time,
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
                          child: Icon(
                            Icons.delete,
                            size: 30.0,
                            color: Colors.red,
                          ),
                          onTap: () {
                            SweetAlert.show(context,
                                subtitle: "Do you want to delete this surgery?",
                                style: SweetAlertStyle.confirm,
                                showCancelButton: true,
                                onPress: (bool isConfirm) {
                              if (isConfirm) {
                                SweetAlert.show(context,
                                    subtitle: "Deleting...",
                                    style: SweetAlertStyle.loading);
                                Future<int> deleteStatus =
                                    deleteSurgery(surgeryID);
                                new Future.delayed(new Duration(seconds: 4),
                                    () {
                                  SweetAlert.show(context,
                                      subtitle: "Success!",
                                      style: SweetAlertStyle.success,
                                      onPress: (bool pressed) {
                                    getData();
                                    return true;
                                  });
                                });
                              } else {
                                SweetAlert.show(context,
                                    subtitle: "Canceled!",
                                    style: SweetAlertStyle.error);
                              }
                              // return false to keep dialog
                              return false;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.edit,
                            size: 30.0,
                            color: Colors.blue,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => editSurgery(
                                          surgeryName,
                                          surgery_date,
                                          time,
                                          surgeonName,
                                          venue,
                                          pname,
                                          page,
                                          prescription,
                                          instructions,
                                          phone,
                                          surgeryID,
                                          patientID,
                                        )));
                          },
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
//                                              AdminChat(surgeryID: surgeryID)));
//                                },
//                              );
//                            }
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
                    myItems1(
                        surgeryName,
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

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text("Detail"),
          ],
        ),
      ),
    );
  }
}
