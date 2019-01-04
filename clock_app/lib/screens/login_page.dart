import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignInAccount _currentGoogleAccount;
  FirebaseUser _currentFirebaseUser;
  String _contactText;
  bool _authenticationError = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);

  @override
  void initState() {
    super.initState();
    _doGoogleSignIn();
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
          _authenticationError = false;
        });
        _onLoginSucess();
      } catch (error) {
        print(error);
        _showError();
      }
    }
  }

  void _doGoogleSignIn() async {
    try {
      var account = await _googleSignIn.signIn();
      setState(() {
        _currentGoogleAccount = account;
        _authenticationError = false;
      });
      _doFirebaseSignIn();
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
    setState(() {
      _contactText = _currentFirebaseUser.displayName;
      _authenticationError = false;
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

  Widget _buildBody() {
    if ((_currentGoogleAccount != null) && (_currentFirebaseUser != null)) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: _currentGoogleAccount,
            ),
            title: Text(_currentGoogleAccount.displayName),
            subtitle: Text(_currentGoogleAccount.email),
          ),
          const Text("Signed in successfully."),
          Text((_contactText != null) ? _contactText : ""),
          RaisedButton(
              child: const Text('SIGN OUT'), onPressed: _handleSignOut),
        ],
      );
    } else if (_authenticationError) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Text("There was an authentication error!!"),
            RaisedButton(
                child: const Text('SIGN IN'), onPressed: _doGoogleSignIn),
          ]);
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          CircularProgressIndicator()
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: _buildBody(),
    );
  }
}
