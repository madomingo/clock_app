class WorkDay implements Comparable<WorkDay> {
  DateTime _date;
  int _totalMinutes;
  List<DateTime> _checkings;

  WorkDay(this._date, this._totalMinutes, this._checkings);

  List<DateTime> get checkings => _checkings;

  set checkings(List<DateTime> value) {
    _checkings = value;
  }

  int get totalMinutes => _totalMinutes;

  set totalMinutes(int value) {
    _totalMinutes = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  factory WorkDay.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.parse(json["date"]);
    int totalMinutes = json["total_minutes"];
    List checkings = json["checkings"];
    List<DateTime> checkingDates = [];
    for (var checking in checkings) {
      DateTime checkDate =  DateTime.parse(checking);
      checkingDates.add(checkDate);
    }
    return WorkDay(date, totalMinutes, checkingDates);

  }

  @override
  int compareTo(WorkDay other) {
    if (other == null) {
      return 1;
    } else if (this.date == null && other.date == null) {
      return 0;
    } else if (this.date == null && other.date != null) {
      return -1;
    } else {
      return this.date.compareTo(other.date);
    }
  }

}