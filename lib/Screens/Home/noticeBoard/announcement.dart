import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Models/board.dart';
import 'package:rowingapp/Models/club.dart';
import 'package:rowingapp/Models/userData.dart';
import 'package:rowingapp/Services/database.dart';
import 'package:rowingapp/Shared/colourScheme.dart';
import 'package:rowingapp/Shared/text_form_dec.dart';
import 'package:getflutter/getflutter.dart';

/// This script is for the screen of Making Announcement by admin
/// If successfully made announcement,
/// new Announcement info upload to Firestore and it pops back to the last screen

class Announcement extends StatefulWidget {
  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  List<Board> boardMessages = List();
  final _formKey = GlobalKey<FormState>();
  Board board = new Board();
  bool _checkBoxValue = false;
  bool _firstPress = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final club = Provider.of<Club>(context);
    final user = Provider.of<UserData>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: activeColourScheme.backgroundColour,
      appBar: AppBar(
        title: new Text("Announcement Maker"),
        backgroundColor: activeColourScheme.navbarGeneral,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 15, top: 30, right: 15),
        child: Center(
          child: Form(
            key: _formKey,
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Text(
                    "Create an announcement",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 30,
                        color: activeColourScheme.headerColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 20, top: 10),
                  child: Divider(
                    thickness: 5.0,
                    indent: 85.0,
                    endIndent: 85.0,
                  ),
                ),
                ListTile(
                  //leading: Icon(Icons.subject),
                  title: TextFormField(
                    initialValue: '',
                    validator: (val) =>
                        val == '' ? 'Enter a subject of Announcement' : null,
                    decoration: textInputDecorationTwo.copyWith(
                        filled: true,
                        fillColor: Colors.white70,
                        hintText: 'Subject'),
                    onChanged: (val) {
                      setState(() => board.subject = val);
                    },
                  ),
                ),
                ListTile(
                  // leading: Icon(Icons.message),
                  title: TextFormField(
                    initialValue: '',
                    validator: (val) =>
                        val.isEmpty ? 'Enter a body of Announcement' : null,
                    decoration: textInputDecorationTwo.copyWith(
                        filled: true,
                        fillColor: Colors.white70,
                        hintText: 'Body'),
                    maxLines: 12,
                    minLines: 12,
                    onChanged: (val) {
                      setState(() => board.body = val);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Pinned Announcement'),
                    Checkbox(
                      value: _checkBoxValue,
                      onChanged: (bool _value) {
                        setState(() {
                          _checkBoxValue = _value;
                        });
                      },
                    ),
                  ],
                ),
                GFButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  shape: GFButtonShape.pills,
                  size: GFSize.LARGE,
                  child: Text("Post"),
                  color: activeColourScheme.buttonBackgrounds,
                  onPressed: () async {
                    /// Check if the inputs are right format we defined
                    /// If true upload new Board Info to Firestore

                    if (_firstPress == true &&
                        _formKey.currentState.validate()) {
                      _firstPress = false;
                      board.pinned = _checkBoxValue;
                      board.uid = user.uid;
                      board.firstName = user.firstName;
                      board.lastName = user.lastName;
                      board.clubId = club.clubId;
                      board.timestamp = DateTime.now();
                      await Database('board').addDocument(board.toJson());
                      Navigator.pop(context, () {
                        setState(() {});
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
