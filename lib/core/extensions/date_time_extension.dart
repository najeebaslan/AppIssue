extension CustomDateExtension on DateTime {
  int daysBetween(DateTime to) {
    to = DateTime(to.year, to.month, to.day);
    final form = DateTime(year, month, day);
    return to.difference(form).inDays;
  }

  int getRemainingDays({required DateTime time}) {
    final remaining = daysBetween(time);
    if (remaining < 0) return 0;
    return remaining;
  }
}
