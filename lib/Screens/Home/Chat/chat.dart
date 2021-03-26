import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Models/club.dart';
import 'package:rowingapp/Models/userData.dart';
import 'package:rowingapp/Screens/Home/Chat/new_chat.dart';
import 'package:rowingapp/Services/database.dart';
import 'package:rowingapp/Services/main_Services.dart';
import 'package:rowingapp/Shared/colourScheme.dart';
import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rowingapp/Screens/Home/Chat/chatmessage.dart';
import 'package:getflutter/getflutter.dart';
import 'package:rowingapp/Shared/loading.dart';

void main() => runApp(new ChatMain());

class ChatMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Chats',
        home: new ChatHome());
  }
}

class ChatHome extends StatelessWidget {
  Future makeNewChat(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MakeNewChat()));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: activeColourScheme.navbarGeneral,
        title: new Text("Messaging"),
        // actions: <Widget>[
        //   IconButton(
        //       icon: Icon(Icons.add),
        //       onPressed: () {
        //         makeNewChat(context);
        //       }),
        // ],
      ),
      // container below will display all the chats the logged in user is a part of
      body: ChatScreen(),
      // body: Container(
      //     child: FutureBuilder(
      //         future: MainServices().chatsIn(user.uid),
      //         builder: (context, AsyncSnapshot snapshot) {
      //           if (!snapshot.hasData) {
      //             return Container();
      //           } else {
      //             return ListView.builder(
      //                 scrollDirection: Axis.vertical,
      //                 shrinkWrap: true,
      //                 itemCount: user.chats.length,
      //                 itemBuilder: (BuildContext context, index) {
      //                   return Card(
      //                     margin: EdgeInsets.fromLTRB(15, 0, 0, 15),
      //                     child: Column(
      //                       //mainAxisSize: MainAxisSize.max,
      //                       children: <Widget>[
      //                         Row(
      //                           children: <Widget>[
      //                             SizedBox(height: 50, width: 10),
      //                             Icon(Icons.person),
      //                             SizedBox(width: 10),
      //                             Text(snapshot.data[index]['Name']),
      //                           ],
      //                         ),
      //                       ],
      //                     ),
      //                   );
      //                 });
      //           }
      //         }))
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatControls = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];

  String name = '';
  String chatID = '';

  void _submitHandler(String text) {
    if (text == null) {
    } else if (text.trim() != '') {
      _chatControls.clear();
      var documentReference = Firestore.instance
          .collection('chats')
          .document(chatID)
          .collection(chatID)
          .document(DateTime.now().millisecondsSinceEpoch.toString());
      print(documentReference.documentID);
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(documentReference, {
          'idFrom': name,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': text,
        });
      });
    }
    // ChatMessage message =
    //     new ChatMessage(text: text, name: name); //put your firebase name here
    // setState(() {
    //   _messages.insert(0, message);
    // });
  }

  Widget _chatEnvironment() {
    return new IconTheme(
      data: new IconThemeData(color: activeColourScheme.buttonBackgrounds),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  decoration: new InputDecoration.collapsed(
                      hintText: "Start typing..."),
                  controller: _chatControls,
                  onSubmitted: _submitHandler,
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _submitHandler(_chatControls.text),
                ),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final club = Provider.of<Club>(context);

   name = user.firstName;
    chatID = club.chatID;
    return club == null
        ? Loading()
        : new Column(
            children: <Widget>[
              new Flexible(
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('chats')
                        .document(club.chatID)
                        .collection(club.chatID)
                        .orderBy('timestamp', descending: true)
                        .limit(20)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        return ListView.builder(
                          // padding: new EdgeInsets.all(8.0),
                          // reverse: true,
                          // itemBuilder: (_, int index) => _messages[index],
                          // itemCount: _messages.length,

                          padding: EdgeInsets.all(10.0),
                          itemBuilder: (context, index) =>
                              ChatMessage(doc: snapshot.data.documents[index]),
                          itemCount: snapshot.data.documents.length,
                          reverse: true,
                        );
                      }
                    }),
              ),
              new Divider(
                height: 1.0,
              ),
              new Container(
                decoration: new BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: _chatEnvironment(),
              )
            ],
          );
  }
}
