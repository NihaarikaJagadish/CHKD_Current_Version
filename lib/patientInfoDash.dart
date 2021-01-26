import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:surgerychkd/aboutInfo.dart';
import 'package:surgerychkd/SURGERY.dart';
import 'package:surgerychkd/REPORTS.dart';
import 'package:surgerychkd/patientDrawerFile.dart';
import 'package:surgerychkd/patientInfoDash.dart';

import 'Globals.dart';
import 'Login.dart';
import 'home.dart';

class PatientInfo extends StatefulWidget {
  @override
  _PatientInfoState createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {
  // ignore: missing_return
  Future<int> handleSignOut() async {
    firebaseAuthGlobal.signOut();
  }

  int selectedIndex = 3;
  // Material myItems(String surgery, String date, String time, String venue) {
  //   int color = 0xFF023e8a;
  //   IconData icon = Icons.edit;
  //   return Material(
  //     color: Colors.white,
  //     elevation: 14.0,
  //     shadowColor: Color(0x802196F3),
  //     borderRadius: BorderRadius.circular(30),
  //     child: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Center(
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text(
  //                       "Patient Name: " + surgery,
  //                       style:
  //                           TextStyle(color: new Color(color), fontSize: 20.0),
  //                     ),
  //                   ),
  //                 ),
  //                 Center(
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text(
  //                       "Date of Birth: " + date,
  //                       style:
  //                           TextStyle(color: new Color(color), fontSize: 20.0),
  //                     ),
  //                   ),
  //                 ),
  //                 Center(
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text(
  //                       "Blood Group: " + time,
  //                       style:
  //                           TextStyle(color: new Color(color), fontSize: 20.0),
  //                     ),
  //                   ),
  //                 ),
  //                 Center(
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text(
  //                       "Gender: " + venue,
  //                       style:
  //                           TextStyle(color: new Color(color), fontSize: 20.0),
  //                     ),
  //                   ),
  //                 ),
  //                 Center(
  //                   child: Material(
  //                     color: new Color(color),
  //                     borderRadius: BorderRadius.circular(24.0),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(16.0),
  //                       child: GestureDetector(
  //                         child: Icon(
  //                           icon,
  //                           color: Colors.white,
  //                           size: 30.0,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
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
      drawer: patientDrawer(context),
      body: new Container(
        child: new Stack(
          children: <Widget>[
            new Align(
              alignment: Alignment.center,
              child: new Padding(
                padding: new EdgeInsets.only(top: _height / 15),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new CircleAvatar(
                      backgroundImage:
                          new AssetImage('./assets/images/avatar.jpg'),
                      radius: _height / 10,
                    ),
                    new SizedBox(
                      height: _height / 30,
                    ),
                    new Text(
                      patientName,
                      style: new TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.only(
                  top: _height / 2.6, left: _width / 8, right: _width / 20),
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(top: _height / 300),
                    child: new Column(
                      children: <Widget>[
                        infoChild(_width, Icons.email, patientEmail),
                        infoChild(_width, Icons.call, patientContact),
                        infoChild(_width, Icons.person, 'Male'),
                        infoChild(_width, Icons.calendar_today, patientDOB),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //
      //   backgroundColor: Colors.amberAccent,
      //   selectedItemColor:  Colors.blue,
      //   unselectedItemColor: Colors.black,
      //   type:BottomNavigationBarType.fixed,
      //
      //   items: [
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.business,
      //         ),
      //         title: Text(
      //           "CHKD",
      //           style: TextStyle(color: Colors.black),
      //         )),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.assignment,
      //         ),
      //         title: Text(
      //           "Surgeries",
      //           style: TextStyle(color: Colors.black),
      //         )),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.archive,
      //         ),
      //         title: Text(
      //           "Reports",
      //           style: TextStyle(color: Colors.black),
      //         )),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.info,
      //         ),
      //         title: Text(
      //           "Profile",
      //           style: TextStyle(color: Colors.black),
      //         )),
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
      //   // fixedColor: Colors.blue,
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
          context, new MaterialPageRoute(builder: (context) => CHKD()));
    } else if (index == 1) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => Surgery()));
    } else if (index == 2) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => Reports()));
    } else if (index == 3) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => PatientInfo()));
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
