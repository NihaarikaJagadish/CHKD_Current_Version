import 'dart:math';
import 'package:expandable/expandable.dart';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flutter/material.dart';
import 'package:surgerychkd/surgeryinfo.dart';

class Post {
  final String sn;
  final String t;
  final String pid;
  final String na;
  final String a;
  final String d;
  final String venue;
  final String presc;
  final String instr;
  final String surgeon;

  Post(this.sn, this.t, this.pid, this.na, this.a, this.d, this.venue,
      this.presc, this.instr, this.surgeon) {
    var arr = List();
    arr.add(sn);
    arr.add(t);
    arr.add(pid);
    arr.add(na);
    arr.add(a);
    arr.add(d);
    arr.add(venue);
    arr.add(presc);
    arr.add(instr);
    arr.add(surgeon);
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SearchBarController<Post> _searchBarController = SearchBarController();
  bool isReplay = false;

  Future<List<Post>> _getALlPosts(String text) async {
    await Future.delayed(Duration(seconds: text.length == 4 ? 10 : 1));
//    if (isReplay) return [Post("Replaying !", "Replaying body")];
    if (text.length == 5) throw Error();
    if (text.length == 6) return [];
    List<Post> posts = [];

    var random = new Random();
    for (int i = 0; i < 10; i++) {
//      posts
//          .add(Post("$text $i", "body random number : ${random.nextInt(100)}"));
      print(posts);
    }
    surgeryVariable.finalArr = [];
    var arr1 = surgeryVariable.surgery;
    var keys = arr1.values.toList();
    for (var i = 0; i < keys.length; i++) {
      var eachList = arr1[i];
      for (var j = 0; j < eachList.length; j++) {
        if (eachList[j].contains(text)) {
          surgeryVariable.finalArr.add(eachList[j]);
        }
      }
    }
    print(surgeryVariable.finalArr);
    print(posts);
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SearchBar<Post>(
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: _getALlPosts,
          searchBarController: _searchBarController,
          placeHolder: Text("placeholder"),
          cancellationWidget: Text("Cancel"),
          emptyWidget: Text("empty"),
          indexedScaledTileBuilder: (int index) =>
              ScaledTile.count(1, index.isEven ? 2 : 1),
          onCancelled: () {
            print("Cancelled triggered");
          },
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 2,
          onItemFound: (Post post, int index) {
            return Container(
              color: Colors.lightBlue,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: (surgeryVariable.finalArr.length),
                  itemBuilder: (
                    BuildContext ctxt,
                    int index,
                  ) {
                    return _addCard(ctxt, index);
                  }),
//              child: ListTile(
//                title: Text(post.title),
//                isThreeLine: true,
//                subtitle: Text(post.body),
//                onTap: () {
//                  Navigator.of(context)
//                      .push(MaterialPageRoute(builder: (context) => Detail()));
//                },
//              ),
            );
          },
        ),
      ),
    );
  }

  Material myItems(
      String date,
      String time,
      String venue,
      String pname,
      String page,
      String prescription,
      String instructions,
      String surgeonName) {
    Color color = Colors.black;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date: " + date,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nTime: " + time,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nSurgeon Name :" + surgeonName,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nVenue: " + venue,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nPatient Name: " + pname,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nPatient Age: " + page,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nPrescription: " + prescription,
//                      "\nInstructions: " +
//                      instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\nInstructions: " + instructions,
                  style: TextStyle(color: color, fontSize: 15.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _addCard(BuildContext ctxt, int index) {
    print(surgeryVariable.finalArr[index]);
    var surgeryName = surgeryVariable.finalArr[index][0];
    var time = surgeryVariable.finalArr[index][1];
    var pid = surgeryVariable.finalArr[index][2];
    var pname = surgeryVariable.finalArr[index][3];
    var page = surgeryVariable.finalArr[index][4];
    var date = surgeryVariable.finalArr[index][5];
    var venue = surgeryVariable.finalArr[index][6];
    var prescription = surgeryVariable.finalArr[index][7];
    var instructions = surgeryVariable.finalArr[index][8];
    var surgeonName = surgeryVariable.finalArr[index][9];
    //{patient two: [[cardiac surgery, 04:19 am, patient two, Patient Two, 42, 2020-09-22, venue, prescription, instruction, surgeon name]]}

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            // SizedBox(
            //   height: 200,
            //   width: 1000,
            //   child: Container(
            //     child: Image.asset(
            //       "./assets/images/heart.jpg",
            //     ),
            //   ),
            // ),
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      surgeryName + "\n" + date + "\n" + time,
                      style:
                          TextStyle(fontSize: 18.0, color: Colors.blueAccent),
                      textAlign: TextAlign.left,
                    )),
                collapsed: Text(
                  pname + '\n' + surgeonName + "\n" + venue,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15.0),
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    myItems(date, time, venue, pname, page, prescription,
                        instructions, surgeonName),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text("Detail"),
          ],
        ),
      ),
    );
  }
}

//
//Column(
//children: [
//Row(
//children: [
//SafeArea(
//child: SearchBar<Post>(
//searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
//headerPadding: EdgeInsets.symmetric(horizontal: 10),
//listPadding: EdgeInsets.symmetric(horizontal: 10),
//onSearch: _getALlPosts,
//searchBarController: _searchBarController,
//placeHolder: Text("placeholder"),
//cancellationWidget: Text("Cancel"),
//emptyWidget: Text("empty"),
//indexedScaledTileBuilder: (int index) =>
//ScaledTile.count(1, index.isEven ? 2 : 1),
//header: Row(
//children: <Widget>[
//RaisedButton(
//child: Text("sort"),
//onPressed: () {
//_searchBarController.sortList((Post a, Post b) {
//return a.body.compareTo(b.body);
//});
//},
//),
//RaisedButton(
//child: Text("Desort"),
//onPressed: () {
//_searchBarController.removeSort();
//},
//),
//RaisedButton(
//child: Text("Replay"),
//onPressed: () {
//isReplay = !isReplay;
//_searchBarController.replayLastSearch();
//},
//),
//],
//),
//onCancelled: () {
//print("Cancelled triggered");
//},
//mainAxisSpacing: 10,
//crossAxisSpacing: 10,
//crossAxisCount: 2,
//onItemFound: (Post post, int index) {
//return Container(
//color: Colors.lightBlue,
//child: ListTile(
//title: Text(post.title),
//isThreeLine: true,
//subtitle: Text(post.body),
//onTap: () {
//Navigator.of(context).push(MaterialPageRoute(
//builder: (context) => Detail()));
//},
//),
//);
//},
//),
//),
//Column(
//children: <Widget>[
//RaisedButton(
//elevation: 3.0,
//padding: EdgeInsets.all(15.0),
//shape: RoundedRectangleBorder(
//borderRadius: BorderRadius.circular(10.0)),
//color: Colors.amberAccent,
//onPressed: () => _selectDate(context),
//child: Text(
//_date,
//style: TextStyle(
//color: Colors.black, fontWeight: FontWeight.bold),
//),
//),
////              surgeryVariable.surgery.containsKey(
////                          "${selectedDate.toLocal()}".split(' ')[0]) !=
////                      false
//                  ? ListView.builder(
//                      shrinkWrap: true,
//                      itemCount: (surgeryVariable
//                          .surgery["${selectedDate.toLocal()}".split(' ')[0]]
//                          .length),
//                      itemBuilder: (
//                        BuildContext ctxt,
//                        int index,
//                      ) {
//                        return _addCard(ctxt, index,
//                            ("${selectedDate.toLocal()}".split(' ')[0]));
//                      })
////                  : new Container(
////                      margin: EdgeInsets.only(top: 200.0),
////                      child: Center(
////                        child: Text(
////                          'No surgeries to display',
////                          style: TextStyle(
////                            fontSize: 20.0,
////                          ),
////                        ),
////                      ),
////                    ),
//],
//),
//],
//),
//],
//));
