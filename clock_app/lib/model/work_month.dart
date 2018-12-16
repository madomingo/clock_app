class WorkMonth {
  DateTime _date;
  int _totalHours;
  int _excessHours;

  WorkMonth(this._date, this._totalHours, this._excessHours);


  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  int get totalHours => _totalHours;

  set totalHours(int value) {
    _totalHours = value;
  }

  int get excessHours => _excessHours;

  set excessHours(int value) {
    _excessHours = value;
  }

  factory WorkMonth.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.parse(json["date"]);
    int totalHours = json["total_hours"];
    int excess = json["excess"];
    return WorkMonth(date, totalHours, excess);

  }

}