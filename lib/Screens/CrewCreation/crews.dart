import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Models/club.dart';
import 'package:rowingapp/Models/crewGroup.dart';
import 'package:rowingapp/Models/workout.dart';
import 'package:rowingapp/Screens/CrewCreation/crew_members.dart';
import 'package:rowingapp/Services/database.dart';
import 'package:rowingapp/Services/main_Services.dart';
import 'package:rowingapp/Shared/colourScheme.dart';
import 'package:rowingapp/Shared/loading.dart';
import 'package:rowingapp/Shared/text_form_dec.dart';

import '../wrapper.dart';

class Crew extends StatefulWidget {
  //const Crew({Key key}) : super(key: key);
  final Workout workout;

  Crew({Key key, @required this.workout}) : super(key: key);

  @override
  _CrewState createState() => _CrewState();
}

class _CrewState extends State<Crew> {
  Future openCrewMemberScreen(context, workout, coach) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CrewMembers(workout: workout, coach: coach)));
  }

  List<String> boatImg = [
    'assets/images/boats/single.png',
    'assets/images/boats/double.png',
    'assets/images/boats/pair.png',
    'assets/images/boats/coxlessQuad.png',
    'assets/images/boats/coxlessFour.png',
    'assets/images/boats/eight.png',
    'assets/images/boats/octuple.png'
  ];

  String boat = '';
  var groupNum = 1;
  final _formKey = GlobalKey<FormState>();
  List<String> coaches = [];

  @override
  Widget build(BuildContext context) {
    final club = Provider.of<Club>(context);
    final admin = Provider.of<AdminModel>(context).getAdmin();

    return club == null
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: activeColourScheme.backgroundColour,
            appBar: AppBar(
              backgroundColor: activeColourScheme.navbarGeneral,
              elevation: 5.0,
              title: Text('Crews'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        color: activeColourScheme.headerColor,
                        onPressed: () {
                          setState(() {
                            widget.workout.crewGroups
                                .add(new CrewGroup(groupNum: groupNum));
                            groupNum++;
                            coaches.add("");
                          });
                        },
                        child: Text('Add Crew Group',
                            style: TextStyle(color: Colors.white)),
                      ),
                      RaisedButton(
                        color: activeColourScheme.headerColor,
                        onPressed: () {
                          setState(() {});
                        },
                        child:
                            Text('Save', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      scrollDirection: Axis.vertical,
                      itemCount: widget.workout.crewGroups.length,
                      itemBuilder: (context, index) {
                        if (widget.workout.crewGroups.length == 0) {
                          return Container();
                        } else {
                          return crewGroup(
                              widget.workout.crewGroups[index], index);
                        }
                      })
                ],
              ),
            ),
          );
  }

  crewGroup(CrewGroup group, final index) {
    final club = Provider.of<Club>(context);
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.workout.crewGroups.removeAt(index);
                    groupNum--;
                  });
                },
                icon: Icon(Icons.close),
              ),
              Container(
                width: 100,
                child: TextFormField(
                  validator: (val) => val.isEmpty ? 'Coach Name' : null,
                  initialValue: coaches[index],
                  // uses the final decoration defined in text_for_dec.dart
                  decoration: InputDecoration(hintText: 'Coach Name'),

                  onChanged: (val) {
                    setState(() => coaches[index] = val);
                  },
                ),
              ),
              Text('${widget.workout.crewGroups[index].groupNum}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  if (coaches[index].length != 0) {
                    if (widget.workout.groupNumList.contains(coaches[index])) {
                      print(coaches[index]);
                      openCrewMemberScreen(
                          context, widget.workout, coaches[index]);
                    } else {
                      widget.workout.groupNumList.add(coaches[index]);
                      print(widget.workout.groupNumList);
                      await Database('workout').updateDocument(
                          new Map<String, dynamic>.from({
                            'groupNumList': widget.workout.groupNumList,
                          }),
                          widget.workout.workoutId);
                      openCrewMemberScreen(
                          context, widget.workout, coaches[index]);
                    }
                  } else {}
                },
                child: Text('Edit Crews'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  boatWidget(DocumentSnapshot ds) {
    var indexImg = 0;
    var numCrew = 0;
    var cox = 0;
    if (ds.data['boatType'] == "1x") {
      indexImg = 0;
      numCrew = 1;
    } else if (ds.data['boatType'] == "2x" || ds.data['boatType'] == "2x/-") {
      indexImg = 1;
      numCrew = 2;
    } else if (ds.data['boatType'] == "2-") {
      indexImg = 2;
      numCrew = 2;
    } else if (ds.data['boatType'] == "4x") {
      indexImg = 3;
      numCrew = 4;
    } else if (ds.data['boatType'] == "4-") {
      indexImg = 4;
      numCrew = 4;
    } else if (ds.data['boatType'] == "4x/-") {
      indexImg = 3;
      numCrew = 4;
    }
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(ds.data['name']),
              Image.asset(boatImg[indexImg], height: 100, width: 200)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Crew"),
              // ListView.builder(
              //   itemCount: numCrew,
              //   itemBuilder: (context, index){
              //     DragTarget(builder: null)
              //   }
              //   )
            ],
          ),
        ],
      ),
    );
  }
}
