import 'package:flutter/material.dart';
import 'package:rowingapp/Shared/colourScheme.dart';

class HelpSection {
  String title;
  String content;

  HelpSection(String title, String content) {
    this.title = title;
    this.content = content;
  }

  Container displaySection() {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 3, right: 3),
                child: Text(
                  this.title,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 20.0,
                  ),
                )),
            Text(
              this.content,
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontSize: 16.0,
              ),
            )
          ],
        ));
  }
}

List<HelpSection> helpSections = <HelpSection>[
  HelpSection("Home",
      """The home screen has been designed to show the users most recent activity regarding their rowing, and the most recent announcements. Here, you can see the most recent tile of the noticeboard, and also what boat and section you're going to be in. To see information about the most recent notice, press the noticeboard for more information."""),
  HelpSection("Training",
      """The training schedule will show the user information regarding the current events in the club. Users can select whether they see the schedule by month, 2 weeks, or a week. If the user selects the event they are interested in, then it will give you the option to attend, or not attend, and submit your attendance. Here, you will see information regarding the specific event, such as location, time, instructor notes and the workout menu."""),
  HelpSection("On Water",
      """The on water screen allows for users to take laps depending on when they are on the water. To start a lap, the user can press 'start' and then break the lap using the 'lap' button. The user can stop the lap at anytime using the 'Stop' button, and reset the laps using 'Reset'."""),
  HelpSection("Chat",
      """The chat section has been implemented to work between different club members, here you can see  the clubs dedicated chat channel which can be used to share extra details about annoucements or other required information. To send a text, start typing and send the chat with the paper plane."""),
  HelpSection("Notices",
      """The different notices section is used to display information regarding the club and the most recent updates, to see new updates about the club, the user can press the notification to be taken to an extended screen. Here, the user can see the extended comments and dates regarding the specific annoucements."""),
  HelpSection("Settings",
      """Here the user can select their colour scheme, program selection to move back to the main screen, update their information, and also log out."""),
];

List<Container> displayHelpSections() {
  return helpSections.map((s) => s.displaySection()).toList();
}

class HelpWelcome extends StatefulWidget {
  @override
  _HelpWelcomeState createState() => _HelpWelcomeState();
}

class _HelpWelcomeState extends State<HelpWelcome> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: activeColourScheme.navbarGeneral,
          title: new Text("Help"),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 3, right: 3),
            width: 380,
            child: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  new Text(
                    """
The help section has been designed to help towards users understanding the different sections
of the application. This will guide the user through general information about each section.
""",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Column(
                    children: displayHelpSections(),
                  )
                ],
              ),
            )));
  }
}
