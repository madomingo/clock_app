class WorkDay implements Comparable<WorkDay> {
  DateTime date;
  int totalMinutes;
  List<DateTime> checkins;

  WorkDay(this.date, this.totalMinutes, this.checkins);

  factory WorkDay.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.parse(json["date"]);
    int totalMinutes = json["total_minutes"];
    List checkings = json["checkings"];
    List<DateTime> checkingDates = [];
    for (var checking in checkings) {
      DateTime checkDate = DateTime.parse(checking);
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
