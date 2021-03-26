import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Models/boatGroup.dart';
import 'package:rowingapp/Models/boatType.dart';
import 'package:rowingapp/Models/club.dart';
import 'package:rowingapp/Services/database.dart';
import 'package:rowingapp/Services/main_Services.dart';
import 'package:rowingapp/Shared/text_form_dec.dart';
import 'package:rowingapp/Shared/colourScheme.dart';

class AddBoat extends StatefulWidget {
  final String bGroup;

  const AddBoat({
    Key key,
    this.bGroup,
  }) : super(key: key);

  @override
  _AddBoatState createState() => _AddBoatState();
}

class _AddBoatState extends State<AddBoat> {
  String name = '';
  String boatType;
  String error = '';

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    //final bGroup = Provider.of<Club>(context);

    List<String> types = [
      "1x",
      "2x",
      "2-",
      "2x/-",
      "4x",
      "4-",
      "4x/-",
      "4x+",
      "4+",
      "4x/+",
      "8+"
    ];

    return Scaffold(
      backgroundColor: activeColourScheme.backgroundColour,
      appBar: AppBar(
        backgroundColor: activeColourScheme.navbarGeneral,
        elevation: 5.0,
        title: Text('Add a New Boat'),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
              key: _formKey,
              //SingleChildScrollView means no overflow when using keyboard
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 100.0),

                    TextFormField(
                      validator: (val) =>
                          val.isEmpty ? 'Enter a Boat Name' : null,
                      // uses the final decoration defined in text_for_dec.dart
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Boat Name',
                          prefixIcon: Icon(Icons.person)),
                      onChanged: (val) {
                        setState(() => name = val);
                      },
                    ),

                    SizedBox(height: 10.0),

                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Text("Select the Boat Type"),
                        SizedBox(
                          width: 100,
                        ),
                        DropdownButton(
                          value: boatType,
                          items: types.map((newValue) {
                            return DropdownMenuItem(
                              value: newValue,
                              child: Text(newValue),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              boatType = newValue;
                              print(boatType);
                            });
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 10.0),

                    // Row(
                    //   children: <Widget>[
                    //     SizedBox(width: 20,),
                    //     Text('Is the boat coxed?'),
                    //     SizedBox(width: 100,),
                    //     Switch(
                    //       value: _coxed,
                    //       activeColor: Colors.green,
                    //       onChanged: (bool value) {
                    //         setState(() {
                    //           _coxed = value;
                    //           print(_coxed);
                    //         });
                    //       },
                    //     ),
                    //   ],
                    // ),

                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),

                    SizedBox(height: 5.0),

                    RaisedButton(
                        color: activeColourScheme.headerColor,
                        child: Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          // need to add proper validation on the validate functions for each field
                          if (_formKey.currentState.validate()) {
                            BoatType bt =
                                BoatType(name: name, boatType: boatType);

                            await MainServices()
                                .addBoat(widget.bGroup, bt.toJson());
                          }
                        }),
                  ],
                ),
              ))),
    );
  }
}
