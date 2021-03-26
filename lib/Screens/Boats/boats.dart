import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Models/boatGroup.dart';
import 'package:rowingapp/Models/club.dart';
import 'package:rowingapp/Services/main_Services.dart';
import 'package:rowingapp/Shared/colourScheme.dart';
import '../wrapper.dart';
import 'add_boat.dart';

class BoatCreation extends StatefulWidget {
  final Club club;

  const BoatCreation({
    Key key,
    this.club,
  }) : super(key: key);

  @override
  _BoatCreationState createState() => _BoatCreationState();
}

class _BoatCreationState extends State<BoatCreation> {
  Future openAddBoat(context, bGroupID) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddBoat(bGroup: bGroupID)));
  }

  @override
  Widget build(BuildContext context) {
    final clubid = Provider.of<ClubIDModel>(context).getClubID();
    final Firestore _firestore = Firestore.instance;

    return widget.club == null
        ? Container()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: activeColourScheme.navbarGeneral,
              elevation: 5.0,
              title: Text('Club Settings'),
            ),
            body: StreamBuilder<Object>(
                stream: _firestore
                    .collection("BoatGroup")
                    .document(widget.club.boatGroup)
                    .snapshots(),
                builder: (context, snapshots) {
                  if (!snapshots.hasData) {
                    return Container();
                  } else {
                    DocumentSnapshot ds = snapshots.data;
                    return Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ),
                                RaisedButton.icon(
                                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    openAddBoat(context, ds.documentID);
                                  },
                                  label: Text("Add a New Boat"),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ),
                                Text('The Clubs boats')
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: FutureBuilder(
                                future: MainServices()
                                    .clubBoatList(widget.club.boatGroup),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  } else {
                                    return ListView.builder(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 20, 20, 0),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          margin:
                                              EdgeInsets.fromLTRB(15, 0, 0, 15),
                                          child: Column(
                                            //mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                      height: 50, width: 10),
                                                  Icon(Icons.directions_boat),
                                                  SizedBox(width: 10),
                                                  Text(snapshot.data[index]
                                                      ['name']),
                                                  SizedBox(width: 20),
                                                  Text(snapshot.data[index]
                                                      ['boatType']),
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
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }),
          );
  }
}
