import 'package:clock_app/model/work_day.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for json decoding

class GetWorkingDaysOperation {
  Future<List<WorkDay>> fetchPost() async {
    final response =
    await http.get('http://movilok.net/cms/movilok/test/working_days.json');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var document = json.decode(response.body);
      List data = document["workDays"];
      List<WorkDay> result = [];
      for (var item in data) {
        WorkDay workDay = WorkDay.fromJson(item);
        result.add(workDay);
      }
      return result;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}