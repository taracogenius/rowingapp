import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Models/boatType.dart';
import 'package:rowingapp/Models/club.dart';
import 'package:rowingapp/Models/crewGroup.dart';
import 'package:rowingapp/Models/crewModel.dart';
import 'package:rowingapp/Models/workout.dart';
import 'package:rowingapp/Services/main_Services.dart';
import 'package:rowingapp/Shared/colourScheme.dart';
import 'package:rowingapp/Shared/loading.dart';
import '../wrapper.dart';
import 'package:rowingapp/Shared/text_form_dec.dart';

class CrewMembers extends StatefulWidget {
  final Workout workout;
  final String coach;

  CrewMembers({Key key, @required this.workout, this.coach}) : super(key: key);

  @override
  _CrewMembersState createState() => _CrewMembersState();
}

class _CrewMembersState extends State<CrewMembers> {
  List<String> boatImg = [
    'assets/images/boats/single.png',
    'assets/images/boats/double.png',
    'assets/images/boats/pair.png',
    'assets/images/boats/coxlessQuad.png',
    'assets/images/boats/coxlessFour.png',
    'assets/images/boats/eight.png',
    'assets/images/boats/octuple.png'
  ];

  List<BoatType> boats = [];
  List<BoatType> addBoats = [];
  dynamic boatsfromFirebase = [];
  String boat = '';

  List<CrewModel> crews = [];

  DropdownMenuItem items(boat) {
    return DropdownMenuItem(
      child: Text(boat.name),
      value: boat.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    final club = Provider.of<Club>(context);
    final _formKey = GlobalKey<FormState>();

    return club == null
        ? Loading()
        : Scaffold(
            backgroundColor: activeColourScheme.backgroundColour,
            appBar: AppBar(
              backgroundColor: activeColourScheme.navbarGeneral,
              elevation: 5.0,
              title: Text('Crew Seating'),
              centerTitle: true,
            ),
            body: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      color: activeColourScheme.headerColor,
                      onPressed: () {
                        MainServices().addCrewsToWorokout(
                            crews, widget.workout.workoutId);
                      },
                      child:
                          Text('Save', style: TextStyle(color: Colors.white)),
                    ),
                    FutureBuilder(
                      future: MainServices().clubBoatList(club.boatGroup),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else if (snapshot.data.isEmpty) {
                          return Text('Add Boat from Club Setting');
                        } else {
                          List<DropdownMenuItem> boatItems = [];
                          for (var ds in snapshot.data) {
                            boats.add(BoatType(
                                boatType: ds['boatType'],
                                name: ds["name"],
                                riggedAs: ds["riggedAs"]));
                            boatItems.add(DropdownMenuItem(
                              child: Text(ds["name"]),
                              value: ds["name"],
                            ));
                          }
                          boat = snapshot.data[0]['name'];

                          return DropdownButton(
                            items: boatItems,
                            onChanged: (newValue) {
                              for (var boat in boats) {
                                if (boat.name == newValue) {
                                  setState(() {
                                    addBoats.add(boat);
                                    boats.remove(boat);
                                    //boatItems.remove(value)
                                  });
                                }
                              }
                            },
                            value: boat,
                          );
                        }
                      },
                    ),
                  ],
                ),
                attendingUserWidget(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: addBoats.length,
                    itemBuilder: (context, index) {
                      for (var boats in addBoats) {
                        if (crews.length == 0) {
                          crews.add(new CrewModel(
                              boatID: boats.name,
                              boatType: boats.boatType,
                              athletes: boatNames(boats),
                              coach: widget.coach));
                        } else {
                          CrewModel temp = new CrewModel(
                              boatID: boats.name,
                              boatType: boats.boatType,
                              athletes: boatNames(boats),
                              coach: widget.coach);
                          bool add = true;
                          for (var crew in crews) {
                            if (temp.boatID == crew.boatID) {
                              add = false;
                            }
                          }
                          if (add) {
                            crews.add(temp);
                          }
                        }
                      }
                      return boatWidget(addBoats[index], index);
                    },
                  ),
                ),
              ],
            ),
          );
  }

  boatWidget(BoatType boat, int indexBoat) {
    var indexImg = 0;
    var numCrew = 0;
    var cox = 0;

    if (boat.boatType == "1x") {
      indexImg = 0;
      numCrew = 1;
    } else if (boat.boatType == "2x" || boat.boatType == "2x/-") {
      indexImg = 1;
      numCrew = 2;
    } else if (boat.boatType == "2-") {
      indexImg = 2;
      numCrew = 2;
    } else if (boat.boatType == "4x") {
      indexImg = 3;
      numCrew = 4;
    } else if (boat.boatType == "4-") {
      indexImg = 4;
      numCrew = 4;
    } else if (boat.boatType == "4x/-") {
      indexImg = 3;
      numCrew = 4;
    } else {
      numCrew = 8;
      indexImg = 3;
    }
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  setState(() {
                    boats.remove(boat);
                    addBoats.remove(boat);
                    crews.removeAt(indexBoat);
                  });
                },
                icon: Icon(Icons.close),
              ),
              Text(boat.name),
              Image.asset(boatImg[indexImg], height: 100, width: 200)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Text("Crew"),
              Container(
                padding: EdgeInsets.all(5),
                height: 70,
                width: 300,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numCrew,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return DragTarget(
                        builder: (context, candidateData, rejectedData) {
                          //print("cand");
                          //print(candidateData);
                          print(crews[indexBoat].athletes);

                          if (crews[indexBoat].athletes[index] == "") {
                            return Center(
                                child: Container(
                                    color: Colors.grey,
                                    height: 50,
                                    width: 60,
                                    child: Center(
                                        child: Text("${numCrew - index}"))));
                          } else {
                            return Center(
                                child: Container(
                                    color: Colors.grey,
                                    height: 50,
                                    width: 60,
                                    child: Center(
                                        child: Text(crews[indexBoat]
                                            .athletes[index]))));
                          }
                        },
                        onAccept: (data) {
                          setState(() {
                            crews[indexBoat].athletes[index] = data;
                          });
                        },
                        onWillAccept: (data) {
                          return true;
                        },
                        // onLeave: (data){
                        //   setState(() {
                        //     crews[indexBoat].athletes[index] = "";
                        //   });
                        // },
                      );
                    }),
              )
            ],
          ),
        ],
      ),
    );
  }

  attendingUserWidget() {
    return FutureBuilder(
        future: MainServices().workUsers(widget.workout.attendingUser),
        builder: (context, AsyncSnapshot snapshot) {
          print("hello");
          if (!snapshot.hasData) {
            return Container();
          } else {
            return Container(
              height: 80,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    //print(snapshot.data[index].documentID);
                    return Container(
                      padding: const EdgeInsets.all(5),
                      child: Draggable(
                        data: snapshot.data[index]["firstName"] +
                            "." +
                            snapshot.data[index]["lastName"][0],
                        childWhenDragging: Container(
                            //color: lst.getColor(index),
                            width: 100,
                            child: Column(children: <Widget>[
                              Text(snapshot.data[index]["firstName"]),
                              Icon(Icons.person, color: Colors.grey, size: 50),
                              //Text(lst.getSide(index)),
                            ])),
                        feedback: Column(
                          children: <Widget>[
                            Icon(Icons.person,
                                size: 50 //color: lst.getColor(index), size: 50
                                ),
                          ],
                        ),
                        child: Container(
                            //color: lst.getColor(index),
                            width: 100,
                            child: Column(
                              children: <Widget>[
                                Text(snapshot.data[index]["firstName"]),
                                Icon(Icons.person,
                                    color: Colors.white, size: 50),
                                //Text(lst.getSide(index)),
                              ],
                            )),
                      ),
                    );
                  }),
            );
          }
        });
  }

  List<String> boatNames(BoatType boat) {
    List<String> name = [];
    print(boat.boatType);
    if (boat.boatType == "1x") {
      name = [""];
    } else if (boat.boatType == "2x" || boat.boatType == "2x/-") {
      name = ["", ""];
    } else if (boat.boatType == "2-") {
      name = ["", ""];
    } else if (boat.boatType == "4x") {
      name = ["", "", "", ""];
    } else if (boat.boatType == "4-") {
      name = ["", "", "", ""];
    } else if (boat.boatType == "4x/-") {
      name = ["", "", "", ""];
    }
    return name;
  }
}
