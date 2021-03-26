import 'package:flutter/material.dart';
import 'package:rowingapp/Services/Auth_Services.dart';
import 'package:rowingapp/Shared/text_form_dec.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //Text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 5.0,
        title: Center(child: Text('Sign Up')),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
              key: _formKey,
              //SingleChildScrollView means no overflow when using keyboard
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 100.0),

                    //Email form field
                    TextFormField(
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      // uses the final decoration defined in text_for_dec.dart
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Email', prefixIcon: Icon(Icons.email)),
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),

                    SizedBox(height: 20.0),

                    //Password form field
                    TextFormField(
                      validator: (val) => val.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      // uses the final decoration defined in text_for_dec.dart
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Password', prefixIcon: Icon(Icons.lock)),
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),

                    SizedBox(height: 5.0),

                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),

                    SizedBox(height: 5.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.blue[800],
                          child: Text("Register"),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _authService
                                  .registerWithEmailAndPassword(
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
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RaisedButton.icon(
                            color: Colors.blue[800],
                            onPressed: () {
                              widget.toggleView();
                            },
                            icon: Icon(Icons.person),
                            label: Text("Login")),
                      ],
                    )
                  ],
                ),
              ))),
    );
  }
}
