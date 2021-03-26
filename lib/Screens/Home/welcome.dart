import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Models/club.dart';
import 'package:rowingapp/Models/userData.dart';
import 'package:rowingapp/Models/workout.dart';
import 'package:rowingapp/Services/main_Services.dart';
import 'package:rowingapp/Shared/colourScheme.dart';
import 'package:rowingapp/Shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rowingapp/Models/board.dart';
import 'package:rowingapp/Screens/Home/noticeBoard/announceView.dart';
import 'package:rowingapp/Screens/Help/help_welcome.dart';

import '../wrapper.dart';

class Welcome extends StatefulWidget {
  //const Crew({Key key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

// TODO: move this somewhere else?
enum BoatType { single, double, pair, coxlessQuad, coxlessFour, eight, octuple }

// TODO: move this somewhere else?
class Passenger {
  String name;

  Passenger(String name) {
    this.name = name;
  }
}

String getPersonImage(int currentUserIndex, int selectedUserIndex) {
  if (currentUserIndex == selectedUserIndex) {
    return "assets/images/person_highlight.png";
  } else {
    return "assets/images/person.png";
  }
}

class _WelcomeState extends State<Welcome> {
  // static List<Widget> getPassengers(clubID) {
  //   List widgets = <Widget>[];
  //   Workout  _workout;

  // for (var passenger in _workout) {
  //   widgets.add(Container(
  //       padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
  //       decoration: BoxDecoration(
  //         border: new Border.all(color: Colors.black),
  //       ),
  //       child: Column(
  //         children: <Widget>[
  //           //add image stuff here
  //           Container(
  //             height: 50,
  //             width: 50,
  //             decoration: BoxDecoration(
  //               image: DecorationImage(
  //                 image: AssetImage("assets/images/person.png"),
  //               ),
  //             ),
  //           ),
  //           Text(passenger.name),
  //         ],
  //       )));
  // }
  int selectedUserIndex = 1;

  List<Widget> getPassengers(List<Passenger> passengers) {
    List widgets = <Widget>[];
    int i = 0;

    for (var passenger in passengers) {
      int currentIndex = i;

      widgets.add(new GestureDetector(
          onTap: () {
            selectedUserIndex = currentIndex;
            setState(() => {});
          },
          child: Container(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              margin: EdgeInsets.only(top: 0, bottom: 2, left: 0, right: 2),
              decoration: BoxDecoration(
                border:
                    new Border.all(color: activeColourScheme.navbarUnselected),
              ),
              child: Column(
                children: <Widget>[
                  //add image stuff here
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(getPersonImage(i, selectedUserIndex)),
                      ),
                    ),
                  ),
                  Text(passenger.name),
                ],
              ))));

      i++;
    }
    return widgets;
  }

  List<Widget> getPassengerIcons(List<Passenger> passengers) {
    List widgets = <Widget>[];
    int i = 0;

    for (var passenger in passengers) {
      int currentIndex = i;

      widgets.add(new GestureDetector(
        onTap: () {
          selectedUserIndex = currentIndex;
          setState(() => {});
        },
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(getPersonImage(i, selectedUserIndex)),
          )),
        ),
      ));

      i++;
    }

    return widgets;
  }

  Container getBoatImage(String boatType, String name) {
    if (boatType == null) {
      return Container();
    }
    return Container(
      //Image.asset("assets/images/boats/$boatType.png", height: 100, width: 200),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: activeColourScheme.navbarGeneral,
        image: DecorationImage(
          image: new AssetImage(boatType),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 0, left: 020, right: 0),
          child:
              Text(name, style: TextStyle(color: Colors.white, fontSize: 16))),
      //   child: Container(
      //       padding: EdgeInsets.only(top: 120, bottom: 0, left: 100, right: 100),
      //       child: Row(children: getPassengerIcons(passengers))),
      // );
    );
  }

  String bType;
  String bName = "a";
  List passengers = <Passenger>[];

  @override
  Widget build(BuildContext context) {
    final club = Provider.of<Club>(context);
    final user = Provider.of<UserData>(context);
    Board _board;
    // TODO: set the boat type correctly
    BoatType boatType = BoatType.octuple;
    List passengers = <Passenger>[
      Passenger("Bob"),
      Passenger("Mark"),
      Passenger("Lenny"),
      Passenger("Steve"),
      Passenger("Jared"),
      Passenger("Richard"),
      Passenger("Jason"),
      Passenger("David"),
    ];
    return club == null
        ? Loading()
        : Scaffold(
            backgroundColor: activeColourScheme.backgroundColour,
            appBar: AppBar(
              backgroundColor: activeColourScheme.navbarGeneral,
              elevation: 5.0,
              title: Text('Home'),
              centerTitle: true,
              actions: <Widget>[
                //Workout Creation from app bar.
                IconButton(
                  icon: Icon(Icons.help),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HelpWelcome()),
                    );
                  },
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child: Text(
                    "Welcome ${user.firstNameTrimmed()} to ${club.code}",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 25,
                        color: activeColourScheme.headerColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 15, top: 0),
                  child: Divider(
                    thickness: 4.0,
                    indent: 85.0,
                    endIndent: 85.0,
                  ),
                ),
                // Container(
                //   child: SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child:
                user.firstName == ''
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                            child: ListTile(
                                title:
                                    Text('Get Update User Infomation First!'))))
                    : FutureBuilder(
                        future: MainServices().getUpcomingWorkout(club.clubId,
                            1, "${user.firstName}.${user.lastName[0]}"),
                        builder: (_, snapshot) {
                          if (!snapshot.hasData) {
                            bType = null;
                            return Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Card(
                                    child: ListTile(
                                        title: Text('No Upcoming Event'))));
                          } else {
                            return Container(
                              height: 90,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data["athletes"].length,
                                  itemBuilder: (context, index) {
                                    if (snapshot.data["athletes"].length == 0) {
                                      return Container(
                                          child: Center(
                                        child: Text(
                                            "Crews for next session are coming"),
                                      ));
                                    } else {
                                      //passengers.add(Passenger(snapshot.data["athletes"][index]));
                                      bType =
                                          boatIndex(snapshot.data["boatType"]);
                                      bName = snapshot.data["boatID"];
                                      var seats =
                                          snapshot.data["athletes"].length;
                                      return Container(
                                          padding: EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 10,
                                              right: 10),
                                          decoration: BoxDecoration(
                                            border: new Border.all(
                                                color: Colors.black),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              //add image stuff here
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/person.png"),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                  "${seats - index}.${snapshot.data["athletes"][index]}"),
                                            ],
                                          ));
                                    }
                                  }),
                            );
                          }
                        }),

                getBoatImage(bType, bName),

                Container(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child: Text(
                    "Latest Announcement",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 25,
                        color: activeColourScheme.headerColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 15, top: 0),
                  child: Divider(
                    thickness: 4.0,
                    indent: 85.0,
                    endIndent: 85.0,
                  ),
                ),
                StreamBuilder(
                  stream: MainServices().getBoardWithLimit(club.clubId, 1),
                  builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Loading');
                    }
                    if (snapshot.data.documents.length != 0) {
                      snapshot.data.documents.forEach((result) {
                        _board = Board.fromMap(result.data, result.documentID);
                      });
                    } else {
                      return Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: new Card(
                              child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text('No Announcment Made Yet'),
                              )
                            ],
                          )));
                    }

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: new Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                //in the future, we may replace with user uploaded image in stead of initial
                                child: Text(
                                  (_board.firstName[0] ?? '') +
                                      (_board.lastName[0] ?? ''),
                                  style: TextStyle(
                                      color: activeColourScheme.headerColor),
                                ),
                                backgroundColor:
                                    activeColourScheme.backgroundColour,
                              ),
                              title: Text(
                                _board.subject,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                _board.body,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                (() {
                                  Duration _difference = DateTime.now()
                                      .difference(_board.timestamp);
                                  if (_difference.inMinutes < 1) {
                                    return 'now';
                                  } else if (_difference.inMinutes == 1) {
                                    return '${_difference.inMinutes} min ago';
                                  } else if (_difference.inHours < 1) {
                                    return '${_difference.inMinutes} mins ago';
                                  } else if (_difference.inHours == 1) {
                                    return '${_difference.inHours} hour ago';
                                  } else if (_difference.inDays < 1) {
                                    return '${_difference.inHours} hours ago';
                                  } else if (_difference.inDays == 1) {
                                    return '${_difference.inDays} day ago';
                                  } else if (_difference.inDays < 7) {
                                    return '${_difference.inDays} days ago';
                                  } else {
                                    return '${DateFormat('MMMM dd').format(_board.timestamp)}';
                                  }
                                })(),
                                style: TextStyle(fontSize: 12),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AnnounceView(board: _board)),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          );
  }

  String boatIndex(String boat) {
    String boatType;
    List<String> boatImg = [
      'assets/images/boats/single.png',
      'assets/images/boats/double.png',
      'assets/images/boats/pair.png',
      'assets/images/boats/coxlessQuad.png',
      'assets/images/boats/coxlessFour.png',
      'assets/images/boats/eight.png',
      'assets/images/boats/octuple.png'
    ];

    if (boat == "1x") {
      boatType = boatImg[0];
    } else if (boat == "2x" || boat == "2x/-") {
      boatType = boatImg[1];
    } else if (boat == "2-") {
      boatType = boatImg[2];
    } else if (boat == "4x") {
      boatType = boatImg[3];
    } else if (boat == "4-") {
      boatType = boatImg[4];
    } else if (boat == "4x/-") {
      boatType = boatImg[4];
    } else {
      boatType = boatImg[5];
    }

    return boatType;
  }
}