import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseLogin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);

  GoogleSignInAccount _currentGoogleAccount;
  FirebaseUser _currentFirebaseUser;
  bool _authenticationError;

  Function(String, String, String, String) onSuccess;
  Function(String) onError;

  FirebaseLogin({this.onSuccess, this.onError});

  void login() {
    _currentGoogleAccount = null;
    _currentFirebaseUser = null;
    _authenticationError = null;
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
    _currentGoogleAccount = account;
    _authenticationError = (account == null);

    if (account != null) {
      _auth.currentUser().then(
          (FirebaseUser user) => _checkCurrentFirebaseUser(user),
          onError: _doGoogleSignIn);
    } else {
      _notifyError(null);
    }
  }

  void _checkCurrentFirebaseUser(FirebaseUser user) {
    _currentFirebaseUser = user;

    if (user == null) {
      _doFirebaseSignIn();
    } else {
      _notifySuccess();
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
        _currentFirebaseUser = user;
        _authenticationError = (user == null);
        if (user != null) {
          _notifySuccess();
        } else {
          _notifyError(null);
        }
      } catch (error) {
        print(error);
        _notifyError(error);
      }
    }
  }

  void _doGoogleSignIn() async {
    try {
      var account = await _googleSignIn.signIn();
      _onGoogleSigned(account);
    } catch (error) {
      print(error);
      _notifyError(error);
    }
  }

  void _notifySuccess() {
    if (_currentGoogleAccount != null &&
        _currentFirebaseUser != null &&
        (!_authenticationError)) {
      if (this.onSuccess != null) {
        String uid = _currentFirebaseUser.uid;
        String name = _currentFirebaseUser.displayName;
        String email = _currentFirebaseUser.email;
        String avatar = _currentFirebaseUser.photoUrl;
        onSuccess(uid, name, email, avatar);
      } else {
        _notifyError(null);
      }
    }
  }

  void _notifyError(String error) {
    if (onError != null) {
      onError(error);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print("Error disconnecting from Firebase: " + error);
    }
    try {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
    } catch (error) {
      print("Error disconnecting from Google: " + error);
    }

    _currentFirebaseUser = null;
    _currentGoogleAccount = null;
    _authenticationError = false;
  }
}
