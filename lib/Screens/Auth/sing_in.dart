import 'package:flutter/material.dart';
import 'package:rowingapp/Services/Auth_Services.dart';
import 'package:rowingapp/Shared/loading.dart';
import 'package:rowingapp/Shared/text_form_dec.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //Text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: const Color(0xffD8D8D8),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 290,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/logonew.png'),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 15.0),
                    alignment: Alignment.center,
                    child: Column(children: <Widget>[
                      Text(
                        "Welcome Back",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 30,
                              color: const Color(0xff1c1c41),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
                  ),
                  new Divider(
                    thickness: 5.0,
                    indent: 85.0,
                    endIndent: 85.0,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 30.0),
                      child: Form(
                          key: _formKey,
                          //SingleChildScrollView means no overflow when using keyboard
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 40.0),
                                //Email form field
                                TextFormField(
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter an email' : null,
                                  // uses the final decoration defined in text_for_dec.dart
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Email',
                                      prefixIcon: Icon(Icons.email)),
                                  onChanged: (val) {
                                    setState(() => email = val);
                                  },
                                ),
                                SizedBox(height: 20.0),
                                //Password form field
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.black,
                                    decorationColor: Colors.black45,
                                  ),
                                  validator: (val) => val.length < 6
                                      ? 'Enter a password 6+ chars long'
                                      : null,
                                  // uses the final decoration defined in text_for_dec.dart
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Password',
                                      prefixIcon: Icon(Icons.lock)),
                                  obscureText: true,
                                  onChanged: (val) {
                                    setState(() => password = val);
                                  },
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  error,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14.0),
                                ),
                                SizedBox(height: 30.0),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    GFButton(
                                      color: const Color(0xff1c1c41),
                                      shape: GFButtonShape.pills,
                                      size: GFSize.LARGE,
                                      fullWidthButton: true,
                                      child: Text("Sign In"),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          setState(() => loading = true);
                                          dynamic result = await _authService
                                              .signInWithEmailAndPassword(
                                                  email, password);
                                          if (result == null) {
                                            setState(() {
                                              error =
                                                  'please supply a valid email and password';
                                              loading = false;
                                            });
                                          }
                                        }
                                      },
                                    ),
                                    SizedBox(width: 5.0),
                                    GFButton(
                                      color: const Color(0xff1c1c41),
                                      shape: GFButtonShape.pills,
                                      size: GFSize.LARGE,
                                      fullWidthButton: true,
                                      child: Text("Register"),
                                      onPressed: () {
                                        widget.toggleView();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ))),
                ],
              ),
            ));
  }
}
