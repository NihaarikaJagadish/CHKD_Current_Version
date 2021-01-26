import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'Patientchat.dart';
import 'const.dart';
import 'settings.dart';
import 'loading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Globals.dart';

class HomeScreenChat extends StatefulWidget {
  final String currentUserId;

  HomeScreenChat({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => HomeScreenState(currentUserId: currentUserId);
}

class HomeScreenState extends State<HomeScreenChat> {
  HomeScreenState({Key key, @required this.currentUserId});

  final String currentUserId;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

//  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isLoading = false;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
//    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
  }

  // ignore: missing_return
  Future<int> handleSignOut() async {
    firebaseAuthGlobal.signOut();
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance
          .collection('users')
          .document(currentUserId)
          .updateData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Settings') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Settings()));
    }
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.example.flutterapp' : 'com.example.flutterapp',
      'Surgery POC Alert',
      'A new message',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message["title"]);

    await flutterLocalNotificationsPlugin.show(0, message["title"],
        message["body"], platformChannelSpecifics,
        payload: message);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: Text(
         'Messaging Portal',
         style: TextStyle(color: Colors.black),
       ),

       centerTitle: true,
       actions: <Widget>[
         PopupMenuButton<Choice>(
           onSelected: onItemMenuPress,
           itemBuilder: (BuildContext context) {
             return choices.map((Choice choice) {
               return PopupMenuItem<Choice>(
                   value: choice,
                   child: Row(
                     children: <Widget>[
                       Icon(
                         choice.icon,
                         color: primaryColor,
                       ),
                       Container(
                         width: 10.0,
                       ),
                       Text(
                         choice.title,
                         style: TextStyle(color: primaryColor),
                       ),
                     ],
                   ));
             }).toList();
           },
         ),
       ],
     ),
      body: Stack(
        children: <Widget>[
          // List
          Container(
            child: getStreamBuilder(),
          ),
          // Loading
          Positioned(
            child: isLoading ? const Loading() : Container(),
          )
        ],
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          Navigator.push(
//              context, MaterialPageRoute(builder: (context) => Settings()));
////          return PopupMenuButton<Choice>(
////            onSelected: onItemMenuPress,
////            itemBuilder: (BuildContext context) {
////              return choices.map((Choice choice) {
////                return PopupMenuItem<Choice>(
////                    value: choice,
////                    child: Row(
////                      children: <Widget>[
////                        Icon(
////                          choice.icon,
////                          color: primaryColor,
////                        ),
////                        Container(
////                          width: 10.0,
////                        ),
////                        Text(
////                          choice.title,
////                          style: TextStyle(color: primaryColor),
////                        ),
////                      ],
////                    ));
////              }).toList();
////            },
////          );
//        },
//        child: Icon(Icons.settings),
//        backgroundColor: Colors.blueGrey,
//      ),
    );
  }

  Widget getStreamBuilder() {
    Widget sb;
    if (UT == "doctor") {
      sb = StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('UT', isEqualTo: "patient")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              ),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(context, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      );
    } else if (UT == "patient") {
      sb = StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('UT', isEqualTo: "doctor")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              ),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(context, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      );
    }
    return sb;
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['id'] == currentUserId) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: document['photoUrl'] != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(themeColor),
                          ),
                          width: 50.0,
                          height: 50.0,
                          padding: EdgeInsets.all(15.0),
                        ),
                        imageUrl: document['photoUrl'],
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 50.0,
                        color: greyColor,
                      ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'RoleID: ${document['nickname']}',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          'Role: ${document['aboutMe'] ?? "Information"}',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                          // peerId: document.documentID,
                          // peerAvatar: document['photoUrl'],
                          // chattingUser : document["nickname"]
                        )));
          },
          color: greyColor2,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }
}

class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}
