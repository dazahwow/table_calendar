import 'package:date_utils/date_utils.dart';
import 'package:intl/intl.dart';

class CalendarLogic {
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime value) {
    _selectedDate = value;
    _focusedDate = value;
    _visibleMonth = _daysInMonth(value);
  }

  List<DateTime> get visibleMonth => _visibleMonth;
  String get headerText => DateFormat.yMMMM().format(_focusedDate);
  List<String> get daysOfWeek => _visibleMonth.take(7).map((date) => DateFormat.E().format(date)).toList();

  DateTime _focusedDate;
  DateTime _selectedDate;
  List<DateTime> _visibleMonth;

  CalendarLogic() {
    _focusedDate = DateTime.now();
    _selectedDate = _focusedDate;
    _visibleMonth = Utils.daysInMonth(_focusedDate);
  }

  void selectPreviousMonth() {
    _focusedDate = Utils.previousMonth(_focusedDate);
    _visibleMonth = _daysInMonth(_focusedDate);
  }

  void selectNextMonth() {
    _focusedDate = Utils.nextMonth(_focusedDate);
    _visibleMonth = _daysInMonth(_focusedDate);
  }

  List<DateTime> _daysInMonth(DateTime month) {
    var first = Utils.firstDayOfMonth(month);
    var daysBefore = first.weekday;
    var firstToDisplay = first.subtract(new Duration(days: daysBefore));

    if (firstToDisplay.hour == 23) {
      firstToDisplay = firstToDisplay.add(Duration(hours: 1));
    }

    var last = Utils.lastDayOfMonth(month);

    if (last.hour == 23) {
      last = last.add(Duration(hours: 1));
    }

    var daysAfter = 7 - last.weekday;

    // If the last day is sunday (7) the entire week must be rendered
    if (daysAfter == 0) {
      daysAfter = 7;
    }

    var lastToDisplay = last.add(new Duration(days: daysAfter));

    if (lastToDisplay.hour == 1) {
      lastToDisplay = lastToDisplay.subtract(Duration(hours: 1));
    }

    return Utils.daysInRange(firstToDisplay, lastToDisplay).toList();
  }

  bool isSelected(DateTime day) {
    return Utils.isSameDay(day, selectedDate);
  }

  bool isToday(DateTime day) {
    return Utils.isSameDay(day, DateTime.now());
  }

  bool isWeekend(DateTime day) {
    return day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
  }

  bool isExtraDay(DateTime day) {
    final isBefore = _visibleMonth.take(7).where((date) => date.day > 10).any((date) => Utils.isSameDay(date, day));
    final isAfter =
        _visibleMonth.skip(_visibleMonth.length - 1 - 7).where((date) => date.day < 10).any((date) => Utils.isSameDay(date, day));

    return isBefore || isAfter;
  }
}