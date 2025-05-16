enum AlarmLevel {
  /// First Weak
  first,

  ///First 45 Day
  next,

  ///Next 45 Day
  third,
}

enum AlarmTypes {
  isCompleted,
  firstAlarm,
  nextAlarm,
  thirdAlert,
}

/// This AlarmsDays static from business logic
class AlarmsDays {
  static const int _firstAlarm = 7;
  static const int _nextAlarm = _firstAlarm + 45;
  static const int _thirdAlarm = _nextAlarm + 45;

  static int calculateLavalDays(AlarmLevel alarmLevel) {
    int endResult = 0;

    switch (alarmLevel) {
      case AlarmLevel.first:
        endResult = _firstAlarm;
        break;
      case AlarmLevel.next:
        endResult = _nextAlarm;
        break;
      case AlarmLevel.third:
        endResult = _thirdAlarm;
        break;
    }
    return endResult;
  }

  static String getLevelName(int remainingDays) {
    if (remainingDays <= _firstAlarm) {
      return 'first';
    } else if (remainingDays > _firstAlarm && remainingDays <= _nextAlarm) {
      return 'second';
    } else {
      return 'third';
    }
  }

  static String getLevelNameFromAlarmLevelThird(int remainingDays) {
    if (remainingDays > _nextAlarm) {
      return 'first';
    } else if (remainingDays < _nextAlarm && remainingDays < _firstAlarm) {
      return 'second';
    } else {
      return 'first';
    }
  }
}
