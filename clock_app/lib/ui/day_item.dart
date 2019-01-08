import 'package:clock_app/clock_localizations.dart';
import 'package:flutter/material.dart';

class DayItem extends StatefulWidget {
  final String _dayOfMonth;
  final String _month;
  final String _dayOfWeek;
  final String _duration;
  final String _inTime;
  final String _outTime;

  DayItem(this._dayOfMonth, this._month, this._dayOfWeek, this._duration,
      this._inTime, this._outTime);

  @override
  State<StatefulWidget> createState() {
    return DayItemState(this._dayOfMonth, this._month, this._dayOfWeek,
        this._duration, this._inTime, this._outTime);
  }
}

class DayItemState extends State<DayItem> {
  final _xlFont = const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  final _bigFont =
      const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  final _smallFont =
      const TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal);
  final _mediumFont =
      const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal);

  final String _dayOfMonth;
  final String _month;
  final String _dayOfWeek;
  final String _duration;
  final String _inTime;
  final String _outTime;

  DayItemState(this._dayOfMonth, this._month, this._dayOfWeek, this._duration,
      this._inTime, this._outTime);

  bool _tapped = false;
  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: _onDown,
        onPointerUp: _onUp,
        onPointerCancel: _onCancel,
        child: Container(
            padding: const EdgeInsets.only(
                left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
            decoration: BoxDecoration(
                color: (_tapped) ? Colors.black12 : Colors.transparent),
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(_dayOfMonth, style: _xlFont),
                    Text(_month, style: _smallFont)
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(_dayOfWeek, style: _mediumFont)),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Column(children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.green,
                                size: 16.0,
                              ),
                              Text(_inTime,
                                  style: _bigFont, textAlign: TextAlign.center)
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.keyboard_arrow_left,
                                  color: Colors.red, size: 16.0),
                              Text(_outTime,
                                  style: _bigFont, textAlign: TextAlign.center)
                            ],
                          )
                        ]))),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Column(
                          children: <Widget>[
                            Text(ClockAppLocalizations.of(context).workingTime,
                                style: _mediumFont, textAlign: TextAlign.right),
                            Text(_duration,
                                style: _bigFont, textAlign: TextAlign.right)
                          ],
                        )))
              ],
            )));
  }

  void _onUp(PointerUpEvent events) {
    setState(() {
      _tapped = false;
    });
  }

  void _onDown(PointerDownEvent event) {
    setState(() {
      _tapped = true;
    });
  }

  void _onCancel(PointerCancelEvent event) {
    setState(() {
      _tapped = false;
    });
  }
}
