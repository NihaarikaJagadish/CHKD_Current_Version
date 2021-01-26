import 'package:flutter/material.dart';
import 'package:surgerychkd/Login.dart';
import 'package:surgerychkd/patientInfoDash.dart';

import 'Globals.dart';
import 'SURGERY.dart';
import 'aboutInfo.dart';

Future<int> handleSignOut() async {
  firebaseAuthGlobal.signOut();
}

Drawer patientDrawer(context) {
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
              "P",
              style: TextStyle(fontSize: 40.0),
            ),
          ),
        ),
        ListTile(
          title: Text('About CHKD'),
          onTap: () {
            Navigator.push(
                context, new MaterialPageRoute(builder: (context) => CHKD()));
          },
        ),
        ListTile(
          title: Text('Surgeries'),
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => Surgery()));
          },
        ),
//            ListTile(
//              title: Text('Surgery Information'),
//              onTap: () {
//                Navigator.push(
//                    context, new MaterialPageRoute(builder: (context) => Reports()));
//              },
//            ),
        ListTile(
          title: Text('Profile'),
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => PatientInfo()));
          },
        ),

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
