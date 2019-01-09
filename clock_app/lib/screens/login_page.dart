import 'package:clock_app/clock_localizations.dart';
import 'package:clock_app/domain/firebase/database.dart';
import 'package:clock_app/domain/firebase/firebase_login.dart';
import 'package:clock_app/screens/calendar_page.dart';
import 'package:clock_app/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:random_string/random_string.dart' as random;

/// LoginPage shows a screen so the user can login, log out and show a QR code to
/// be read by a Clock In reader and do a check in or check out.
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

/// The LoginPageState related to the LoginPage
class _LoginPageState extends State<LoginPage> {
  // flag to set if there has been an authentication error
  bool _authenticationError = false;
  int _latestReadTimestamp;
  String _latestReadChecker;

  // The qr token
  String _qrToken = "";

  // The logged user data to show on screen: user name, email, uid (for the QR), avatar url
  String _userName, _email, _uid, _avatar;

  // instance to firebase login
  FirebaseLogin _login;
  Database _db;

  @override
  void initState() {
    super.initState();
    _db = Database();
    _login = FirebaseLogin(onSuccess: _onLoginSuccess, onError: _showError);
    _login.login();
  }

  Widget _buildBody(BuildContext context) {
    if (_userName != null && _email != null && _uid != null) {
      String latestReadText = "";
      if ((_latestReadTimestamp != null) && (_latestReadChecker != null)) {
        latestReadText = "Last read: " +
            DateUtils.getShortTimeFormatFromTimestamp(_latestReadTimestamp) +
            " by " +
            _latestReadChecker;
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            title: Text(_userName),
            subtitle: Text(_email),
            leading: (_avatar != null)
                ? CircleAvatar(
                    backgroundImage: NetworkImage(_avatar),
                  )
                : Icon(Icons.person),
            contentPadding: EdgeInsets.only(left: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new QrImage(
                data: _buildQrData(),
                size: 250.0,
              ),
              RaisedButton(
                  child: Text(ClockAppLocalizations.of(context).refresh),
                  onPressed: _refreshQr)
            ],
          ),
          Text(latestReadText),
          RaisedButton(
              child: Text(ClockAppLocalizations.of(context).reports),
              onPressed: _handleReports),
          RaisedButton(
              child: Text(ClockAppLocalizations.of(context).signOut),
              onPressed: _doLogin),
        ],
      );
    } else if (_authenticationError) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(ClockAppLocalizations.of(context).authenticationError),
            RaisedButton(
                child: Text(ClockAppLocalizations.of(context).signIn),
                onPressed: _doLogin),
          ]);
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(ClockAppLocalizations.of(context).authenticatingUser),
          CircularProgressIndicator()
        ],
      );
    }
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

  /// Build the QR data
  String _buildQrData() {
    String result = "";
    if (_uid != null) {
      String uid = _uid;
      result = uid + "#" + _qrToken;
    }
    return result;
  }

  /// Refresh the QR token
  void _refreshQr() {
    setState(() {
      _qrToken = _getNewQrToken();
    });
    _listenOnCheckin();
    print("Refresh user " +
        _uid +
        " (" +
        _email +
        ") with new token " +
        _qrToken);
  }

  /// Called after a login has been successful
  void _onLoginSuccess(String uid, String name, String email, String avatar) {
    setState(() {
      _uid = uid;
      _userName = name;
      _email = email;
      _avatar = avatar;
      _authenticationError = false;
      _qrToken = _getNewQrToken();
    });
    _listenOnCheckin();
    print("Login success for user " +
        uid +
        "(" +
        email +
        ") and token " +
        _qrToken);
  }

  /// Set the state with authentication error to true, so an error message is shown
  void _showError(String error) async {
    print("Error");
    setState(() {
      _authenticationError = true;
      _uid = null;
      _userName = null;
      _email = null;
    });
  }

  /// Do a clean login, trying first a sign out
  void _doLogin() async {
    setState(() {
      _authenticationError = false;
      _uid = null;
      _userName = null;
      _email = null;
    });
    await _login.signOut();
    _login.login();
  }

  /// Invoked when the user clicks on the reports button
  /// Navigates to the report pages
  Future<void> _handleReports() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CalendarPage()));
  }

  void _listenOnCheckin() {
    _db.readCheckin(
        uid: _uid,
        token: _qrToken,
        onTimestampRead: _onTimestampRead,
        onTimestampReadError: _onTimestampReadError);
  }

  void _onTimestampRead(int timestamp, String checkerUid, String checkerName) {
    print("_onTimestamp read: " + timestamp.toString());
    setState(() {
      _latestReadChecker = checkerName;
      _latestReadTimestamp = timestamp;
    });
    _refreshQr();
  }

  void _onTimestampReadError() {
    print("_onTimestamp read ERROR");
    setState(() {
      _latestReadChecker = null;
      _latestReadTimestamp = null;
    });
  }
}
