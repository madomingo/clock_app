import 'package:clock_app/ui/day_list_view.dart';
import 'package:clock_app/model/work_day.dart';
import 'package:clock_app/screens/working_day_page.dart';
import 'package:flutter/material.dart';
import '../operations/get_working_days_operation.dart';
import '../model/work_month.dart';
import '../utils/date_utils.dart';

class WorkingMonthPage extends StatefulWidget {

  final WorkMonth _workMonth;


  WorkingMonthPage(this._workMonth);

  @override
  State<StatefulWidget> createState() {
    var state = new WorkingMonthPageState(_workMonth);

    return state;
  }


}

class WorkingMonthPageState extends State<WorkingMonthPage> {

  final GetWorkingDaysOperation operation = GetWorkingDaysOperation();
  final WorkMonth _workMonth;

  WorkingMonthPageState(this._workMonth);


  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(
          title: Text(DateUtils.getFullMonthDate(_workMonth.date)),
        ),
        body: FutureBuilder<List<WorkDay>>(
          future: operation.fetchPost(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<WorkDay> data = buildWorkDayList(_workMonth.date, snapshot.data);
              return DayListView(data: data,
                  onWorkDaySelected: _onWorkDaySelected
                  );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner
            return Center(child: CircularProgressIndicator());
          }));

  }

  Function _onWorkDaySelected(WorkDay workDay)  {
    if ((workDay != null) && (workDay.totalMinutes > 0)) {
      navigateToDetail(workDay);
    }
  }
  void navigateToDetail(WorkDay workDay) {
    if (workDay != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkingDayPage(workDay: workDay),
          ));
    }
  }

  List<WorkDay> buildWorkDayList(DateTime date, List<WorkDay> data) {
    List<WorkDay> fullMonth = [];
    if ((data != null) && (date != null)) {
      int month = date.month;
      int year = date.year;
      int lastDay = DateUtils.daysInMonth(year, month);
      int index = 0;
        for (int day = 1; day <= lastDay; day++) {
          WorkDay workDay = (index < data.length) ? data[index] : null;
          DateTime currentDate = new DateTime(year, month, day);
          if ((workDay != null) && (DateUtils.areSameDay(currentDate, workDay.date))) {
            index++;
          } else {
            // create empty WorkDay
            workDay = WorkDay(currentDate, 0, null);
          }
          fullMonth.add(workDay);
        }

    }
    return fullMonth;


  }
}