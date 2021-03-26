import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passFilter = new TextEditingController();
  final TextEditingController _tokenFilter = new TextEditingController();

  String emailText = "";
  String passwordText = "";
  String tokenText = "";

  _LoginState() {
    _emailFilter.addListener(_emailListener);
    _passFilter.addListener(_passwordListener);
    _tokenFilter.addListener(_tokenListener);
  }

  void _emailListener() {
    //format email
    if (_emailFilter.text.isEmpty) {
      emailText = ""; //empty
    } else if (!_emailFilter.text.contains('@')) {
      emailText = ""; //not valid no @ symbol
    } else {
      emailText = _emailFilter.text;
    }
  }

  void _passwordListener() {
    //format password
    if (_passFilter.text.isEmpty) {
      passwordText = "";
    } else {
      passwordText = _passFilter.text;
    }
  }

  void _tokenListener() {
    //format token
    if (_tokenFilter.text.isEmpty) {
      tokenText = "";
    } else {
      tokenText = _tokenFilter.text;
    }
  }

  Widget _buildFields() {
    return new Container(
      // email
      child: new ListView(children: <Widget>[
        new Container(
          child: new TextField(
            controller: _emailFilter,
            decoration: new InputDecoration(labelText: 'Email'),
          ),
        ),
        new Container(
          child: new TextField(
            // passwords
            controller: _passFilter,
            decoration: new InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
        ),
      ]),
    );
  }

  Widget _buttonBuilder() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new RaisedButton(child: new Text('Login'), onPressed: _loginRequested)
        ],
      ),
    );
  }

  void _loginRequested() {}

  @override
  Widget build(BuildContext context) {
    // build the entire thing
    return new Scaffold(
      body: new Container(
          padding: EdgeInsets.all(15.9),
          child: new Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Text('[Login Placeholder]'),
              ),
              Expanded(
                flex: 2,
                child: _buildFields(),
              )
            ],
          )),
    );
  }
}
