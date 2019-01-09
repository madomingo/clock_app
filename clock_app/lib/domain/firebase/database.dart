import 'dart:async';

import 'package:clock_app/utils/date_utils.dart';
import 'package:firebase_database/firebase_database.dart';

class Database {
  static const String CHECKINS_NODE = "checkins";
  static const String WORKERS_NODE = "workers";

  FirebaseDatabase _db = FirebaseDatabase.instance;
  String _currentUid;
  String _currentToken;
  StreamSubscription<Event> _currentListener;

  void readCheckin(
      {String uid,
      String token,
      Function(int, String, String) onTimestampRead,
      Function onTimestampReadError}) {
    if (uid != null && token != null) {
      _currentToken = token;
      if (_currentUid == null || _currentUid != uid) {
        _currentUid = uid;
        if (_currentListener != null) {
          _currentListener.cancel();
        }
        print("Listening on: " +
            _currentUid +
            " , expected token = " +
            _currentToken);
        _currentListener = _db
            .reference()
            .child(CHECKINS_NODE)
            .child(uid)
            .onChildAdded
            .listen((Event event) {
          DataSnapshot snapshot = event.snapshot;
          print("Listen to database and read");
          print(snapshot.value);
          var value = snapshot.value;
          if (value != null) {
            String writtenToken = value["token"];
            int timestamp = value["timestamp"];
            String name = value["checker_name"];
            String checkerUid = value["checker_uid"];
            if (writtenToken != null && _currentToken == writtenToken) {
              _writeCheckinForUser(
                      userUid: uid,
                      timestamp: timestamp,
                      checkerName: name,
                      checkerUid: checkerUid)
                  .then((bool success) {
                if (onTimestampRead != null) {
                  onTimestampRead(timestamp, checkerUid, name);
                  _deleteNode(uid: uid, key: snapshot.key);
                }
              }, onError: () {
                if (onTimestampReadError != null) {
                  onTimestampReadError();
                }
              });
            } else {
              //ignore the read, print it to console
              print("Ignored read: Expected token = " +
                  token +
                  " but found " +
                  ((writtenToken != null) ? writtenToken : "null"));
              _deleteNode(uid: uid, key: snapshot.key);
            }
          }
        }, onError: (Object error) {
          print("Firebase database error");
          print(error);
        });
      }
    }
  }

  void _deleteNode({String uid, String key}) async {
    if (uid != null && key != null && key.length > 0 && uid.length > 0) {
      DatabaseReference ref =
          _db.reference().child(CHECKINS_NODE).child(uid).child(key + "/");
      print("Removing " + ref.path);
      ref.remove();
    }
  }

  Future<bool> _writeCheckinForUser(
      {String userUid,
      int timestamp,
      String checkerName,
      String checkerUid}) async {
    DateTime date = DateUtils.getFromTimestamp(timestamp);
    DateTime monthDate = DateTime(date.year, date.month, 1);
    String monthDateStr = DateUtils.getFullDateString(monthDate);
    String dayDateStr = DateUtils.getFullDateString(date);

    _db
        .reference()
        .child(WORKERS_NODE)
        .child(userUid)
        .child(monthDateStr)
        .child(dayDateStr)
        .child(CHECKINS_NODE)
        .push()
        .set(<String, dynamic>{
      "checker_uid": checkerUid,
      "cheker_name": checkerName,
      "timestamp": timestamp
    }).then((dynamic value) {
      return true;
    }, onError: (Object error) {
      return false;
    });
  }

  void close() {
    if (_currentListener != null) {
      _currentListener.cancel();
    }
    _currentUid = null;
    _currentToken = null;
  }
}
