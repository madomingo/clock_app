import 'package:clock_app/clock_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/date_utils.dart';

class MonthItem extends StatefulWidget {
  final DateTime _month;
  final int _durationHours;
  final int _excessHours;

  MonthItem(this._month, this._durationHours, this._excessHours);

  @override
  State<StatefulWidget> createState() {
    return MonthItemState(this._month, this._durationHours, this._excessHours);
  }
}

class MonthItemState extends State<MonthItem> {
  final _xlFont = const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  final _xlFontRed = const TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.red);
  final _bigFont =
      const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  final _smallFont =
      const TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal);
  final _mediumFont =
      const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal);

  final DateFormat _yearDateFormat = new DateFormat("yyyy");

  final DateTime _month;
  final int _durationHours;
  final int _excessHours;

  MonthItemState(this._month, this._durationHours, this._excessHours);

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
                Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        Text(DateUtils.getShortMonthName(_month),
                            style: _xlFont),
                        Text(_yearDateFormat.format(_month), style: _smallFont)
                      ],
                    )),
                Expanded(
                    flex: 5,
                    child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Column(
                          children: <Widget>[
                            Text(ClockAppLocalizations.of(context).totalHours,
                                style: _mediumFont),
                            Text(_durationHours.toString(), style: _bigFont)
                          ],
                        ))),
                Expanded(
                    flex: 3,
                    child: (_excessHours != null)
                        ? Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Column(
                              children: <Widget>[
                                Text(
                                    ClockAppLocalizations.of(context)
                                        .excessHours,
                                    style: _mediumFont),
                                (_excessHours.abs() < 10)
                                    ? Text(_excessHours.toString(),
                                        style: _bigFont)
                                    : Text(_excessHours.toString(),
                                        style: _xlFontRed)
                              ],
                            ))
                        : Text(""))
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
