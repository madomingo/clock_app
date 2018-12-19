import 'package:flutter/material.dart';

class DateUtils {

  static bool areSameDay(DateTime date1, DateTime date2) {
    if ((date1 == null) && (date2 == null)) {
      return true;
    } else if ((date1 == null) || (date2 == null)) {
      return false;
    } else {
     return (date1.day == date2.day && date1.month == date2.month && date1.year == date2.year);
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

}