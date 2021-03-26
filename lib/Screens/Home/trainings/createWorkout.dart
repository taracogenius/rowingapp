import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Models/club.dart';
import 'package:rowingapp/Services/database.dart';
import 'package:rowingapp/Models/workout.dart';
import 'package:rowingapp/Shared/colourScheme.dart';
import 'package:rowingapp/Shared/text_form_dec.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:getflutter/getflutter.dart';

/// This screen is creation of the new Workout for admin
///
/// The input data will be validated to ensure expected format
/// when they tried to submit the new workout to Firestore

class CreateWorkout extends StatefulWidget {
  @override
  _CreateWorkoutState createState() => _CreateWorkoutState();
}

class _CreateWorkoutState extends State<CreateWorkout> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(Duration(hours: 1));
  String location = '';
  String workoutDescription = '';
  String comment = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final club = Provider.of<Club>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: activeColourScheme.backgroundColour,
      appBar: AppBar(
        backgroundColor: activeColourScheme.navbarGeneral,
//        backgroundColor: Colors.blueAccent,
//        elevation: 5.0,
        title: Text('Add New Workout'),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: Form(
              key: _formKey,
              //SingleChildScrollView means no overflow when using keyboard
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 35.0),

                    //Workout title form field
                    TextFormField(
                      validator: (val) =>
                          val.isEmpty ? 'Enter a title of workout' : null,
                      initialValue: title,
                      // uses the final decoration defined in text_for_dec.dart
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Workout Title *', prefixIcon: null),
                      onChanged: (val) {
                        setState(() => title = val);
                      },
                    ),

                    SizedBox(height: 10.0),

                    //Location form field (will be replaced with DropDownButton)
                    TextFormField(
                      validator: (val) =>
                          val.isEmpty ? 'Enter an Workout Location' : null,
                      // uses the final decoration defined in text_for_dec.dart
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Workout Location *',
                          prefixIcon: Icon(Icons.location_on)),
                      onChanged: (val) {
                        setState(() => location = val);
                      },
                    ),

                    SizedBox(height: 10.0),

                    GFButton(
                      color: activeColourScheme.buttonBackgrounds,
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true, onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          print('confirm $date');
                          setState(() => startTime = date);
                          if (startTime.compareTo(endTime) > 0) {
                            setState(() =>
                                endTime = startTime.add(Duration(hours: 1)));
                          }
                        }, currentTime: startTime, locale: LocaleType.en);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Start Time',
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy - kk:mm').format(startTime),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),

                    GFButton(
                      color: activeColourScheme.buttonBackgrounds,
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true, onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          print('confirm $date');
                          setState(() => endTime = date);
                          if (endTime.compareTo(startTime) < 0) {
                            setState(() => startTime =
                                endTime.subtract(Duration(hours: 1)));
                          }
                        }, currentTime: endTime, locale: LocaleType.en);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'End Time',
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy - kk:mm').format(endTime),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.0),

                    //comment form field
                    TextFormField(
                      initialValue: workoutDescription,
                      // uses the final decoration defined in text_for_dec.dart
                      decoration: textInputDecorationTwo.copyWith(
                          hintText: 'Workout Description', prefixIcon: null),
                      onChanged: (val) {
                        setState(() => workoutDescription = val);
                      },
                      maxLines: 5,
                      minLines: 3,
                    ),

                    SizedBox(height: 10.0),

                    //comment form field
                    TextFormField(
                      initialValue: comment,
                      // uses the final decoration defined in text_for_dec.dart
                      decoration: textInputDecorationTwo.copyWith(
                          hintText: 'Any Comment on Workout', prefixIcon: null),
                      onChanged: (val) {
                        setState(() => comment = val);
                      },
                      maxLines: 5,
                      minLines: 3,
                    ),

                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),

                    SizedBox(height: 5.0),

                    RaisedButton(
                      color: activeColourScheme.headerColor,
                      child: Text('Add', style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        // need to add proper validation on the validate functions for each field
                        if (_formKey.currentState.validate()) {
                          // creates workout instance to upload the workout data,
                          // some of attributes/fields remain null since it is going to be updated
                          // later in trainings and crews screen.
                          Workout newWorkout = new Workout(
                            title: title,
                            startTime: startTime,
                            endTime: endTime,
                            duration: endTime.difference(startTime).inMinutes,
                            location: location,
                            workoutDescription: workoutDescription,
                            comment: comment,
                            clubId: club.clubId,
                          );

                          //Upload new workout information on firestore
                          await Database('workout')
                              .addDocument(newWorkout.toJson());
                          Navigator.pop(context, () {
                            setState(() {});
                          });
                        }
                      },
                    ),
                  ],
                ),
              ))),
    );
  }
}
