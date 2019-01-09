import 'package:clock_app/utils/date_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clock_app/domain/model/work_day.dart';

void main() {
  test('Utils test', () {
    DateTime now = DateTime.now();
    String dateStr = DateUtils.getFullDateString(now);
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime parsed = DateTime.parse(dateStr);
    int compared = today.compareTo(parsed);
    expect(compared, 0);
  });
}
