import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import "package:surgerychkd/aboutInfo.dart";
import 'package:surgerychkd/SURGERY.dart';
import 'package:surgerychkd/REPORTS.dart';
import 'package:surgerychkd/patientInfoDash.dart';

import 'Globals.dart';
import 'Login.dart';

class PatientHome extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<PatientHome> {

  // ignore: missing_return
  Future<int> handleSignOut() async {
    firebaseAuthGlobal.signOut();
  }

  Material myItems(IconData icon, String heading, Color color) {
    return Material(
      color: Colors.white,
      elevation: 4.0,
      borderRadius: BorderRadius.circular(5),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        heading+"\n",
                        style:
                            TextStyle(color: color, fontSize: 16.0),
                      ),
                    ),
                  ),
                  Center(
                    child: Material(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(5.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          onTap: () {
                            print(heading);
                            heading = heading.trim();
                            if (heading == 'About CHKD') {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => CHKD()));
                            } else if (heading == "Scheduled Surgeries") {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => Surgery()));
                            } else if (heading == "Reports and Videos") {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => Reports()));
                            } else if (heading == "Patient Profile") {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => PatientInfo()));
                            } else if(heading == "Medical Information Enquiry"){
                              print("Messaging");
                            }
                          },
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient Dashboard',
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
                            handleSignOut().then((int val){
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()),
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
                  }
              );
            },
          ),
        ],
      ),
      body: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          myItems(Icons.business, "About CHKD", Colors.black),
          myItems(Icons.assignment, "Scheduled Surgeries", Colors.black),
          myItems(Icons.archive, "Reports and Videos", Colors.black),
          myItems(Icons.info, "Patient Profile", Colors.black),
          myItems(Icons.message, "Medical Information Enquiry", Colors.black),
        ],
        staggeredTiles: [
          StaggeredTile.extent(1, 230.0),
          StaggeredTile.extent(1, 230.0),
          StaggeredTile.extent(1, 230.0),
          StaggeredTile.extent(1, 230.0),
          StaggeredTile.extent(2, 230.0),
        ],
      ),
    );
  }
}
