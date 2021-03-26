import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Services/main_Services.dart';
import 'package:rowingapp/Shared/colourScheme.dart';
import 'package:rowingapp/Shared/text_form_dec.dart';
import '../../wrapper.dart';
import 'package:getflutter/getflutter.dart';

class MakeNewChat extends StatefulWidget {
  @override
  _MakeNewChatState createState() => _MakeNewChatState();
}

class _MakeNewChatState extends State<MakeNewChat> {
  String name = '';
  bool _coxed = false;
  String boatType;
  String error = '';

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    bool loading = false;
    final clubid = Provider.of<ClubIDModel>(context).getClubID();

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
      appBar: AppBar(
        backgroundColor: activeColourScheme.navbarGeneral,
        elevation: 5.0,
        title: Text('Create a new Chat'),
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
                    SizedBox(height: 50.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GFButton(
                            color: activeColourScheme.buttonBackgrounds,
                            child: Text("Add"),
                            onPressed: () async {
                              // need to add proper validation on the validate functions for each field
                              if (_formKey.currentState.validate()) {}
                            }),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    //First name form field
                    TextFormField(
                      validator: (val) =>
                          val.isEmpty ? 'Enter the Chat Name' : null,
                      initialValue: name,
                      // uses the final decoration defined in text_for_dec.dart
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Chat Name',
                          prefixIcon: Icon(Icons.person)),
                      onChanged: (val) {
                        setState(() => name = val);
                      },
                    ),

                    SizedBox(height: 10.0),

                    FutureBuilder(
                      future: MainServices().clubUsersList(clubid),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else {
                          return ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.fromLTRB(15, 0, 0, 15),
                                child: Column(
                                  //mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SizedBox(height: 50, width: 10),
                                        Icon(Icons.person),
                                        SizedBox(width: 10),
                                        Text(snapshot.data[index]['firstName']),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),

                    Text(
                      error,
                      style: TextStyle(
                          color: activeColourScheme.errorAction,
                          fontSize: 14.0),
                    ),
                  ],
                ),
              ))),
    );
  }
}
