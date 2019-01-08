import 'package:clock_app/clock_localizations.dart';
import 'package:clock_app/domain/firebase/login.dart';
import 'package:clock_app/screens/calendar_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:random_string/random_string.dart' as random;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _authenticationError = false;
  String _qrToken = "";
  String _userName, _email, _uid;
  Login login;


  @override
  void initState() {
    super.initState();
    login = Login(onSuccess: _onLoginSuccess, onError: _showError);
    login.login();
  }



  Future<void> _handleSignOut() async {
    await login.signOut();
    _doLogin();
  }

  Widget _buildBody(BuildContext context) {
    if (_userName != null && _email != null && _uid != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            title: Text(_userName),
            subtitle: Text(_email),
            contentPadding: EdgeInsets.only(left: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new QrImage(
                data: _buildQrData(),
                size: 300.0,
              ),
              RaisedButton(
                  child: Text(ClockAppLocalizations.of(context).refresh),
                  onPressed: _refreshQr)
            ],
          ),
          RaisedButton(
              child: Text(ClockAppLocalizations.of(context).sign_out),
              onPressed: _handleSignOut),
          RaisedButton(
              child: Text(ClockAppLocalizations.of(context).reports),
              onPressed: _handleReports),
        ],
      );
    } else if (_authenticationError) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(ClockAppLocalizations.of(context).authentication_error),
            RaisedButton(
                child: Text(ClockAppLocalizations.of(context).sign_in),
                onPressed: _doLogin),
          ]);
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(ClockAppLocalizations.of(context).authenticating_user),
          CircularProgressIndicator()
        ],
      );
    }
  }

  Future<void> _handleReports() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CalendarPage()));
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: _buildBody(context),
    );
  }

  String _getNewQrToken() {
    return random.randomAlphaNumeric(12);
  }

  String _buildQrData() {
    String result = "";
    if (_uid != null) {
      String uid = _uid;
      result = uid + "#" + _qrToken;
    }
    return result;
  }

  void _refreshQr() {
    setState(() {
      _qrToken = _getNewQrToken();
    });
  }

  void _onLoginSuccess(String uid, String name, String email) {
    setState(() {
      _uid = uid;
      _userName = name;
      _email = email;
      _authenticationError = false;
    });

  }

  void _showError(String error) async {
    print("Error");
    setState(() {
      _authenticationError = true;
      _uid = null;
      _userName = null;
      _email = null;
    });
  }

  _doLogin() {
    setState(() {
      _authenticationError = false;
      _uid = null;
      _userName = null;
      _email = null;
    });
    login.login();

  }
}
