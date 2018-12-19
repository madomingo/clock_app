import 'package:clock_app/clock_localizations.dart';
import 'package:clock_app/model/work_day.dart';
import 'package:clock_app/ui/no_working_day_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:clock_app/ui/day_item.dart';
import '../model/ui_work_day_summary.dart';
import '../utils/date_utils.dart';

class DayListView extends StatefulWidget {
  final List<WorkDay> data;

  final Function(WorkDay) onWorkDaySelected;
  DayListView({this.data, this.onWorkDaySelected});

  List<UiWorkDaySummary> buildSummary(List<WorkDay> data) {
    List<UiWorkDaySummary> result = [];
    for (WorkDay workDay in data) {
      DateTime date = workDay.date;
      Duration duration = new Duration(minutes: workDay.totalMinutes);
      var checkings = workDay.checkings;
      DateTime inTime, outTime;
      if (checkings != null) {
        if (checkings.length > 0) {
          inTime = checkings[0];
          if (checkings.length > 1) {
            outTime = checkings[checkings.length - 1];
          }
        }
      }
      UiWorkDaySummary summary = UiWorkDaySummary(
          date: date, duration: duration, inTime: inTime, outTime: outTime);
      result.add(summary);
    }
    return result;
  }

  @override
  State<StatefulWidget> createState() {
    print("createState");
    var summary = buildSummary(this.data);
    print("Summary has: " + summary.length.toString() + " items");
    var state = new DayListViewState(summary, this._onItemClicked);

    return state;
  }

  Function _onItemClicked(int position) {
    print("Item clicked: " + position.toString());
    if ((position >= 0) && (position < data.length)) {
      WorkDay workDay = data[position];
      this.onWorkDaySelected(workDay);
    }
  }
}

class DayListViewState extends State<DayListView> {
  List<UiWorkDaySummary> _items;
  final DateFormat _dayDateFormat = new DateFormat("E");
  final DateFormat _timeFormat = new DateFormat("HH:mm");
  Function(int) _onItemClicked;

  DayListViewState(
      List<UiWorkDaySummary> summary, Function(int) onItemClicked) {
    this._items = summary;
    this._onItemClicked = onItemClicked;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: (_items != null) ? (_items.length * 2) : 0,
        itemBuilder: (context, i) {
          if (i.isOdd) {
            // Add a one-pixel-high divider widget before each row in theListView.
            return Divider();
          } else {
            int itemIndex = i ~/ 2;
            var item = _items[itemIndex];
            DateTime date = item.date;
            String day = date.day.toString();

            String monthName = DateUtils.getShortMonthName(date);
            String dayOfWeek = _dayDateFormat.format(date);
            dayOfWeek = dayOfWeek[0].toUpperCase() + dayOfWeek.substring(1, 3);
            int totalMinutes = item.duration.inMinutes;
            int hours = totalMinutes ~/ 60;
            int minutes = totalMinutes - (hours * 60);
            String duration = hours.toString() + ":" + minutes.toString();
            String inTime = (item.inTime != null)
                ? this._timeFormat.format(item.inTime)
                : "";
            String outTime = (item.outTime != null)
                ? this._timeFormat.format(item.outTime)
                : "";

            return GestureDetector(
                onTap: () {
                  this._onItemClicked(itemIndex);
                },
                child: (item.duration != null && item.duration.inMinutes > 0)
                    ? DayItem(
                        day, monthName, dayOfWeek, duration, inTime, outTime)
                    : NoWorkingDayItem(day, monthName, dayOfWeek));
          }
        });
  }
}

class HeaderItem extends StatelessWidget {
  final _headerFont =
      const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      height: 56.0,
      child: Container(
          decoration: BoxDecoration(color: Colors.black26),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text(ClockAppLocalizations.of(context).date,
                          style: _headerFont)),
                ),
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: EdgeInsets.only(left: 12.0, right: 12.0),
                            child: Text(
                                ClockAppLocalizations.of(context).in_out,
                                style: _headerFont,
                                textAlign: TextAlign.center)))),
                Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Padding(
                            padding: EdgeInsets.only(right: 12.0),
                            child: Text(
                                ClockAppLocalizations.of(context).working_time,
                                style: _headerFont,
                                textAlign: TextAlign.right))))
              ])),
    );
  }
}
