import 'package:flutter/material.dart';
import 'package:surgerychkd/DoctorHome.dart';
import 'package:surgerychkd/createsurgery.dart';
import 'package:surgerychkd/doctorVideo.dart';
import 'package:surgerychkd/Login.dart';
import 'package:surgerychkd/preopDrawerFile.dart';

import 'Globals.dart';
import 'analytics.dart';
import 'home.dart';

class doctorInfo extends StatefulWidget {
  @override
  _doctorInfoState createState() => _doctorInfoState();
}

class _doctorInfoState extends State<doctorInfo> {
  Future<int> handleSignOut() async {
    firebaseAuthGlobal.signOut();
  }

  int selectedIndex = 3;
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
      drawer: preopDrawer(context),
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
                          new AssetImage('./assets/images/doctoravatar.png'),
                      radius: _height / 8,
                    ),
                    new SizedBox(
                      height: _height / 30,
                    ),
                    new Text(
                      'Pre Op : ' + preOpName,
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
                        infoChild(_width, Icons.email, preOpEmail),
                        infoChild(_width, Icons.call, preOpPhone),
                        infoChild(_width, Icons.person, "Female"),
                        infoChild(_width, Icons.calendar_today, preOpDOB),
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
