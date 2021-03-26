import 'package:flutter/material.dart';

enum RegisterStatus {
  EmailInvalid,
  EmailEmpty,
  PassInvalid,
  PassEmpty,
  TokenInvalid,
  TokenEmpty,
  LoginFine,
}

String _registerErrorToString(RegisterStatus registerError) {
  if (registerError == null) {
    return "";
  }

  switch (registerError) {
    case RegisterStatus.EmailInvalid:
      {
        return 'Email is invalid';
      }

    case RegisterStatus.PassInvalid:
      {
        return 'Password Invalid. The password must be atleast 10 characters long, and include a number and a letter';
      }

    case RegisterStatus.TokenInvalid:
      {
        return 'Invalid token. Please contact your Rowing Club or check for spelling errors';
      }

    case RegisterStatus.EmailEmpty:
      {
        return 'Email cannot be empty';
      }

    case RegisterStatus.PassEmpty:
      {
        return 'Password cannot be empty';
      }

    case RegisterStatus.TokenEmpty:
      {
        return 'Token cannot be empty';
      }
    default:
      {
        throw Exception(
            "Unexpected register error: " + registerError.toString());
      }
  }
}

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailFilterReg = new TextEditingController();
  final TextEditingController _passFilterReg = new TextEditingController();
  final TextEditingController _tokenFilterReg = new TextEditingController();

  String emailTextReg = "";
  String passwordTextReg = "";
  String tokenTextReg = "";
  RegisterStatus currentError;

  _RegisterState() {
    _emailFilterReg.addListener(_emailListenerReg);
    _passFilterReg.addListener(_passwordListenerReg);
    _tokenFilterReg.addListener(_tokenListenerReg);
  }

  void _emailListenerReg() {
    //format email
    if (_emailFilterReg.text.isEmpty) {
      // empty check
      emailTextReg = "";
      currentError = RegisterStatus.EmailEmpty;
    } else if (!_emailFilterReg.text.contains('@')) {
      emailTextReg = ""; //not valid no @ symbol
      currentError = RegisterStatus.EmailInvalid;
    } else {
      emailTextReg = _emailFilterReg.text;
    }
  }

  void _passwordListenerReg() {
    //format password
    if (_passFilterReg.text.isEmpty) {
      passwordTextReg = "";
      currentError = RegisterStatus.PassEmpty;
    } else {
      passwordTextReg = _passFilterReg.text;
    }
  }

  void _tokenListenerReg() // format token
  {
    if (_tokenFilterReg.text.isEmpty) {
      tokenTextReg = "";
      currentError = RegisterStatus.TokenEmpty;
    } else {
      tokenTextReg = _tokenFilterReg.text;
    }
  }

  Widget _buildFields() {
    return new Container(
      // email
      child: new ListView(children: <Widget>[
        new Container(
          child: new TextField(
            controller: _emailFilterReg,
            decoration: new InputDecoration(labelText: 'Email'),
          ),
        ),
        new Container(
          child: new TextField(
            // pass
            controller: _passFilterReg,
            decoration: new InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
        ),
        new Container(
          child: new TextField(
            // token
            controller: _tokenFilterReg,
            decoration: new InputDecoration(labelText: 'Program Token'),
          ),
        ),
      ]),
    );
  }

  Widget _buttonBuilder() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new RaisedButton(
              child: new Text('Register as Athlete'), onPressed: _onRegister)
        ],
      ),
    );
  }

  Widget _errorBuilder() {
    // builds the errors for the register requirements
    return new Container(
      child: new Column(
        children: <Widget>[
          new Text(_registerErrorToString(currentError)),
        ],
      ),
    );
  }

  void _onRegister() {
    // debugging
    if (currentError == null) {
      print("An error has occurred: " + _registerErrorToString(currentError));
      return;
    }
  }

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
                child: Text('[Register Logo Placeholder]'),
              ),
              Expanded(flex: 4, child: _buildFields()),
              Expanded(flex: 2, child: _errorBuilder()),
              Expanded(flex: 3, child: _buttonBuilder())
            ],
          )),
    );
  }
}
