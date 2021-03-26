import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Models/workout.dart';
import 'package:rowingapp/Screens/CrewCreation/crews.dart';
import 'package:rowingapp/Screens/wrapper.dart';
import 'package:rowingapp/Services/database.dart';
import 'package:rowingapp/Services/main_Services.dart';
import 'package:rowingapp/Shared/colourScheme.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:rowingapp/Models/userData.dart';

/// This screen is for showing the full workout details from training main screen.
/// We can submit the attendance of workout from this screen
/// and it will sync with Firestore immediately

class WorkoutView extends StatefulWidget {
  final Workout workout;

  WorkoutView({Key key, @required this.workout}) : super(key: key);

  @override
  _WorkoutViewState createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  Future openCrewScreen(context, workout) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Crew(workout: workout)));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final admin = Provider.of<AdminModel>(context);

    final RoundedLoadingButtonController _btnController =
        new RoundedLoadingButtonController();

    bool attendance;

    return Scaffold(
      backgroundColor: activeColourScheme.backgroundColour,
      appBar: AppBar(
        title: Text('Workout Details'),
        backgroundColor: activeColourScheme.navbarGeneral,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.workout.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.person,
                    color: activeColourScheme.headerColor,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    'Your current status is: ' +
                        (widget.workout.attendingUser.contains(user.uid)
                            ? 'Attend'
                            : 'Absent'),
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    color: Colors.redAccent,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    'Location: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Expanded(
                    child: Text(
                      widget.workout.location,
                      style: TextStyle(
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'From',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'To',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        DateFormat('kk:mm - EEEE, dd MMM')
                            .format(widget.workout.startTime),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        DateFormat('kk:mm - EEEE, dd MMM')
                            .format(widget.workout.endTime),
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              widget.workout.comment != ''
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.note,
                          color: Colors.lightGreen,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Note: ',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
              widget.workout.comment != ''
                  ? SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              widget.workout.comment,
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 10.0),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
              widget.workout.workoutDescription != ''
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.assignment,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Workout Menu: ',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
              widget.workout.comment != ''
                  ? SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              widget.workout.workoutDescription,
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 10.0),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Do you Attend?',
                          style: TextStyle(fontSize: 20),
                        ),
                        LiteRollingSwitch(
                          //initial value
                          value: widget.workout.attendingUser
                                  ?.contains(user.uid) ??
                              false,
                          textOn: 'YES',
                          textOff: 'NO',
                          colorOn: Colors.greenAccent[700],
                          colorOff: Colors.redAccent[700],
                          iconOn: Icons.done,
                          iconOff: Icons.remove_circle_outline,
                          textSize: 16.0,
                          onChanged: (bool state) {
                            attendance = state;
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RoundedLoadingButton(
                      color: activeColourScheme.headerColor,
                      child: Text('Submit Attendance',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      controller: _btnController,
                      onPressed: () async {
                        if (attendance ==
                            widget.workout.attendingUser.contains(user.uid)) {
                          _btnController.stop();
                        } else {
                          try {
                            List<dynamic> _newWorkoutAttendList =
                                widget.workout.attendingUser ?? new List();
                            if (attendance == true) {
                              if (!_newWorkoutAttendList.contains(user.uid)) {
                                _newWorkoutAttendList.add(user.uid);
                              } else {
                                throw ('Workout ID was already deleted');
                              }
                            } else {
                              if (_newWorkoutAttendList.contains(user.uid)) {
                                _newWorkoutAttendList.remove(user.uid);
                              } else {
                                throw ('Workout ID was already deleted');
                              }
                            }

                            await Database('workout').updateDocument(
                                new Map<String, dynamic>.from({
                                  'attendingUser': _newWorkoutAttendList,
                                }),
                                widget.workout.workoutId);
                            _btnController.success();
                            setState(() {});
                          } catch (e) {
                            print(e);
                            _btnController.error();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 10.0,
              ),
              Text(
                'Crews: ',
                style: TextStyle(fontSize: 20),
              ),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.workout.groupNumList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder(
                        future: MainServices().getCrewGroup(
                            widget.workout.groupNumList[index],
                            widget.workout.workoutId),
                        builder: (
                          context,
                          AsyncSnapshot snapshot,
                        ) {
                          //print(index);
                          //print(snapshot);
                          if (!snapshot.hasData) {
                            return Container(
                              child: Center(child: Text("To be posted")),
                              width: 0,
                              height: 0,
                            );
                          }
                          // else if(snapshot.data.length == 0){
                          //   return Container(width: 0,
                          //     height: 0,);
                          // }
                          else {
                            //print(index);
                            //print(snapshot.data[index].data["boatID"]);

                            return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, indexboats) {
                                  return Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(snapshot
                                            .data[indexboats].data["boatID"]),
                                        SizedBox(width: 50),
                                        Container(
                                          height: 50,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: snapshot
                                                  .data[indexboats]
                                                  .data["athletes"]
                                                  .length,
                                              itemBuilder: (context, indexA) {
                                                if (snapshot
                                                        .data[indexboats]
                                                        .data["athletes"]
                                                        .length ==
                                                    0) {
                                                  return Container();
                                                } else {
                                                  return Container(
                                                    child: Center(
                                                      child: Text(snapshot
                                                              .data[indexboats]
                                                              .data["athletes"]
                                                          [indexA]),
                                                    ),
                                                  );
                                                }
                                              }),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          }
                        });
                  }),

              //admin.getAdmin() == true
              //?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: activeColourScheme.headerColor,
                    child: Text("Create Crews",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    onPressed: () {
                      openCrewScreen(context, widget.workout);
                    },
                  ),
                ],
              )
              //:  Container(
              //       width: 0,
              //       height: 0,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
