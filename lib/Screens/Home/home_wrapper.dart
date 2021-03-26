import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rowingapp/Models/boatGroup.dart';
import 'package:rowingapp/Models/club.dart';
import 'package:rowingapp/Models/userData.dart';
import 'package:rowingapp/Screens/Program_Selector/program_selector.dart';
import 'package:rowingapp/Screens/Program_Selector/update_user.dart';
import 'package:rowingapp/Services/main_Services.dart';
import 'package:rowingapp/Shared/loading.dart';
import '../wrapper.dart';
import 'home.dart';

class HomeToggle extends StatefulWidget {
  @override
  _HomeToggleState createState() => _HomeToggleState();
}

class _HomeToggleState extends State<HomeToggle> {
  bool showHome = true;

  void toggleViewHome() {
    setState(() => showHome = !showHome);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final clubID = Provider.of<ClubIDModel>(context);

    if (user == null || clubID == "") {
      return Loading();
    }

    if (user.firstName == null) {
      return UpdateUserScreen();
    } else if (showHome) {
      return Container(
        child: ProgramSelector(toggleViewHome: toggleViewHome),
      );
    } else {
      return Container(
        child: MultiProvider(providers: [
          StreamProvider<Club>.value(
              value: MainServices()
                  .clubStream(Provider.of<ClubIDModel>(context).getClubID())),
          //StreamProvider<BoatGroup>.value(value: MainServices().boatGroupStream( Provider.of<ClubIDModel>(context).getClubID())),
        ], child: Home(toggleViewHome: toggleViewHome)),
      );
    }
  }
}
