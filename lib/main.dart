import 'package:flutter/material.dart';
import 'package:surgerychkd/trial.dart';
import 'Login.dart';
import 'SURGERY.dart';
import 'aboutInfo.dart';
import 'calendarhighlight.dart';
import 'mapDirections.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CHKD Surgery Application',
      theme: ThemeData(
        primaryColor: Colors.amberAccent,
      ),
      home: LoginScreen(),
//      home: Home(),
    );
  }
}
