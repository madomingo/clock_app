import 'package:clock_app/day_list_view.dart';
import 'package:clock_app/model/work_day.dart';
import 'package:clock_app/working_day_page.dart';
import 'package:flutter/material.dart';
import 'operations/get_working_days_operation.dart';
class WorkingMonthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    var state = new WorkingMonthPageState();

    return state;
  }


}

class WorkingMonthPageState extends State<WorkingMonthPage> {

  final GetWorkingDaysOperation operation = GetWorkingDaysOperation();


  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<WorkDay>>(
      future: operation.fetchPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DayListView(data: snapshot.data,
              onWorkDaySelected: _onWorkDaySelected
              );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner
        return CircularProgressIndicator();
      });

  }

  Function _onWorkDaySelected(WorkDay workDay)  {
    navigateToDetail(workDay);
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
}