import 'package:flutter/material.dart';

class DayItem extends StatefulWidget {

  final String _dayOfMonth;
  final String _month;
  final String _dayOfWeek;
  final String _duration;

  DayItem(this._dayOfMonth, this._month, this._dayOfWeek, this._duration);

  @override
  State<StatefulWidget> createState() {
    return DayItemState(this._dayOfMonth, this._month, this._dayOfWeek, this._duration);
  }}


  class DayItemState extends State<DayItem> {

    final _biggerFont =
    const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
    final _smallFont =
    const TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal);
    final _mediumFont =
    const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal);

    final String _dayOfMonth;
    final String _month;
    final String _dayOfWeek;
    final String _duration;

    DayItemState(this._dayOfMonth, this._month, this._dayOfWeek, this._duration);

    bool _tapped = false;
    @override
    Widget build(BuildContext context) {
      return
        Listener(
            onPointerDown: _onDown,
            onPointerUp: _onUp,
            onPointerCancel: _onCancel,
            child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(color: (_tapped) ? Colors.amber : Colors.transparent),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(_dayOfMonth, style: _biggerFont),
                        Text(_month, style: _smallFont)
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(_dayOfWeek, style: _mediumFont)),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(right: 12.0),
                            child: Text(_duration,
                                style: _biggerFont, textAlign: TextAlign.right)))
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



