import 'package:clock_app/domain/model/work_day.dart';
import 'package:flutter/material.dart';
class WorkingDayPage extends StatelessWidget {
  // Declare a field that holds the WorkDay
  final WorkDay workDay;

  // In the constructor, require a WorkDay
  WorkingDayPage({Key key, @required this.workDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create our UI
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle ${workDay.date}"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Total: ${workDay.totalMinutes}"),
      ),
    );
  }
}
