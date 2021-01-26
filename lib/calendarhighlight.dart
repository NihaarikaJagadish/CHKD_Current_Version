import 'package:calendar_widget/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class calendarH extends StatefulWidget {
  @override
  _calendarHState createState() => _calendarHState();
}

class _calendarHState extends State<calendarH> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    CalendarHighlighter highlighter = (DateTime dt) {
      // randomly generate a boolean list of length monthLength + 1 (because months start at 1)
      return List.generate(Calendar.monthLength(dt) + 1, (index) {
        return (Random().nextDouble() < 0.3);
      });
    };
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          right: -40.0,
                          top: -40.0,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: CircleAvatar(
                              child: Icon(Icons.close),
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                        Container(
                          height: 300.0,
                          margin: EdgeInsets.only(top: 16),
                          alignment: Alignment.topCenter,
                          child: Calendar(
                            width: 300.0,
                            height: 300.0,
                            onTapListener: (DateTime dt) {
                              final snackbar = SnackBar(
                                content: Text(
                                    'Clicked ${dt.month}/${dt.day}/${dt.year}!'),
                              );
                              Scaffold.of(context).showSnackBar(snackbar);
                            },
                            highlighter: highlighter,
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Text("Open Popup"),
        ),
      ),
    );
  }
}

class CalnedarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CalendarHighlighter highlighter = (DateTime dt) {
      // randomly generate a boolean list of length monthLength + 1 (because months start at 1)
      return List.generate(Calendar.monthLength(dt) + 1, (index) {
        return (Random().nextDouble() < 0.3);
      });
    };

    return Container(
      margin: EdgeInsets.only(top: 16),
      alignment: Alignment.topCenter,
      child: Calendar(
        width: 300.0,
        onTapListener: (DateTime dt) {
          final snackbar = SnackBar(
            content: Text('Clicked ${dt.month}/${dt.day}/${dt.year}!'),
          );
          Scaffold.of(context).showSnackBar(snackbar);
        },
        highlighter: highlighter,
      ),
    );
  }
}
