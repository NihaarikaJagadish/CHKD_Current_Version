import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:surgerychkd/aboutInfo.dart';
import 'package:surgerychkd/SURGERY.dart';
import 'package:surgerychkd/REPORTS.dart';
import 'package:surgerychkd/patientInfoDash.dart';

import 'Globals.dart';
import 'Login.dart';
import 'home.dart';

// ignore: camel_case_types
class pdfView extends StatefulWidget {
  final String fileName;

  const pdfView({Key key, this.fileName}) : super(key: key);
  @override
  _pdfViewState createState() => _pdfViewState();
}

// ignore: camel_case_types
class _pdfViewState extends State<pdfView> {
  // ignore: missing_return
  Future<int> handleSignOut() async {
    firebaseAuthGlobal.signOut();
  }

  String url =
      "https://firebasestorage.googleapis.com/v0/b/boring-html.appspot.com/o/whatsapp%3A%20919845088994%2FJagadish_Fall2020_Admissions%20(3).pdf?alt=media&token=e2e8d72c-3aee-4436-854f-7614df1c5c65";
  String pdfString;
  PDFDocument _doc;
  bool _loading;

  int selectedIndex = 2;
  final widgetOptions = [
    Text(''),
    Text(''),
    Text(''),
    Text(''),
    Text(''),
  ];

  @override
  void initState() {
    super.initState();
    _initPDF();
  }

  _initPDF() async {
    setState(() {
      _loading = true;
    });
    final doc = await PDFDocument.fromAsset(widget.fileName);
    setState(() {
      _doc = doc;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> fileNameSplit = widget.fileName.split("/");
    final String name = fileNameSplit[fileNameSplit.length - 1];
    print(widget.fileName);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
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
      drawer: Drawer(
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
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
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
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => CHKD()));
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
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => LoginScreen()));
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
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : PDFViewer(
              document: _doc,
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
}
