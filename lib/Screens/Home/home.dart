import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Models/User.dart';
import 'package:rowingapp/Models/club.dart';
import 'package:rowingapp/Models/userData.dart';
import 'package:rowingapp/Screens/CrewCreation/crews.dart';
import 'package:rowingapp/Screens/Home/welcome.dart';
import 'package:rowingapp/Shared/colourScheme.dart';
import 'package:rowingapp/Shared/settings.dart';
import '../wrapper.dart';
import 'Chat/chat.dart';
import 'noticeBoard/notices.dart';
import 'onWater.dart';
import 'trainings/trainings.dart';

class Home extends StatefulWidget {
  final Function toggleViewHome;

  Home({this.toggleViewHome});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final club = Provider.of<Club>(context);
    final user = Provider.of<UserData>(context);
    final admin = Provider.of<AdminModel>(context);

    if (club != null) {
      for (var users in club.admins) {
        admin.setAdmin(false);
        if (users == user.uid) {
          admin.setAdmin(true);
          break;
        }
      }
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: activeColourScheme.greyedText,
        selectedItemColor: activeColourScheme.headerColor,
        unselectedItemColor: activeColourScheme.navbarGeneral,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (newIndex) => setState(() {
          _currentIndex = newIndex;
        }),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_note), title: Text("Trainings")),
          BottomNavigationBarItem(
              icon: Icon(Icons.rowing), title: Text("On Water")),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), title: Text("Chat")),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline),
            title: Text("Notices"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Settings"),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          Welcome(),
          Training(),
          OnWater(),
          ChatHome(),
          Notices(),
          Settings(toggleViewHome: widget.toggleViewHome),
        ],
      ),
    );
  }
}
