import 'package:clock_app/ui/calendar_list_view.dart';
import 'package:clock_app/model/work_month.dart';
import 'package:clock_app/screens/working_month_page.dart';
import 'package:flutter/material.dart';
import '../operations/get_working_months_operation.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    var state = new CalendarPageState();
    return state;
  }
}

class CalendarPageState extends State<CalendarPage> {
  final GetWorkingMonthsOperation operation = GetWorkingMonthsOperation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Working Time Reports"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<WorkMonth>>(
        future: operation.fetchPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CalendarListView(
                data: snapshot.data, onWorkMonthSelected: _onWorkMonthSelected);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner
          return CircularProgressIndicator();
        });
  }

  void _onWorkMonthSelected(WorkMonth workMonth) {
    navigateToDetail(workMonth);
  }

  void navigateToDetail(WorkMonth workMonth) {
    if (workMonth != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => WorkingMonthPage(workMonth)));
    }
  }
}
