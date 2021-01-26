import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color columnColor1 = Colors.grey;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    columnColor1 = Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            children: [
              Icon(
                Icons.photo_camera,
              ),
              Expanded(
                child: Container(
                  height: 3,
                  color: columnColor1,
                ),
              ),
              GestureDetector(
                child: Icon(
                  Icons.photo_camera,
                  color: columnColor1,
                ),
                onTap: () {
                  setState(() {
                    columnColor1 = Colors.green;
                  });
                },
              ),
              Expanded(
                child: Container(
                  height: 3,
                  color: columnColor1,
                ),
              ),
              GestureDetector(
                child: Icon(
                  Icons.photo_camera,
                  color: columnColor1,
                ),
                onTap: () {
                  setState(() {
                    columnColor1 = Colors.green;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
