import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Globals.dart';
import 'SURGERY.dart';
import 'DoctorHome.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'SurgeonView.dart';
import 'surgeryinfo.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  bool displayPassword = false;
  SharedPreferences prefs;
  String token;
  ProgressDialog pr;
  String userEmail;
  String password;
  String name;
  String info;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String notification;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String title;

  @override
  void initState() {
    super.initState();
    firebaseCloudMessagingListeners();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  displayPasswordFunction(String t) {
    print("***************\n\n***********\n\n");
    print(t);
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(t);
    print(emailValid);
    if (emailValid == true) {
      setState(() {
        displayPassword = true;
      });
    }
    if (emailValid == false) {
      setState(() {
        displayPassword = false;
      });
    }
  }

  firebaseCloudMessagingListeners() {
    _firebaseMessaging.getToken().then((token) {
      pushTokenGlobal = token.toString();
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        notification = message["notification"]["body"];
        title = message["notification"]['title'].toString();
        _showNotificationWithDefaultSound();
//        return showDialog(
//            context: context,
//            builder: (context) {
//              return AlertDialog(
//                title: new Text("Notification"),
//                content: new Text(notification),
//                actions: <Widget>[
//                  // usually buttons at the bottom of the dialog
//                  new FlatButton(
//                    child: new Text("Ok"),
//                    onPressed: () async {
//                      Navigator.pop(context);
//                    },
//                  ),
//                ],
//              );
//            });
      },
      onResume: (Map<String, dynamic> message) async {
        notification = message["notification"]["body"];
        title = message["notification"]['title'].toString();

        _showNotificationWithDefaultSound();
//        return showDialog(
//            context: context,
//            builder: (context) {
//              return AlertDialog(
//                title: new Text("Notification"),
//                content: new Text(notification),
//                actions: <Widget>[
//                  // usually buttons at the bottom of the dialog
//                  new FlatButton(
//                    child: new Text("Ok"),
//                    onPressed: () async {
//                      Navigator.pop(context);
//                    },
//                  ),
//                ],
//              );
//            });
      },
      onLaunch: (Map<String, dynamic> message) async {
        notification = message["notification"]["body"];
        title = message["notification"]['title'].toString();

        _showNotificationWithDefaultSound();
//        return showDialog(
//            context: context,
//            builder: (context) {
//              return AlertDialog(
//                title: new Text("Notification"),
//                content: new Text(notification),
//                actions: <Widget>[
//                  // usually buttons at the bottom of the dialog
//                  new FlatButton(
//                    child: new Text("Ok"),
//                    onPressed: () async {
//                      Navigator.pop(context);
//                    },
//                  ),
//                ],
//              );
//            });
      },
    );
  }

  Future _showNotificationWithDefaultSound() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, notification, platformChannelSpecifics,
        payload: notification);
  }

  void loginAdmin(var credentials) async {
    var url = hostName + '/login/';
    print(url);
    Response response = await post(url, body: credentials);
    var data = jsonDecode(response.body);
    print("000000000000000000000");
    print(data);
    if (response.statusCode == 200) {
      if (data["returnUrl"] == "/admin") {
        print("successful");
        UT = "doctor";
        preOpDOB = data["dob"];
        preOpEmail = userEmail;
        preOpPhone = data["contact"];
        preOpName = data["name"];
        print(preOpDOB);
        print(preOpEmail);
        print(preOpName);
        await getData();
        pr.hide();
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => DoctorHome()));
      } else {
        print("successful");
        UT = "doctor";
        patientDOB = data["dob"];
        patientEmail = userEmail;
        patientContact = data["contact"];
        patientName = data["name"];
        surgeonUUID = data["UUID"];
        print("^^^^^^^");
        pr.hide();
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => Surgeon()));
      }
    } else {
      pr.hide();
      Fluttertoast.showToast(msg: "login unsuccessful");
      print("login unsuccessful");
    }
  }

  Future<void> getPatientSurgeryDetails() async {
    var url = hostName + '/surgery/patientsurgery';
    print(url);
    Response response = await get(
      url,
      headers: <String, String>{
        "Content-Type": "application/json",
        "X-auth-header": patientUUID
      },
    );
    var data = response.body;
    setState(() {
      surgeryVariable.finalArr = jsonDecode(data)["data"];
    });
    print(surgeryVariable.finalArr);
  }

  void loginPatient(var credentials) async {
    var url = hostName + '/patient/login/';
    print(url);
    Response response = await post(url, body: credentials);
    print(response.body);
    var data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      print("successful");
      patientEmail = data["email"];
      patientName = data["name"];
      userEmail = data["email"];
      password = data["email"];
      patientUUID = data["UUID"];
      patientDOB = data["dob"];
      patientContact = data["contact"];
      await getPatientSurgeryDetails();
      UT = "patient";
      pr.hide();
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => Surgery()));
    } else {
      pr.hide();
      Fluttertoast.showToast(msg: "login unsuccessful");
      print("login unsuccessful");
    }
  }

  Future<void> signIn(String email, password) async {
    if (displayPassword == true) {
      email = email.toLowerCase();
      email = email.trim();
      password = password.trim();
      var tempDict = {};
      tempDict["email"] = email;
      tempDict["password"] = password;
      print(tempDict);
      loginAdmin(tempDict);
    } else if (displayPassword == false) {
      email = email.toLowerCase();
      email = email.trim();
      var tempDict = {};
      tempDict["id"] = email;
      loginPatient(tempDict);
    }
  }

  Future<void> getData() async {
    var url = hostName + '/surgery/upcoming';
    print(url);
    Response response = await get(url);
    var data = response.body;
    surgeryVariable.finalArr = jsonDecode(data)["data"];
    // print(surgeryVariable.finalArr);
  }

  void getSurgeryTypeNames() async {
    var url = hostName + '/surgery-type/';
    Response surgeryType = await get(url);
    var surgery_type = surgeryType.body;
    // print(jsonDecode(surgery_type)["data"]);
    // print(surgery_type);
    var s = jsonDecode(surgery_type)["data"];
    surgeryTypeNames = [];
    s.forEach((word) {
      surgeryTypeNames.add(word["type"]);
    });
  }

  void getSurgeonNames() async {
    var url = hostName + '/surgeon/';
    Response surgeon = await get(url);
    var surgeon_name = surgeon.body;
    // print(jsonDecode(surgeon_name)["data"]);
    var names = jsonDecode(surgeon_name)["data"];
    surgeonNames = [];
    names.forEach((entity) {
      surgeonNames.add(entity["fname"] + " " + entity['lname']);
    });
    // print(surgeonNames);
  }

  void venueNames() async {
    var url = hostName + '/keywds/';
    Response venueName = await get(url);
    var venue = venueName.body;
    // print(jsonDecode(venue)["data"]);
    venueList = jsonDecode(venue)["data"][0]['kywds'];
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 30.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            controller: emailController,
            onChanged: (text) {
              print("First text field: $text");
              displayPasswordFunction(text);
            },
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "OpenSans",
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              ),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black,
              ),
              hintText: 'Credentials',
            ),
          ),
        )
      ],
    );
  }

  Future selectNotification(String payload) async {
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: new Text("Notification"),
    //         content: new Text(notification),
    //         actions: <Widget>[
    //           // usually buttons at the bottom of the dialog
    //           new FlatButton(
    //             child: new Text("Ok"),
    //             onPressed: () async {
    //               Navigator.pop(context);
    //             },
    //           ),
    //         ],
    //       );
    //     });
  }

  @override
  Widget build(BuildContext context) {
    getSurgeryTypeNames();
    getSurgeonNames();
    venueNames();
    return new WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.amber,
                  Colors.white,
                  Colors.white,
                  Colors.white,
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              )),
            ),
            Container(
              // height: double.infinity,
              child: SingleChildScrollView(
                // physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 120.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("./assets/images/logo.png"),
                    Text(
                      '\nSurgery Application POC',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "OpenSans",
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text("\n"),
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "OpenSans",
                        fontSize: 20.0,
                      ),
                    ),
                    Text("\n"),
                    Text(
                      '(For patient Login, Please enter 8 digit access code)',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "OpenSans",
                        fontSize: 14.0,
                      ),
                    ),
                    _buildEmailTF(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Visibility(
                          maintainSize: false,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: displayPassword,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 60.0,
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "OpenSans",
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 1.0),
                                ),
                                contentPadding: EdgeInsets.only(top: 14.0),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ),
                                hintText: 'Password',
                              ),
                            ),
                          ),
                        ),
                        Text("\n"),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 25.0),
                          width: double.infinity,
                          child: RaisedButton(
                            elevation: 3.0,
                            onPressed: () async {
                              pr = new ProgressDialog(context);
                              pr.style(
                                  message: 'Logging in...',
                                  borderRadius: 10.0,
                                  backgroundColor: Colors.white,
                                  progressWidget: CircularProgressIndicator(),
                                  elevation: 10.0,
                                  insetAnimCurve: Curves.easeInOut,
                                  progress: 0.0,
                                  maxProgress: 100.0,
                                  progressTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w400),
                                  messageTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.w600));
                              await pr.show();
                              userEmail = emailController.text;
                              password = passwordController.text;
                              signIn(userEmail, password);
                            },
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: Colors.amberAccent,
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 1.0,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
