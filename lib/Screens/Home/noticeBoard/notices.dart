import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Models/User.dart';
import 'package:rowingapp/Models/board.dart';
import 'package:rowingapp/Models/club.dart';
import 'package:rowingapp/Screens/Home/noticeBoard/announcement.dart';
import 'package:rowingapp/Services/database.dart';
import 'package:rowingapp/Shared/colourScheme.dart';
import 'package:rowingapp/Models/userData.dart';
import 'package:rowingapp/Services/main_Services.dart';
import 'announceView.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rowingapp/Shared/colourScheme.dart';
import 'package:google_fonts/google_fonts.dart';

/// This is for the screen that main notice board page.
/// It shows the List of simplified announcement (pinned > unpinned)
///
/// By query the Firestore by stream and sort the Board data
/// into pinned announcement list and not pinned announcement list


class Notices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Notices',
      home: new NoticesPage(),
    );
  }
}

void main() {
  // Just so I can run it here.
  runApp(Notices());
}

class NoticesPage extends StatefulWidget {
  @override
  _NoticeBoard createState() => new _NoticeBoard();
}

class _NoticeBoard extends State<NoticesPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Board> _pinnedList = <Board>[];
  List<Board> _unpinnedList = <Board>[];

  //ListModel<int> _list;
  int _selectedItem;
  bool changed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final club = Provider.of<Club>(context);
    final user = Provider.of<UserData>(context);
    Board board;
    UserData author;
    return Scaffold(
      backgroundColor: activeColourScheme.backgroundColour,
      appBar: new AppBar(
        //Appbar has new style.
        backgroundColor: activeColourScheme.navbarGeneral,
        title: Text("Rowing Events"),
        elevation: 5.0,
        centerTitle: true,
        actions: <Widget>[
          //Workout Creation from app bar.
          Visibility(
            visible: user.firstName != '' && user.lastName != '', //_admin,
            child: IconButton(
              icon: Icon(Icons.add),
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Announcement()),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: club != null
              ? StreamBuilder(
                  key: _listKey,
                  stream: MainServices().getBoard(club.clubId),
                  builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Loading');
                    }
                    _pinnedList.clear();
                    _unpinnedList.clear();

                    snapshot.data.documents.forEach((result) {
                      board = Board.fromMap(result.data, result.documentID);
                      if (board.pinned) {
                        _pinnedList.add(board);
                      } else {
                        _unpinnedList.add(board);
                      }
                    });

                    _pinnedList
                        .sort((b, a) => a.timestamp.compareTo(b.timestamp));
                    _unpinnedList
                        .sort((b, a) => a.timestamp.compareTo(b.timestamp));

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _pinnedList.isNotEmpty
                            ? Container(
                                padding: EdgeInsets.only(top: 4, bottom: 10),
                                child: Center(
                                  child: Text(
                                    "Pinned Announcements",
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        fontSize: 23,
                                        color: activeColourScheme.headerColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        _pinnedList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: _pinnedList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, index) {
                                  return Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.20,
                                    child: new Card(
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            leading: CircleAvatar(
                                              //in the future, we may replace with user uploaded image in stead of initial
                                              child: Text(
                                                (_pinnedList[index]
                                                            .firstName[0] ??
                                                        '') +
                                                    (_pinnedList[index]
                                                            .lastName[0] ??
                                                        ''),
                                                style: TextStyle(
                                                    color: activeColourScheme
                                                        .headerColor),
                                              ),
                                              backgroundColor:
                                                  activeColourScheme
                                                      .backgroundColour,
                                            ),
                                            title: Text(
                                              _pinnedList[index].subject,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            subtitle: Text(
                                              _pinnedList[index].body,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            trailing: Text(
                                              (() {
                                                Duration _difference =
                                                    DateTime.now().difference(
                                                        _pinnedList[index]
                                                            .timestamp);
                                                if (_difference.inMinutes < 1) {
                                                  return 'now';
                                                } else if (_difference
                                                        .inMinutes ==
                                                    1) {
                                                  return '${_difference.inMinutes} min ago';
                                                } else if (_difference.inHours <
                                                    1) {
                                                  return '${_difference.inMinutes} mins ago';
                                                } else if (_difference
                                                        .inHours ==
                                                    1) {
                                                  return '${_difference.inHours} hour ago';
                                                } else if (_difference.inDays <
                                                    1) {
                                                  return '${_difference.inHours} hours ago';
                                                } else if (_difference.inDays ==
                                                    1) {
                                                  return '${_difference.inDays} day ago';
                                                } else if (_difference.inDays <
                                                    7) {
                                                  return '${_difference.inDays} days ago';
                                                } else {
                                                  return '${DateFormat('MMMM dd').format(_pinnedList[index].timestamp)}';
                                                }
                                              })(),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AnnounceView(
                                                            board: _pinnedList[
                                                                index])),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      IconSlideAction(
                                        caption: 'Unpin',
                                        color: Colors.yellow,
                                        icon: Icons.remove_circle,
                                        onTap: () async {
                                          await Database('board')
                                              .updateDocument(
                                                  new Map<String,
                                                      dynamic>.from({
                                                    'pinned': false,
                                                  }),
                                                  _pinnedList[index].boardId);
                                        },
                                      )
                                    ],
                                    secondaryActions: <Widget>[
                                      IconSlideAction(
                                        caption: 'Delete',
                                        color: Colors.red,
                                        icon: Icons.delete,
                                        onTap: () async {
                                          await Database('board')
                                              .removeDocument(
                                                  _pinnedList[index].boardId);
                                        },
                                      ),
                                    ],
                                  );
                                })
                            : Container(),
                        _pinnedList.isNotEmpty && _unpinnedList.isNotEmpty
                            ? Divider(
                                color: activeColourScheme.headerColor,
                              )
                            : Container(),
                        _unpinnedList.isNotEmpty
                            ? ListView.builder(
                                itemCount: _unpinnedList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, index) {
                                  return Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.20,
                                    child: new Card(
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            leading: CircleAvatar(
                                              //in the future, we may replace with user uploaded image in stead of initial
                                              child: Text(
                                                (_unpinnedList[index]
                                                            .firstName[0] ??
                                                        '') +
                                                    (_unpinnedList[index]
                                                            .lastName[0] ??
                                                        ''),
                                                style: TextStyle(
                                                    color: activeColourScheme
                                                        .headerColor),
                                              ),
                                              backgroundColor:
                                                  activeColourScheme
                                                      .backgroundColour,
                                            ),
                                            title: Text(
                                              _unpinnedList[index].subject,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            subtitle: Text(
                                              _unpinnedList[index].body,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            trailing: Text(
                                              (() {
                                                Duration _difference =
                                                    DateTime.now().difference(
                                                        _unpinnedList[index]
                                                            .timestamp);
                                                if (_difference.inMinutes < 1) {
                                                  return 'now';
                                                } else if (_difference
                                                        .inMinutes ==
                                                    1) {
                                                  return '${_difference.inMinutes} min ago';
                                                } else if (_difference.inHours <
                                                    1) {
                                                  return '${_difference.inMinutes} mins ago';
                                                } else if (_difference
                                                        .inHours ==
                                                    1) {
                                                  return '${_difference.inHours} hour ago';
                                                } else if (_difference.inDays <
                                                    1) {
                                                  return '${_difference.inHours} hours ago';
                                                } else if (_difference.inDays ==
                                                    1) {
                                                  return '${_difference.inDays} day ago';
                                                } else if (_difference.inDays <
                                                    7) {
                                                  return '${_difference.inDays} days ago';
                                                } else {
                                                  return '${DateFormat('MMMM dd').format(_unpinnedList[index].timestamp)}';
                                                }
                                              })(),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AnnounceView(
                                                            board:
                                                                _unpinnedList[
                                                                    index])),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      IconSlideAction(
                                        caption: 'Pin',
                                        color: Colors.grey,
                                        icon: Icons.pin_drop,
                                        onTap: () async {
                                          await Database('board')
                                              .updateDocument(
                                                  new Map<String,
                                                      dynamic>.from({
                                                    'pinned': true,
                                                  }),
                                                  _unpinnedList[index].boardId);
                                        },
                                      )
                                    ],
                                    secondaryActions: <Widget>[
                                      IconSlideAction(
                                        caption: 'Delete',
                                        color: Colors.red,
                                        icon: Icons.delete,
                                        onTap: () async {
                                          await Database('board')
                                              .removeDocument(
                                                  _pinnedList[index].boardId);
                                        },
                                      ),
                                    ],
                                  );
                                })
                            : Container(),
                      ],
                    );
                  },
                )
              : Container(),
        ),
      ),
    );
  }
}
