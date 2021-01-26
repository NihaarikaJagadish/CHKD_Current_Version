import 'package:flutter/material.dart';
import 'package:surgerychkd/Login.dart';
import 'package:surgerychkd/analytics.dart';

import 'DoctorHome.dart';
import 'Globals.dart';
import 'createsurgery.dart';
import 'doctorInfoPage.dart';
import 'doctorVideo.dart';

Future<int> handleSignOut() async {
  firebaseAuthGlobal.signOut();
}

Drawer preopDrawer(context) {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("CHKD Surgery POC"),
          accountEmail: Text("Menu"),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                ? Colors.blue
                : Colors.white,
            child: Text(
              "D",
              style: TextStyle(fontSize: 40.0),
            ),
          ),
        ),
        ListTile(
          title: Text('Surgeries'),
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => DoctorHome()));
          },
        ),
        ListTile(
          title: Text('Create Surgery'),
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => createSurgery()));
          },
        ),
        ListTile(
          title: Text('Surgery Information'),
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => doctorVideo()));
          },
        ),
        ListTile(
          title: Text('Profile'),
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => doctorInfo()));
          },
        ),
//        ListTile(
//          title: Text('Analytics'),
//          onTap: () {
//            Navigator.push(context,
//                new MaterialPageRoute(builder: (context) => analytics()));
//          },
//        ),
        ListTile(
          title: Text('Logout'),
          onTap: () {
            Navigator.pop(context);
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
//            Navigator.push(context,
//                new MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),
        ListTile(
          title: Text('Exit Menu'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
