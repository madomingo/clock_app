import 'package:clock_app/clock_localizations.dart';
import 'package:flutter/material.dart';

class NoWorkingDayItem extends StatefulWidget {
  final String _dayOfMonth;
  final String _month;
  final String _dayOfWeek;

  NoWorkingDayItem(this._dayOfMonth, this._month, this._dayOfWeek);

  @override
  State<StatefulWidget> createState() {
    return NoWorkingDayItemState(
        this._dayOfMonth, this._month, this._dayOfWeek);
  }
}

class NoWorkingDayItemState extends State<NoWorkingDayItem> {
  final _xlFont = const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black54);
  final _smallFont =
      const TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal, color: Colors.black54);
  final _mediumFont =
      const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.black54);

  final String _dayOfMonth;
  final String _month;
  final String _dayOfWeek;

  NoWorkingDayItemState(this._dayOfMonth, this._month, this._dayOfWeek);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
            left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
        decoration: BoxDecoration(color: Colors.transparent),
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
                    child: Text(ClockAppLocalizations.of(context).no_records,
                        style: _mediumFont, textAlign: TextAlign.center)))
          ],
        ));
  }
}
