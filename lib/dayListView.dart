import 'package:flutter/material.dart';
import 'dayItem.dart';
import 'model/ui_work_day_summary.dart';
import 'package:intl/date_symbol_data_local.dart';

class DayListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    var state = new DayListViewState();
    List<UiWorkDaySummary> workDays = loadData();
    state._items = workDays;
    return state;
  }

  List<UiWorkDaySummary> loadData() {
    List<UiWorkDaySummary> result = [];
    DateTime day1 = new DateTime(2018, 12, 1, 8, 35, 20);
    Duration duration1 = new Duration(hours: 8, minutes: 35);

    UiWorkDaySummary w1 = new UiWorkDaySummary(day1, duration1);
    result.add(w1);
    DateTime day2 = new DateTime(2018, 12, 2, 8, 35, 20);
    Duration duration2 = new Duration(hours: 8, minutes: 29);
    UiWorkDaySummary w2 = new UiWorkDaySummary(day2, duration2);
    result.add(w2);
    return result;
  }


}

class DayListViewState extends State<DayListView> {

  List<UiWorkDaySummary> _items;
  //DateFormat _dateFormat;
  DayListViewState();


  List<UiWorkDaySummary> get items => _items;

  set items(List<UiWorkDaySummary> value) {
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
            int index = i ~/ 2;
            var item = _items[index];
            DateTime date = item.date;
            String day = date.day.toString();
            String monthName = "December";
            String dayOfWeek = "Wednesday";
            int totalMinutes = item.duration.inMinutes;
            int hours = totalMinutes ~/ 60;
            int minutes = totalMinutes - (hours * 60);
            String duration = hours.toString() + ":" + minutes.toString();
            return DayItem(day, monthName, dayOfWeek, duration);
          }
        }
    );
  }
}