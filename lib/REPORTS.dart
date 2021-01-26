import "package:http/http.dart";

import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:surgerychkd/aboutInfo.dart';
import 'package:surgerychkd/SURGERY.dart';
import 'package:surgerychkd/REPORTS.dart';
import 'package:surgerychkd/homeCareTab.dart';
import 'package:surgerychkd/patientInfoDash.dart';
import 'package:surgerychkd/pdfviewer.dart';
import 'package:surgerychkd/prepareTab.dart';
import 'package:surgerychkd/procedureTab.dart';
import 'package:surgerychkd/videoPlayer.dart';
import 'package:surgerychkd/REPORTS.dart';
import 'package:surgerychkd/createsurgery.dart';
import 'package:surgerychkd/visitTab.dart';
import 'Globals.dart';
import 'Login.dart';
import 'doctorInfoPage.dart';
import 'home.dart';
import 'surgeryinfo.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  // ignore: missing_return
  Future<int> handleSignOut() async {
    firebaseAuthGlobal.signOut();
  }

  static var videosLinks = {
    "Orthopedic Surgery": [
      Videos(link: 'https://www.youtube.com/watch?v=_DceiQnQdmU'),
      Videos(
          link: 'https://www.youtube.com/watch?v=Za2-OVjaTPc&feature=emb_logo'),
    ],
    "Inguinal Hernia": [
      Videos(link: 'https://www.youtube.com/watch?v=_DceiQnQdmU'),
    ],
    "Adenotonsillectomy": [
      Videos(link: 'https://www.youtube.com/watch?v=_DceiQnQdmU'),
    ],
  };

  List<FileDetails> files = [
    FileDetails(
        name: 'Orthopedic Surgery',
        dateUploaded: 'September 5th',
        type: "Description",
        path: "./assets/testFiles/testDocument.pdf"),
    FileDetails(
        name: 'Inguinal Hernia Repair',
        dateUploaded: 'September 8th',
        type: "Day Before Surgery",
        path: "./assets/testFiles/testDocument3.pdf"),
    FileDetails(
        name: 'Adenotonsillectomy',
        dateUploaded: 'September 19th',
        type: "Care At Home",
        path: "./assets/testFiles/testDocument4.pdf")
  ];

  List<Videos> videos = videosLinks[surgeryName];

  String url =
      "https://firebasestorage.googleapis.com/v0/b/boring-html.appspot.com/o/whatsapp%3A%20919845088994%2FJagadish_Fall2020_Admissions%20(3).pdf?alt=media&token=e2e8d72c-3aee-4436-854f-7614df1c5c65";
  String pdfString = "./assets/testFiles/testDocument.pdf";
  PDFDocument _doc;
  bool _loading;

  int selectedIndex = 4;

  @override
  void initState() {
    super.initState();
    _initPDF();
  }

  _initPDF() async {
    setState(() {
      _loading = true;
    });
    final doc = await PDFDocument.fromAsset(pdfString);
    setState(() {
      _doc = doc;
      _loading = false;
    });
  }

  Widget fileDetailCard(FileDetails file) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        child: Card(
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("./assets/images/pdf.png")))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      file.name,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Text(
                      "Date Uploaded: " + file.dateUploaded,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontStyle: FontStyle.italic),
                    ),
                    Text(
                      "Type: " + file.type,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => pdfView(
                        fileName: file.path,
                      )));
        },
      ),
    );
  }

  Widget videoDetailCard(Videos video) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        child: Card(
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("./assets/images/play.png")))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      surgeryName + "\nInformational Video",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => YoutubePlayerView(
                        link: video.link,
                      )));
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Surgery Information',
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
//                Navigator.push(context,
//                    new MaterialPageRoute(builder: (context) => Reports()));
//              },
//            ),
              ListTile(
                title: Text('Profile'),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => PatientInfo()));
                },
              ),
              ListTile(
                title: Text('Messaging Portal'),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => HomeScreenChat(
                              currentUserId: firebaseUserID.toString())));
                },
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => LoginScreen()));
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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
            child: Column(
              children: <Widget>[
//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Text(
//                    'Types of Surgeries',
//                    style: TextStyle(color: Colors.black, fontSize: 22),
//                  ),
//                ],
//              ),
//              Column(
//                  children: files.map((p) {
//                return fileDetailCard(p);
//              }).toList()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '\nInformational Videos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                Column(
                    children: videos.map((p) {
                  return videoDetailCard(p);
                }).toList()),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.amberAccent,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,

          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.business,
                ),
                title: Text(
                  "Procedure",
                  style: TextStyle(color: Colors.black),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.assignment,
                ),
                title: Text(
                  "Prepare",
                  style: TextStyle(color: Colors.black),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.archive,
                ),
                title: Text(
                  "Visit",
                  style: TextStyle(color: Colors.black),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.info,
                ),
                title: Text(
                  "Home Care",
                  style: TextStyle(color: Colors.black),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,
                ),
                title: Text(
                  "Videos",
                  style: TextStyle(color: Colors.black),
                )),
          ],
          currentIndex: selectedIndex,
          // fixedColor: Colors.blue,
          onTap: onItemTapped,
        ),
      ),
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
          context, new MaterialPageRoute(builder: (context) => procedure()));
    } else if (index == 1) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => prepareTab()));
    } else if (index == 2) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => visitTab()));
    } else if (index == 3) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => homeCareTab()));
    } else {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => Reports()));
    }
  }
}

class FileDetails {
  String name;
  String dateUploaded;
  String type;
  String path;

  FileDetails({this.name, this.dateUploaded, this.type, this.path});
}

class Videos {
  String link;
  Videos({this.link});
}
