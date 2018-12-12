import 'package:clock_app/clock_localizations.dart';
import 'package:clock_app/model/work_day.dart';
import 'package:clock_app/working_day_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'day_item.dart';
import 'model/ui_work_day_summary.dart';

class DayListView extends StatefulWidget {
  final List<WorkDay> data;

  final Function(WorkDay) onWorkDaySelected;
  DayListView({this.data, this.onWorkDaySelected});


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
  final DateFormat _monthDateFormat = new DateFormat("MMM");
  final DateFormat _dayDateFormat = new DateFormat("E");
  Function(int) _onItemClicked;

  DayListViewState(List<UiWorkDaySummary> summary, Function(int) onItemClicked) {
    this._items = summary;
    this._onItemClicked = onItemClicked;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: (_items != null) ? (_items.length * 2) + 1 : 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            // return the header
            return HeaderItem();
          } else {
            int index = i - 1;
            if (index.isOdd) {
              // Add a one-pixel-high divider widget before each row in theListView.
              return Divider();
            } else {
              int itemIndex = index ~/ 2;
              var item = _items[itemIndex];
              DateTime date = item.date;
              String day = date.day.toString();

              String monthName = _monthDateFormat.format(date);
              monthName =
                  monthName[0].toUpperCase() + monthName.substring(1, 3);
              String dayOfWeek = _dayDateFormat.format(date);
              dayOfWeek =
                  dayOfWeek[0].toUpperCase() + dayOfWeek.substring(1, 3);
              int totalMinutes = item.duration.inMinutes;
              int hours = totalMinutes ~/ 60;
              int minutes = totalMinutes - (hours * 60);
              String duration = hours.toString() + ":" + minutes.toString();
              return GestureDetector(
                  onTap: () {
                    this._onItemClicked(itemIndex);
                    },
                  child: DayItem(day, monthName, dayOfWeek, duration));
            }
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
          decoration: BoxDecoration(color: Colors.grey),
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
