import 'package:clock_app/domain/model/work_month.dart';
import 'package:clock_app/ui/month_item.dart';
import 'package:flutter/material.dart';

class CalendarListView extends StatefulWidget {
  final List<WorkMonth> data;

  final Function(WorkMonth) onWorkMonthSelected;
  CalendarListView({this.data, this.onWorkMonthSelected});

  @override
  State<StatefulWidget> createState() {
    var state = new CalendarListViewState(this.data, this._onItemClicked);

    return state;
  }

  void _onItemClicked(int position) {
    if ((position >= 0) && (position < data.length)) {
      WorkMonth workMonth = data[position];
      this.onWorkMonthSelected(workMonth);
    }
  }
}

class CalendarListViewState extends State<CalendarListView> {
  List<WorkMonth> _items;
  Function(int) _onItemClicked;

  CalendarListViewState(List<WorkMonth> items, Function(int) onItemClicked) {
    this._items = items;
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
            int duration = item.totalHours;
            int excess = item.excessHours;

            return GestureDetector(
                onTap: () {
                  this._onItemClicked(itemIndex);
                },
                child: MonthItem(date, duration, excess));
          }
        });
  }
}
