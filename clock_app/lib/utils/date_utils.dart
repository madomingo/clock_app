import 'package:intl/intl.dart';

class DateUtils {
  static DateFormat _monthDateFormat = new DateFormat("MMM");
  static DateFormat _fullMonthDateFormat = new DateFormat("MMMM yyyy");

  static bool areSameDay(DateTime date1, DateTime date2) {
    if ((date1 == null) && (date2 == null)) {
      return true;
    } else if ((date1 == null) || (date2 == null)) {
      return false;
    } else {
      return (date1.day == date2.day &&
          date1.month == date2.month &&
          date1.year == date2.year);
    }
  }

  static int daysInMonth(int year, int month) {
    int result = 0;
    if ((month >= 1) && (month <= 12)) {
      if (month == 12) {
        month = 1;
        year++;
      }
      result = new DateTime.utc(year, month + 1, 1)
          .difference(new DateTime.utc(year, month, 1))
          .inDays;
    }
    return result;
  }

  static String getShortMonthName(DateTime date) {
    String monthName = _monthDateFormat.format(date);
    monthName = monthName[0].toUpperCase() + monthName.substring(1, 3);
    return monthName;
  }

  static String getFullMonthDate(DateTime date) {
    String dateStr = _fullMonthDateFormat.format(date);
    String result = dateStr[0].toUpperCase() + dateStr.substring(1);
    return result;
  }
}
