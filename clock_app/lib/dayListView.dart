import 'package:clock_app/model/work_day.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dayItem.dart';
import 'model/ui_work_day_summary.dart';
class DayListView extends StatefulWidget {
  List<WorkDay> _data;
  DayListView(List<WorkDay> data) {
    this._data = data;
  }

  @override
  State<StatefulWidget> createState() {
    print("createState");
    var summary = buildSummary(this._data);
    print("Summary has: " + summary.length.toString() + " items");
    var state = new DayListViewState(summary);

    return state;
  }

  List<UiWorkDaySummary> buildSummary(List<WorkDay> data) {

    List<UiWorkDaySummary> result = [];
    for (WorkDay workDay in data) {
      DateTime date = workDay.date;
      Duration duration = new Duration(minutes: workDay.totalMinutes);
      UiWorkDaySummary summary = UiWorkDaySummary(date, duration);
      result.add(summary);

    }
    return result;
  }


}

class DayListViewState extends State<DayListView> {
  List<UiWorkDaySummary> _items;
  final DateFormat _monthDateFormat = new DateFormat("MMM");
  final DateFormat _dayDateFormat = new DateFormat("E");

  DayListViewState(List<UiWorkDaySummary> summary) {
    this._items = summary;
  }

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: (_items != null) ? _items.length * 2 : 0,
        itemBuilder: (context, i) {
          if (i.isOdd) {
            // Add a one-pixel-high divider widget before each row in theListView.
            return Divider();
          } else {
            int index = i ~/ 2;
            var item = _items[index];
            DateTime date = item.date;
            String day = date.day.toString();

            String monthName = _monthDateFormat.format(date);
            monthName = monthName[0].toUpperCase() + monthName.substring(1,3);
            String dayOfWeek = _dayDateFormat.format(date);
            dayOfWeek = dayOfWeek[0].toUpperCase() + dayOfWeek.substring(1,3);
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