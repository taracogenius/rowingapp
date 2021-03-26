import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Services/main_Services.dart';
import 'package:rowingapp/Shared/colourScheme.dart';
import 'package:getflutter/getflutter.dart';

import '../wrapper.dart';

class OnWater extends StatelessWidget {
  const OnWater({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    final clubid = Provider.of<ClubIDModel>(context).getClubID();

    return MaterialApp(
      title: 'On Water',
      home: OnWaterPage(),
    );
  }
}

class OnWaterPage extends StatefulWidget {
  @override
  _OnWaterPageState createState() => _OnWaterPageState();
}

class _OnWaterPageState extends State<OnWaterPage> {
  ScrollController _scrollController = new ScrollController();
  Stopwatch _stopwatch = new Stopwatch();
  String _displayedTime = '00:00.00';
  final _duration = const Duration(milliseconds: 10);
  bool startIsPressed = true;
  bool stopIsPressed = false;
  List<Duration> _lapList = [];

  @override
  Widget build(BuildContext context) {
    //final clubid = Provider.of<ClubIDModel>(context).getClubID();

    return Scaffold(
      backgroundColor: activeColourScheme.backgroundColour,
      appBar: AppBar(
        backgroundColor: activeColourScheme.navbarGeneral,
        elevation: 5.0,
        title: Text('On Water'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RepaintBoundary(
                    child: Container(
                      child: Text(
                        _displayedTime,
                        style: TextStyle(fontSize: 70),
                      ),
                    ),
                  ),
                ]),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 80.0,
                  width: 80.0,
                  child: !stopIsPressed
                      ? FloatingActionButton(
                          backgroundColor: activeColourScheme.navbarGeneral,
                          child: Text(
                            'Lap',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: !startIsPressed
                              ? () {
                                  setState(() {
                                    _lapList.add(_stopwatch.elapsed);
                                  });
                                  _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                }
                              : null)
                      : FloatingActionButton(
                          child: Text(
                            'Reset',
                            style: TextStyle(fontSize: 20),
                          ),
                          backgroundColor: activeColourScheme.headerColor,
                          onPressed: () {
                            setState(() {
                              stopIsPressed = false;
                              _displayedTime = '00:00.00';
                              _lapList.clear();
                            });
                            _stopwatch.reset();
                          }),
                ),
                SizedBox(
                  width: 20.0,
                ),
                SizedBox(
                  height: 80.0,
                  width: 80.0,
                  child: startIsPressed
                      ? FloatingActionButton(
                          heroTag: null,
                          child: Text(
                            'Start',
                            style: TextStyle(fontSize: 20),
                          ),
                          backgroundColor: activeColourScheme.headerColor,
                          onPressed: () {
                            setState(() {
                              startIsPressed = false;
                              stopIsPressed = false;
                            });
                            _stopwatch.start();
                            startTimer();
                          })
                      : FloatingActionButton(
                          heroTag: null,
                          child: Text(
                            'Stop',
                            style: TextStyle(fontSize: 20),
                          ),
                          backgroundColor: Colors.redAccent[700],
                          onPressed: () {
                            setState(() {
                              startIsPressed = true;
                              stopIsPressed = true;
                            });
                            _stopwatch.stop();
                          }),
                )
              ],
            ),
          ),
          Divider(
            color: activeColourScheme.buttonBackgrounds,
            thickness: 2,
          ),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.topCenter,
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: _lapList.length,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return Card(
                    child: ListTile(
                      leading: Text(
                        'Lap ${index + 1}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      trailing: Text(
                        '${convertToDisplay(index == 0 ? _lapList[index] : _lapList[index] - _lapList[index - 1])}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startTimer() {
    Timer(_duration, keepRunning);
  }

  void keepRunning() {
    if (_stopwatch.isRunning) {
      startTimer();
    }
    setState(() {
      _displayedTime = convertToDisplay(_stopwatch.elapsed);
    });
  }

  String convertToDisplay(Duration dur) {
    String dispTime = (dur.inMinutes % 60).toString().padLeft(2, "0") +
        ':' +
        (dur.inSeconds % 60).toString().padLeft(2, "0") +
        '.' +
        (dur.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, "0");

    return dispTime;
  }
}

//      Scaffold(
//      backgroundColor: activeColourScheme.backgroundColour,
//      appBar: AppBar(
//        backgroundColor: Colors.blueAccent,
//        elevation: 5.0,
//        title: Text('On Water'),
//        centerTitle: true,
//      ),
//      body: SingleChildScrollView(
//        child: Column(
//          children: <Widget>[
//            FutureBuilder(
//              future: MainServices().clubUsersList(clubid),
//              builder: (context, AsyncSnapshot snapshot) {
//                if (!snapshot.hasData) {
//                  return Container();
//                } else {
//                  return ListView.builder(
//                    padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
//                    scrollDirection: Axis.vertical,
//                    shrinkWrap: true,
//                    itemCount: snapshot.data.length,
//                    itemBuilder: (context, index) {
//                      return Card(
//                        margin: EdgeInsets.fromLTRB(15, 0, 0, 15),
//                        child: Column(
//                          //mainAxisSize: MainAxisSize.max,
//                          children: <Widget>[
//                            Row(
//                              children: <Widget>[
//                                SizedBox(height: 50, width: 10),
//                                Icon(Icons.person),
//                                SizedBox(width: 10),
//                                Text(snapshot.data[index]['firstName']),
//                              ],
//                            ),
//                          ],
//                        ),
//                      );
//                    },
//                  );
//                }
//              },
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
