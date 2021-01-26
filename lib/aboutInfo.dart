import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:surgerychkd/Login.dart';
import 'package:surgerychkd/patientDrawerFile.dart';
import 'Globals.dart';
import "SURGERY.dart";
import 'REPORTS.dart';
import 'analytics.dart';
import 'home.dart';
import 'patientInfoDash.dart';
import 'package:maps_launcher/maps_launcher.dart';

class CHKD extends StatefulWidget {
  @override
  _CHKDState createState() => _CHKDState();
}

class _CHKDState extends State<CHKD> {
  int selectedIndex = 0;

  Future<int> handleSignOut() async {
    firebaseAuthGlobal.signOut();
  }

  @override
  Widget build(BuildContext context) {
    print("Entering the class");
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(
          'About CHKD',
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

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/chkd.jpg"),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 13, 15, 10),
                child: Container(
                  color: Color(0xfff5f5f5),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Vision\n",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        "Children's Hospital of The King's Daughters Health System will lead the region as the preferred provider of quality children's health services",
                        style: TextStyle(fontSize: 17.0),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "\nMission\n",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        "In leading the region in the provision of children's healthcare services, \n\nCHKD will:\n"
                        "1) Deliver excellence in quality and service as we continually measure and improve our outcomes\n"
                        "2) Evolve and enhance services in response to the needs of children and the advancement of science\n"
                        "3) Educate the next generation of leaders in children's health\n"
                        "4) Be the healthcare employer of choice; and\n"
                        "5) Collaborate with others to attain our vision.\n",
                        style: TextStyle(fontSize: 17.0),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "Contact us\n",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic),
                      ),
                      GestureDetector(
                        child: Image.asset(
                          "assets/images/mapImage.jpg",
                          height: 250,
                          width: 250,
                          fit: BoxFit.cover,
                        ),
                        onTap: () => MapsLauncher.launchQuery(
                            "601 Children's Lane, Norfolk, VA 23507, USA"),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "For emergency call 911, For all other queries - 8888888888\n",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      //     bottomNavigationBar:BottomNavigationBar(
      //   // backgroundColor: Colors.amberAccent,
      //   // unselectedItemColor: Colors.black,
      //   // selectedItemColor: Colors.amber,
      //
      //       backgroundColor: Colors.amberAccent,
      //       selectedItemColor:  Colors.blue,
      //       unselectedItemColor: Colors.black,
      //       type:BottomNavigationBarType.fixed,
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
}
