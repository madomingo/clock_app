import 'package:clock_app/domain/model/work_month.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for json decoding

class GetWorkingMonthsOperation {
  Future<List<WorkMonth>> fetchPost() async {
    final response =
    await http.get('http://movilok.net/cms/movilok/test/working_months.json');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var document = json.decode(response.body);
      List data = document["workMonths"];
      List<WorkMonth> result = [];
      for (var item in data) {
        WorkMonth workDay = WorkMonth.fromJson(item);
        result.add(workDay);
      }
      return result;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}