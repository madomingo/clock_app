class WorkMonth {
  DateTime date;
  int totalHours;
  int excessHours;

  WorkMonth(this.date, this.totalHours, this.excessHours);

  factory WorkMonth.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.parse(json["date"]);
    int totalHours = json["total_hours"];
    int excess = json["excess"];
    return WorkMonth(date, totalHours, excess);
  }
}
