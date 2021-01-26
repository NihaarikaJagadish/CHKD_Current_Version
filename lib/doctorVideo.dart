import "package:http/http.dart";

import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:surgerychkd/createsurgery.dart';
import 'package:surgerychkd/doctorInfoPage.dart';
import 'package:surgerychkd/pdfviewer.dart';
import 'package:surgerychkd/preopDrawerFile.dart';
import 'package:surgerychkd/videoPlayer.dart';
import 'DoctorHome.dart';
import 'package:surgerychkd/Login.dart';

import 'Globals.dart';
import 'analytics.dart';
import 'home.dart';

class doctorVideo extends StatefulWidget {
  @override
  _doctorVideoState createState() => _doctorVideoState();
}

class _doctorVideoState extends State<doctorVideo> {
  // ignore: missing_return
  Future<int> handleSignOut() async {
    firebaseAuthGlobal.signOut();
  }

  List<FileDetails> files = [
    FileDetails(
        name: 'Orthopedic',
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

  List<Videos> videos = [
    Videos(link: 'https://www.youtube.com/watch?v=rAj38E7vrS8'),
  ];

  String url =
      "https://firebasestorage.googleapis.com/v0/b/boring-html.appspot.com/o/whatsapp%3A%20919845088994%2FJagadish_Fall2020_Admissions%20(3).pdf?alt=media&token=e2e8d72c-3aee-4436-854f-7614df1c5c65";
  String pdfString = "./assets/testFiles/testDocument.pdf";
  PDFDocument _doc;
  bool _loading;

  int selectedIndex = 2;

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
                      "Covid19 Precautions",
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
    return Scaffold(
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ' ',
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  ),
                ],
              ),
              Column(
                  children: files.map((p) {
                return fileDetailCard(p);
              }).toList()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '\nVideos',
                    style: TextStyle(color: Colors.black, fontSize: 22),
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
      drawer: preopDrawer(context),
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

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       'CHKD TestApp',
    //       style: TextStyle(
    //         color: Colors.white,
    //       ),
    //     ),
    //   ),
    //   body: Container(
    //     child: StaggeredGridView.count(
    //       crossAxisCount: 2,
    //       crossAxisSpacing: 12.0,
    //       mainAxisSpacing: 12.0,
    //       padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    //       children: [
    //         myItems("Left Leg X-Ray", "September 5th", "10:12 pm",
    //             "./assets/images/testDocument.pdf"),
    //         myItems("Right Leg X-Ray", "September 8th", "9:45 am",
    //             "images/testDocument3.pdf"),
    //         myItems("Blood Reports", "September 19th", "11:15 am",
    //             "images/testDocument4.pdf"),
    //       ],
    //       staggeredTiles: [
    //         StaggeredTile.extent(2, 250.0),
    //         StaggeredTile.extent(2, 250.0),
    //         StaggeredTile.extent(2, 250.0),
    //       ],
    //     ),
    //   ),
    //   bottomNavigationBar: BottomNavigationBar(
    //     items: [
    //       BottomNavigationBarItem(
    //           icon: Icon(
    //             Icons.business,
    //             color: new Color(0xFF023e8a),
    //           ),
    //           title: Text(
    //             "CHKD",
    //             style: TextStyle(color: new Color(0xFF023e8a)),
    //           )),
    //       BottomNavigationBarItem(
    //           icon: Icon(
    //             Icons.assignment,
    //             color: new Color(0xFF023e8a),
    //           ),
    //           title: Text(
    //             "Surgeries",
    //             style: TextStyle(color: new Color(0xFF023e8a)),
    //           )),
    //       BottomNavigationBarItem(
    //           icon: Icon(
    //             Icons.archive,
    //             color: new Color(0xFF023e8a),
    //           ),
    //           title: Text(
    //             "Reports",
    //             style: TextStyle(color: new Color(0xFF023e8a)),
    //           )),
    //       BottomNavigationBarItem(
    //           icon: Icon(
    //             Icons.info,
    //             color: new Color(0xFF023e8a),
    //           ),
    //           title: Text(
    //             "Profile",
    //             style: TextStyle(color: new Color(0xFF023e8a)),
    //           )),
    //       BottomNavigationBarItem(
    //           icon: Icon(
    //             Icons.message,
    //             color: new Color(0xFF023e8a),
    //           ),
    //           title: Text(
    //             "Message",
    //             style: TextStyle(color: new Color(0xFF023e8a)),
    //           )),
    //     ],
    //     currentIndex: selectedIndex,
    //     fixedColor: Colors.blue,
    //     onTap: onItemTapped,
    //   ),
    // );
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
