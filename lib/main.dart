import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Models/User.dart';
import 'Models/userData.dart';
import 'Screens/wrapper.dart';
import 'Services/Auth_Services.dart';
import 'Services/main_Services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(
          home: Wrapper(),
        ));
  }
}
