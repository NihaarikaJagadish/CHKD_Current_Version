import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:surgerychkd/doctorInfoPage.dart';
import 'package:surgerychkd/doctorVideo.dart';
import 'package:surgerychkd/preopDrawerFile.dart';
import 'Globals.dart';
import 'Login.dart';
import 'analytics.dart';
import 'home.dart';
import 'surgeryinfo.dart';
import 'package:surgerychkd/DoctorHome.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';

class ExampleNumber {
  int number;

  static final Map<int, String> map = {
    0: "zero",
    1: "one",
    2: "two",
    3: "three",
    4: "four",
    5: "five",
    6: "six",
    7: "seven",
    8: "eight",
    9: "nine",
    10: "ten",
    11: "eleven",
    12: "twelve",
    13: "thirteen",
    14: "fourteen",
    15: "fifteen",
  };

  String get numberString {
    return (map.containsKey(number) ? map[number] : "unknown");
  }

  ExampleNumber(this.number);

  String toString() {
    return ("$number $numberString");
  }

  static List<ExampleNumber> get list {
    return (map.keys.map((num) {
      return (ExampleNumber(num));
    })).toList();
  }
}

class createSurgery extends StatefulWidget {
  @override
  _createSurgeryState createState() => _createSurgeryState();
}

class _createSurgeryState extends State<createSurgery> {
//  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final emailController = new TextEditingController();
  final fname = new TextEditingController();
  final lname = new TextEditingController();
  String dateOfBirth = 'Date Of Birth';
  bool viewVisible = false;
  bool showDetails = false;
  bool newUser = false;
  String patientDob = '';
  String _myActivity;
  final _bodyControllerPre = TextEditingController();
  final _bodyControllerIns = TextEditingController();
  String _myActivityResult;
  String patientName;
  String patientAge;
  String medicalConditions;
  String knownAllergies;
  String surgeryType;
  String venue;
  String prescription;
  String instruction;
  String surgeon_name;
  String _date;
  String _time;
  String _dateTime;
  int selectedIndex = 1;
  DateTime selectedDate = DateTime.now();
  DateTime selectedDOB = DateTime.now();
  TimeOfDay _currentTime = new TimeOfDay.now();
  String timeText = 'Set A Time';
  String bloodGroup = '';
  String SortDate = '';
  String SortTime = '';
  String patientId = '';
  String dropDown = '';
  final formKey = new GlobalKey<FormState>();

  bool asTabs = false;
  String selectedValue;
  String preselectedValue = "dolor sit";
  ExampleNumber selectedNumber;
  List<int> selectedItems = [];
  List<DropdownMenuItem> items = [];
  final List<DropdownMenuItem> items1 = [];
  final List<DropdownMenuItem> surgeons = [];
  final List<DropdownMenuItem> venues = [];
  final List<DropdownMenuItem> instructionItems = [];
  List<String> _values = new List();
  List<bool> _selected = new List();

  static const String appTitle = "Schedule Surgery";
  var surgery;
  var loremIpsum = [];
  var instructionList = ["Instruction 1", "Instruction 2", "Instruction 3"];
  var dob = [];
  var patientIDList = [];
  var loremIpsum1 = surgeryTypeNames;
  final doctorNames = surgeonNames;
  final venueDetails = venueList;
  void showWidget() {
    setState(() {
      viewVisible = true;
    });
  }

  // ignore: missing_return
  Future<int> handleSignOut() async {
    firebaseAuthGlobal.signOut();
  }

  void hideWidget() {
    setState(() {
      viewVisible = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _myActivity = '';
    dateOfBirth = "Date of Birth";
    _myActivityResult = '';
    patientId = '';
    patientName = '';
    patientAge = '';
    medicalConditions = '';
    knownAllergies = '';
    surgeryType = '';
    prescription = '';
    venue = '';
    instruction = '';
    surgeon_name = '';
    _date = '';
    _time = "";
    _dateTime = "Select Date and Time";
    bloodGroup = '';
    String wordPair = "";
    emailController.addListener(_printLatestValue);

    wordPair = "";
    loremIpsum1.forEach((word) {
      wordPair = word;
      if (items1.indexWhere((item) {
            return (item.value == wordPair);
          }) ==
          -1) {
        items1.add(DropdownMenuItem(
          child: Text(wordPair),
          value: wordPair,
        ));
      }
      wordPair = "";
    });
    wordPair = "";
    doctorNames.forEach((word) {
      wordPair = word;
      if (surgeons.indexWhere((item) {
            return (item.value == wordPair);
          }) ==
          -1) {
        surgeons.add(DropdownMenuItem(
          child: Text(wordPair),
          value: wordPair,
        ));
      }
      wordPair = "";
    });

    wordPair = "";
    venueDetails.forEach((word) {
      wordPair += word;
      if (venues.indexWhere((item) {
            return (item.value == wordPair);
          }) ==
          -1) {
        venues.add(DropdownMenuItem(
          child: Text(wordPair),
          value: wordPair,
        ));
      }
      wordPair = "";
    });
    wordPair = "";
    instructionList.forEach((word) {
      wordPair = word;
      if (instructionItems.indexWhere((item) {
            return (item.value == wordPair);
          }) ==
          -1) {
        instructionItems.add(DropdownMenuItem(
          child: Text(wordPair),
          value: wordPair,
        ));
      }
      wordPair = "";
    });
    super.initState();
  }

  void addNewPatient() {
    setState(() {
      newUser = true;
      showDetails = false;
      viewVisible = false;
    });
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("No Patient Found"),
          content: new Text(
              "The phone number is not present. Please create a new Patient"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
                onPressed: () {
                  addNewPatient();
                  Navigator.of(context).pop();
                },
                child: new Text("Create Patient")),
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _printLatestValue() async {
    var phoneNumber = emailController.text;
    if (phoneNumber.length < 10) {
      setState(() {
        showDetails = false;
        viewVisible = false;
        newUser = false;
      });
    }
    if (phoneNumber.length == 10) {
      var url = hostName + '/patient/contact';
      Response response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json",
          "X-auth-header": phoneNumber
        },
      );
      if (response.statusCode == 200) {
        if (newUser == true) {
          setState(() {
            showDetails = false;
          });
        }
        if (newUser == false) {
          setState(() {
            showDetails = true;
          });
        }

        loremIpsum = [];
        dob = [];
        patientIDList = [];
        items = [];
        var data = jsonDecode(response.body)["data"];
        data.forEach((patient) {
          loremIpsum.add(patient["fname"] + " " + patient["lname"]);
          dob.add(patient["dob"]);
          patientIDList.add(patient["id"]);
        });

        String wordPair = '';
        loremIpsum.forEach((word) {
          wordPair = word;
          if (items.indexWhere((item) {
                return (item.value == wordPair);
              }) ==
              -1) {
            items.add(DropdownMenuItem(
              child: Text(wordPair),
              value: wordPair,
            ));
          }
          wordPair = "";
        });
      } else if (response.statusCode == 404 &&
          showDetails == false &&
          newUser == false) {
        _showDialog();
      }
    }
  }

  List<Widget> get appBarActions {
    return ([
      Center(child: Text("Tabs:")),
      Switch(
        activeColor: Colors.white,
        value: asTabs,
        onChanged: (value) {
          setState(() {
            asTabs = value;
          });
        },
      )
    ]);
  }

  void createPatient(patientDetails) async {
    var url = hostName + '/patient/';
    final http.Response response = await http.post(url, body: patientDetails);
    if (response.statusCode == 200) {
      var formDetails = {};
      formDetails["pt_id"] = jsonDecode(response.body)["id"];
      formDetails["type"] = surgeryType;
      formDetails["date"] = _date;
      formDetails["time"] = _time;
      formDetails["surgeon"] = surgeon_name;
      formDetails["venue"] = venue;
      formDetails["prescription"] = _bodyControllerPre.text;
      formDetails["instructions"] = _bodyControllerIns.text;
      formDetails["status"] = "Surgery Scheduled";
      createSurgeryFunction(formDetails);
    }
  }

  void afterWarningCreateSurgery(formDetails) async {
    var url = hostName + '/surgery/afterWarning';
    final http.Response response = await http.post(url, body: formDetails);
    print("Okay");
    print(response.statusCode);
    if (response.statusCode == 200) {
      SweetAlert.show(context,
          subtitle: "Success!",
          style: SweetAlertStyle.success, onPress: (bool pressed) {
        getData();
        return true;
      });
    } else {
      SweetAlert.show(
        context,
        subtitle: "Surgery Creation Failed!",
        style: SweetAlertStyle.error,
        onPress: (bool pressed) {
          getData();
          return true;
        },
      );
    }
  }

  void createSurgeryFunction(formDetails) async {
    var url = hostName + '/surgery/beforeWarning';
    final http.Response response = await http.post(url, body: formDetails);
    if (response.statusCode == 200) {
      SweetAlert.show(
        context,
        subtitle: "Success!",
        style: SweetAlertStyle.success,
        onPress: (bool pressed) {
          getData();
          return true;
        },
      );
    } else {
      var d = jsonDecode(response.body);

      var text = '';
      if (d["patprev"] != null && d["patnext"] != null) {
        int timeInMillis = int.parse(d["patprev"]);
        var date1 = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
        var formattedDate = DateFormat.yMd().add_jm().format(date1);
        text = "The patient already has a pre existing surgery at " +
            formattedDate +
            " ";

        timeInMillis = int.parse(d["patnext"]);
        date1 = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
        formattedDate = DateFormat.yMd().add_jm().format(date1);
        text = text + "and " + formattedDate + ".";
      } else if (d["patprev"] != null && d["patnext"] == null) {
        int timeInMillis = int.parse(d["patprev"]);
        var date1 = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
        var formattedDate = DateFormat.yMd().add_jm().format(date1);
        text = "The patient already has a pre existing surgery at " +
            formattedDate +
            ".";
      } else if (d["patprev"] == null && d["patnext"] != null) {
        int timeInMillis = int.parse(d["patnext"]);
        var date1 = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
        var formattedDate = DateFormat.yMd().add_jm().format(date1);
        text = "The patient already has a pre existing surgery at " +
            formattedDate +
            ".";
      } else {
        text = '';
      }
      if (d["docprev"] != null && d["docnext"] != null) {
        int timeInMillis = int.parse(d["docprev"]);
        var date1 = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
        var formattedDate = DateFormat.yMd().add_jm().format(date1);
        text = text +
            " The Surgeon already has a pre existing surgery at " +
            formattedDate +
            ".";

        timeInMillis = int.parse(d["docnext"]);
        date1 = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
        formattedDate = DateFormat.yMd().add_jm().format(date1);
        text = text + "and " + formattedDate + ".";
      } else if (d["docprev"] != null && d["docnext"] == null) {
        int timeInMillis = int.parse(d["docprev"]);
        var date1 = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
        var formattedDate = DateFormat.yMd().add_jm().format(date1);
        text = text +
            " The Surgeon already has a pre existing surgery at " +
            formattedDate +
            ".";
      } else if (d["docprev"] == null && d["docnext"] != null) {
        int timeInMillis = int.parse(d["docnext"]);
        var date1 = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
        var formattedDate = DateFormat.yMd().add_jm().format(date1);
        text = text +
            " The Surgeon already has a pre existing surgery at " +
            formattedDate +
            ".";
      }
      text = text + "Do you still want to continue?";
      SweetAlert.show(context,
          subtitle: text,
          style: SweetAlertStyle.confirm,
          showCancelButton: true, onPress: (bool isConfirm) {
        if (isConfirm) {
          SweetAlert.show(context,
              subtitle: "Creating Surgery...", style: SweetAlertStyle.loading);
          afterWarningCreateSurgery(formDetails);
          String url = "http://qav2.cs.odu.edu/CHKD/notify.php?token=" +
              pushTokenGlobal.toString();
          http.get(url);
          new Future.delayed(new Duration(seconds: 4), () {
            print("deleted");
          });
        } else {
          SweetAlert.show(context,
              subtitle: "Canceled!", style: SweetAlertStyle.error);
        }
        // return false to keep dialog
        return false;
      });
    }
  }

  void getData() async {
    var url = hostName + '/surgery/upcoming';
    Response response = await get(url);
    var data = response.body;
    surgeryVariable.finalArr = jsonDecode(data)["data"];
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => DoctorHome()));
  }

  validationFunction() {
    if (!(newUser)) {
      if ((patientId.length != 0) &&
          (surgeryType.length != 0) &&
          (_date.length != 0) &&
          (_time.length != 0) &&
          (surgeon_name.length != 0) &&
          (venue.length != 0) &&
          (emailController.text.length != 0)) {
        return 1;
      } else {
        return 0;
      }
    } else {
      if ((surgeryType.length != 0) &&
          (_date.length != 0) &&
          (_time.length != 0) &&
          (surgeon_name.length != 0) &&
          (venue.length != 0) &&
          (fname.text.length != 0) &&
          (lname.text.length != 0) &&
          (dateOfBirth.length != 0 && dateOfBirth != "Date of Birth") &&
          (emailController.text.length != 0)) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  _saveForm() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivityResult = _myActivity;
      });
    }

    if (!(newUser)) {
      var formDetails = {};
      formDetails["pt_id"] = patientId;
      formDetails["type"] = surgeryType;
      formDetails["date"] = _date;
      formDetails["time"] = _time;
      formDetails["surgeon"] = surgeon_name;
      formDetails["venue"] = venue;
      formDetails["prescription"] = _bodyControllerPre.text;
      formDetails["instructions"] = _bodyControllerIns.text;
      formDetails["status"] = "Surgery Scheduled";
      createSurgeryFunction(formDetails);
    } else {
      var patientDetails = {};
      patientDetails["fname"] = fname.text;
      patientDetails['lname'] = lname.text;
      patientDetails["dob"] = dateOfBirth;
      patientDetails["contact"] = emailController.text;
      createPatient(patientDetails);
    }
  }

  Widget buildChips() {
    List<Widget> chips = new List();

    for (int i = 0; i < _values.length; i++) {
      InputChip actionChip = InputChip(
        label: Text(_values[i]),
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.teal,
        onDeleted: () {
          _values.removeAt(i);
          _selected.removeAt(i);

          setState(() {
            _values = _values;
            _selected = _selected;
            print(_values);
            print(_selected);
          });
        },
      );

      chips.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: actionChip,
      ));
    }

    return Wrap(
      // This next line does the trick.
      children: chips,
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> widgets;
    Map<String, Widget> widgets1;
    Map<String, Widget> widgets2;
    widgets2 = {
      "Select The Instructions": SearchableDropdown.single(
        items: instructionItems,
        value: dropDown,
        hint: "Select one",
        searchHint: null,
        onChanged: (value) {
          _values.add(value);
          _selected.add(true);

          setState(() {
            _values = _values;
            _selected = _selected;
            print(_values);
            print(_selected);
            dropDown = '';
          });
        },
        dialogBox: false,
        isExpanded: true,
        menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
      ),
    };

    widgets1 = {
      "Select Patient Name ": SearchableDropdown.single(
        items: items,
        value: selectedValue,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValue = value;
            _myActivity = value;
            viewVisible = true;
            var i = loremIpsum.indexOf(value);
            patientDob = dob[i];
            patientId = patientIDList[i];
          });
        },
        isExpanded: true,
      ),
    };

    widgets = {
      "Select Surgery Type": SearchableDropdown.single(
        items: items1,
        value: surgeryType,
        hint: "Select one",
        searchHint: null,
        onChanged: (value) {
          setState(() {
            surgeryType = value;
          });
        },
        dialogBox: false,
        isExpanded: true,
        menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
      ),
      "Select Primary Surgeon": SearchableDropdown.single(
        items: surgeons,
        value: surgeon_name,
        hint: "Select one",
        searchHint: null,
        onChanged: (value) {
          setState(() {
            surgeon_name = value;
          });
        },
        dialogBox: false,
        isExpanded: true,
        menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
      ),
//      "Enter Patient Phone Number ": SearchableDropdown.single(
//        items: items,
//        value: selectedValue,
//        hint: "Select one",
//        searchHint: "Select one",
//        onChanged: (value) {
//          setState(() {
//            selectedValue = value;
//            _myActivity = value;
//            viewVisible = true;
//            var i = loremIpsum.indexOf(value);
//            patientDob = dob[i];
//            if (value == 'patient one') {
//              patientName = 'Patient One';
//              patientAge = "22";
//              medicalConditions = "No Medical Conditions";
//              knownAllergies = "Groundnut Allergy";
//              bloodGroup = 'O+ve';
//            } else if (value == 'patient two') {
//              patientName = 'Patient Two';
//              patientAge = "42";
//              medicalConditions = "Diabetic and Heart Conditions";
//              knownAllergies = "No Known Allergies";
//              bloodGroup = 'A+ve';
//            } else if (value == 'patient three') {
//              patientName = 'Patient Three';
//              patientAge = "32";
//              medicalConditions = "Diabetic";
//              knownAllergies = "No Known Allergies";
//              bloodGroup = 'B+ve';
//            }
//          });
//        },
//        isExpanded: true,
//      ),
      "Select Venue": SearchableDropdown.single(
        items: venues,
        value: venue,
        hint: "Select one",
        searchHint: null,
        onChanged: (value) {
          setState(() {
            venue = value;
          });
        },
        dialogBox: false,
        isExpanded: true,
        menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
      ),
    };
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Surgery'),
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
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: widgets
                        .map((k, v) {
                          return (MapEntry(
                              k,
                              Center(
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      margin: EdgeInsets.all(20),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          children: <Widget>[
                                            Text("$k:"),
                                            v,
                                          ],
                                        ),
                                      )))));
                        })
                        .values
                        .toList(),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 350.0,
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "OpenSans",
                      ),
//                      decoration: InputDecoration(
//                          labelText: 'Prescription Details',
//                          border: OutlineInputBorder()),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.black,
                        ),
                        hintText: 'Phone Number',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        addNewPatient();
                      },
                      child: Text(
                        "Add New Patient       ",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Visibility(
                    maintainSize: false,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: newUser,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: 350.0,
                      child: TextField(
                        controller: fname,
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "OpenSans",
                        ),
//                      decoration: InputDecoration(
//                          labelText: 'Prescription Details',
//                          border: OutlineInputBorder()),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'First Name ',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Visibility(
                    maintainSize: false,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: newUser,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: 350.0,
                      child: TextField(
                        controller: lname,
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "OpenSans",
                        ),
//                      decoration: InputDecoration(
//                          labelText: 'Prescription Details',
//                          border: OutlineInputBorder()),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Last Name ',
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    maintainSize: false,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: newUser,
                    child: RaisedButton(
                      elevation: 3.0,
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.transparent,
                      splashColor: Colors.black26,
                      onPressed: () => _selectDate(context),
                      child: Text(
                        dateOfBirth,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Visibility(
                    maintainSize: false,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: showDetails,
                    child: Column(
                      children: widgets1
                          .map((k, v) {
                            return (MapEntry(
                                k,
                                Center(
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: Colors.grey,
                                            width: 1.0,
                                          ),
                                        ),
                                        margin: EdgeInsets.all(20),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            children: <Widget>[
                                              Text("$k:"),
                                              v,
                                            ],
                                          ),
                                        )))));
                          })
                          .values
                          .toList(),
                    ),
                  ),
                  Visibility(
                    maintainSize: false,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: viewVisible,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Patient Details",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    maintainSize: false,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: viewVisible,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Patient DOB : " + patientDob,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 1, 0, 8),
                      child: Text("Enter Prescription Details",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 18),
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 8),
                    child: TextField(
                      controller: _bodyControllerPre,
                      maxLines: 5,
                      decoration: InputDecoration(
                          labelText: 'Prescription Details',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 1, 0, 8),
                      child: Text("Enter Surgery Instructions",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 18),
                          )),
                    ),
                  ),
                  Column(
                    children: widgets2
                        .map((k, v) {
                          return (MapEntry(
                              k,
                              Center(
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      margin: EdgeInsets.all(20),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          children: <Widget>[
                                            Text("$k:"),
                                            v,
                                          ],
                                        ),
                                      )))));
                        })
                        .values
                        .toList(),
                  ),
                  Container(
                    child: buildChips(),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
//                  Padding(
//                    padding: EdgeInsets.fromLTRB(20, 10, 20, 8),
//                    child: TextField(
//                      controller: _bodyControllerIns,
//                      maxLines: 5,
//                      decoration: InputDecoration(
//                          labelText: 'Instructions',
//                          border: OutlineInputBorder()),
//                    ),
//                  ),
                  Container(
                      padding: EdgeInsets.all(8),
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                              elevation: 3.0,
                              padding: EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              color: Colors.amberAccent,
                              onPressed: () => _selectTime(context),
                              child: Text(
                                _dateTime,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ])),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 25.0),
                    width: 200.0,
                    child: RaisedButton(
                      elevation: 3.0,
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.amberAccent,
                      child: Text('Create Surgery'),
                      onPressed: () {
                        var validateVariable = validationFunction();
                        if (validateVariable == 1) {
                          SweetAlert.show(context,
                              subtitle: "Do you want to create this surgery?",
                              style: SweetAlertStyle.confirm,
                              showCancelButton: true,
                              onPress: (bool isConfirm) {
                            if (isConfirm) {
                              SweetAlert.show(context,
                                  subtitle: "Creating Surgery...",
                                  style: SweetAlertStyle.loading);
                              _saveForm();
                              String url =
                                  "http://qav2.cs.odu.edu/CHKD/notify.php?token=" +
                                      pushTokenGlobal.toString();
                              http.get(url);
//                              new Future.delayed(new Duration(seconds: 4), () {
//                              SweetAlert.show(context,
//                                  subtitle: "Success!",
//                                  style: SweetAlertStyle.success,
//                                  onPress: (bool pressed) {
//                                getData();
//                                return true;
//                              });
//                              });
                            } else {
                              SweetAlert.show(context,
                                  subtitle: "Canceled!",
                                  style: SweetAlertStyle.error);
                            }
                            // return false to keep dialog
                            return false;
                          });
                        } else {
                          SweetAlert.show(context,
                              subtitle: "Please enter all the fields!",
                              style: SweetAlertStyle.error);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  _selectTime(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      helpText: 'Select Surgery Date',
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.amber,
          ), // This will change to light theme.
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        var pick = "${picked.toLocal()}".split(' ')[0];
        selectedDate = picked;
        _date = pick;
      });
      final TimeOfDay selectedTime = await showTimePicker(
        initialTime: TimeOfDay.now(),
        context: context,
        // helpText: 'Select Surgery Time',
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              primarySwatch: Colors.amber,
            ), // This will change to light theme.
            child: child,
          );
        },
      );
      if (selectedTime != null)
        setState(() {
          _time = selectedTime.toString();
          _time = _time.substring(10, 15);
          if (int.parse(_time.substring(0, 2)) > 12) {
            var x = int.parse(_time.substring(0, 2)) - 12;
            _time = x.toString() + _time.substring(2) + " pm";
          } else {
            _time = _time + " am";
          }
        });
      setState(() {
        _dateTime = _date.toString() + " , " + _time.toString();
      });
    }
//      setState(() {
//        var pick = "${picked.toLocal()}".split(' ')[0];
//        print(pick);
//        selectedDate = picked;
//        _date = pick;
//      });
//
//    final TimeOfDay selectedTime = await showTimePicker(
//      initialTime: TimeOfDay.now(),
//      context: context,
//      // helpText: 'Select Surgery Time',
//      builder: (context, child) {
//        return Theme(
//          data: ThemeData(
//            primarySwatch: Colors.amber,
//          ), // This will change to light theme.
//          child: child,
//        );
//      },
//    );
//    if (selectedTime != null)
//      setState(() {
//        _time = selectedTime.toString();
//        _time = _time.substring(10, 15);
//        print(_time);
//        if (int.parse(_time.substring(0, 2)) > 12) {
//          var x = int.parse(_time.substring(0, 2)) - 12;
//          _time = x.toString() + _time.substring(2) + " pm";
//          print(_time);
//        } else {
//          _time = _time + " am";
//          print(_time);
//        }
//      });
//    setState(() {
//      _dateTime = _date.toString() + " , " + _time.toString();
//    });
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDOB, // Refer step 1
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Birth',
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.amber,
          ), // This will change to light theme.
          child: child,
        );
      },
    );
    if (picked != null)
      setState(() {
        var pick = "${picked.toLocal()}".split(' ')[0];
        selectedDOB = picked;
        dateOfBirth = pick;
      });
  }

  void onItemTapped(int index) {
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
