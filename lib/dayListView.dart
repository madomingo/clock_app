import 'package:flutter/material.dart';
import 'dayItem.dart';
import 'model/workDay.dart';

class DayListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    var state = new DayListViewState();
    List<WorkDay> workDays = loadData();
    state._items = workDays;
    return state;
  }

  List<WorkDay> loadData() {
    List<WorkDay> result = [];
    DateTime in1 = new DateTime(2018, 12, 1, 8, 35, 20);
    DateTime out1 = new DateTime(2018, 12, 1, 18, 16, 20);
    DateTime day1 = in1;
    WorkDay w1 = new WorkDay(day1, in1, out1);
    result.add(w1);
    DateTime in2 = new DateTime(2018, 12, 2, 8, 32, 20);
    DateTime out2 = new DateTime(2018, 12, 2, 18, 15, 20);
    DateTime day2 = in2;
    WorkDay w2 = new WorkDay(day2, in2, out2);
    result.add(w2);
    return result;
  }


}

class DayListViewState extends State<DayListView> {

  List<WorkDay> _items;
  DayListViewState() {
  }


  List<WorkDay> get items => _items;

  set items(List<WorkDay> value) {
    _items = value;
  }

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _items.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) {
            // Add a one-pixel-high divider widget before each row in theListView.
            return Divider();
          } else {
            int index = (i / 2).toInt();
            var item = _items[index];
            int day = item.dateTime.day;
            return DayItem(day.toString());
          }
        }
    );
  }
}