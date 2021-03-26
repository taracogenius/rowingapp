import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Screens/Home/Chat/chat.dart';
import 'package:getflutter/getflutter.dart';
import 'package:rowingapp/Models/userData.dart';
import 'package:rowingapp/Shared/colourScheme.dart';

class ChatMessage extends StatelessWidget {
  final doc;

  ChatMessage({
    this.doc,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    if (user.firstName == doc['idFrom']) {
      return new Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: activeColourScheme.navbarGeneral, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Text(doc['idFrom'],
                        style: Theme.of(context).textTheme.subtitle1),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(doc['content']),
                    )
                  ],
                )),
            new Container(
              margin: const EdgeInsets.only(left: 16.0),
              //pass the firebase images here
              child: new GFAvatar(
                backgroundImage: NetworkImage(
                    'https://i.kym-cdn.com/photos/images/facebook/001/710/493/f9b.png'),
              ),
            ),
          ],
        ),
      );
    } else {
      return new Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              //pass the firebase images here
              child: new GFAvatar(
                backgroundColor: activeColourScheme.headerColor,
                backgroundImage: NetworkImage(
                    'https://i.kym-cdn.com/photos/images/facebook/001/710/493/f9b.png'),
              ),
            ),
            Container(padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(doc['idFrom'],
                      style: Theme.of(context).textTheme.subtitle1),
                  new Container(
                    
                    ),
                   new Text(doc['content']),
                  
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
