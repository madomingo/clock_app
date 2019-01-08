import 'package:clock_app/clock_localizations.dart';
import 'package:clock_app/screens/calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:random_string/random_string.dart' as random;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignInAccount _currentGoogleAccount;
  FirebaseUser _currentFirebaseUser;
  bool _authenticationError = false;
  String _qrToken = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);

  @override
  void initState() {
    super.initState();
    _googleSignIn.isSignedIn().then(
        (bool signed) => _checkCurrentGoogleUser(signed),
        onError: _doGoogleSignIn);
  }

  void _checkCurrentGoogleUser(bool signed) {
    if (signed) {
      _googleSignIn
          .signInSilently()
          .then((GoogleSignInAccount account) => _onGoogleSigned(account));
    } else {
      _doGoogleSignIn();
    }
  }

  void _onGoogleSigned(GoogleSignInAccount account) {
    setState(() {
      _currentGoogleAccount = account;
      _authenticationError = (account == null);
    });
    if (account != null) {
      _auth.currentUser().then(
          (FirebaseUser user) => _checkCurrentFirebaseUser(user),
          onError: _doGoogleSignIn);
    }
  }

  void _checkCurrentFirebaseUser(FirebaseUser user) {
    setState(() {
      _currentFirebaseUser = user;
    });

    if (user == null) {
      _doFirebaseSignIn();
    } else {
      _onLoginSucess();
    }
  }

  void _doFirebaseSignIn() async {
    if (_currentGoogleAccount != null) {
      try {
        GoogleSignInAuthentication authentication =
            await _currentGoogleAccount.authentication;
        var user = await _auth.signInWithGoogle(
            idToken: authentication.idToken,
            accessToken: authentication.accessToken);
        setState(() {
          _currentFirebaseUser = user;
          _authenticationError = (user == null);
        });
        if (user != null) {
          _onLoginSucess();
        }
      } catch (error) {
        print(error);
        _showError();
      }
    }
  }

  void _doGoogleSignIn() async {
    try {
      var account = await _googleSignIn.signIn();
      _onGoogleSigned(account);
    } catch (error) {
      print(error);
      _showError();
    }
  }

  void _showError() async {
    print("Error");
    setState(() {
      _authenticationError = true;
    });
  }

  void _onLoginSucess() {
    print("Firebase User");
    print(_currentFirebaseUser);
    if (_currentFirebaseUser != null) {
      setState(() {
        _authenticationError = false;
        _qrToken = _getNewQrToken();
      });
    }
    setState(() {
      _authenticationError = (_currentFirebaseUser == null);
    });
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
    setState(() {
      _currentFirebaseUser = null;
      _currentGoogleAccount = null;
      _authenticationError = false;
    });
    _doGoogleSignIn();
  }

  Widget _buildBody(BuildContext context) {
    if (_currentFirebaseUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            title: Text(_currentFirebaseUser.displayName),
            subtitle: Text(_currentFirebaseUser.email),
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
                onPressed: _doGoogleSignIn),
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
    if (_currentFirebaseUser != null) {
      String uid = _currentFirebaseUser.uid;
      result = uid + "#" + _qrToken;
    }
    return result;
  }

  void _refreshQr() {
    setState(() {
      _qrToken = _getNewQrToken();
    });
  }
}
