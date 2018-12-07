import 'package:flutter/material.dart';

class DayItem extends StatelessWidget {

  final _biggerFont = const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  final _smallFont = const TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal);
  final _mediumFont = const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal);
  final String _dayOfMonth;
  final String _month;
  final String _dayOfWeek;
  final String _duration;


  DayItem(this._dayOfMonth, this._month, this._dayOfWeek, this._duration);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: <Widget>[
          Column(children: <Widget>[
            Text(_dayOfMonth, style: _biggerFont),
            Text(_month, style: _smallFont)
          ],),
          Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(_dayOfWeek, style: _mediumFont)),
          Expanded(
              child: Text(_duration, style: _biggerFont,textAlign: TextAlign.right))
        ],
      )

    );
  }




}
