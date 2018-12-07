import 'package:flutter/material.dart';

class DayItem extends StatelessWidget {

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final String _title;

  DayItem(this._title);

  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      style: _biggerFont,
    );
  }




}
