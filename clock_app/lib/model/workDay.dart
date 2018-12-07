class WorkDay {
  DateTime _dateTime;
  DateTime _inTime;
  DateTime _outTime;

  WorkDay(this._dateTime, this._inTime, this._outTime);

  DateTime get outTime => _outTime;

  DateTime get inTime => _inTime;

  DateTime get dateTime => _dateTime;

  Duration duration() {
    return _outTime.difference(_inTime);
  }

}