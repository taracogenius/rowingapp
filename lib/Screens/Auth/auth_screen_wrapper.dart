import 'package:flutter/material.dart';
import 'package:rowingapp/Screens/Auth/sign_up.dart';
import 'package:rowingapp/Screens/Auth/sing_in.dart';

class AuthScreens extends StatefulWidget {
  @override
  _AuthScreensState createState() => _AuthScreensState();
}

class _AuthScreensState extends State<AuthScreens> {
  bool showLogin = true;

  void toggleView() {
    setState(() => showLogin = !showLogin);
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return Container(
        child: SignIn(toggleView: toggleView),
      );
    } else
      return Container(
        child: SignUp(toggleView: toggleView),
      );
  }
}
