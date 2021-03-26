import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Models/board.dart';
import 'package:rowingapp/Models/userData.dart';
import 'package:rowingapp/Services/database.dart';
import 'package:rowingapp/Shared/colourScheme.dart';

/// Announcement View is for the screen of the full detailed Announcement Info
/// when you tapped simplified announcement

class AnnounceView extends StatefulWidget {
  final Board board;

  AnnounceView({Key key, @required this.board}) : super(key: key);

  @override
  _AnnounceViewState createState() => _AnnounceViewState();
}

class _AnnounceViewState extends State<AnnounceView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: activeColourScheme.backgroundColour,
      appBar: AppBar(
        title: Text('Announcement Details'),
        centerTitle: true,
        backgroundColor: activeColourScheme.navbarGeneral,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.board.subject,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.0),
              StreamBuilder(
                  stream: Database('User').streamDocumentById(widget.board.uid),
                  builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) return const Text('Loading...');
                    UserData _author =
                        UserData.fromMap(snapshot.data.data, widget.board.uid);
                    return Row(
                      children: <Widget>[
                        CircleAvatar(
                          //in the future, we may replace with user uploaded
                          //image in stead of initial
                          child: Text(
                              (_author.firstName[0] + '') +
                                  (_author.lastName[0] ?? ''),
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: activeColourScheme.headerColor,
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _author.firstName + _author.lastName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat('kk:mm - EEEE, dd MMM yyyy')
                                  .format(widget.board.timestamp),
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    );
                  }),
              Divider(
                color: Colors.black,
              ),
              Text(
                widget.board.body,
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
