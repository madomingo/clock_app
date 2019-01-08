import 'dart:convert'; // for json decoding
import 'package:flutter_test/flutter_test.dart';
import 'package:clock_app/domain/model/work_day.dart';

void main() {
  test('WorkDay json parser test', () {
    String text = getJsonWorkDay();
    var jsonResponse = json.decode(text);
    WorkDay workDay = WorkDay.fromJson(jsonResponse);
    expect(workDay.totalMinutes, 521);
    expect(workDay.checkings.length, 2);
  });
}


String getJsonWorkDay() {
  String json = "{\"date\": \"2018-12-03T00:00:00.000Z\",\"total_minutes\": 521,\"checkings\": [\"2018-12-03T08:35:26.000Z\",\"2018-12-03T18:03:01.000Z\"]}";
  return json;
}
