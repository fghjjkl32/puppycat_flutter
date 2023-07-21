import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:intl/intl.dart';

/// Provides extra functionality for formatting the time.
extension DateTimeExtension on DateTime {
  bool operator <(DateTime other) {
    return millisecondsSinceEpoch < other.millisecondsSinceEpoch;
  }

  bool operator >(DateTime other) {
    return millisecondsSinceEpoch > other.millisecondsSinceEpoch;
  }

  bool operator >=(DateTime other) {
    return millisecondsSinceEpoch >= other.millisecondsSinceEpoch;
  }

  bool operator <=(DateTime other) {
    return millisecondsSinceEpoch <= other.millisecondsSinceEpoch;
  }

  /// Two message events can belong to the same environment. That means that they
  /// don't need to display the time they were sent because they are close
  /// enaugh.
  static const minutesBetweenEnvironments = 5;

  /// Checks if two DateTimes are close enough to belong to the same
  /// environment.
  bool sameEnvironment(DateTime prevTime) {
    return millisecondsSinceEpoch - prevTime.millisecondsSinceEpoch < 1000 * 60 * minutesBetweenEnvironments;
  }

  /// Returns a simple time String.
  /// TODO: Add localization
  String localizedTimeOfDay(BuildContext context) {
    if (MediaQuery.of(context).alwaysUse24HourFormat) {
      return '${_z(hour)}:${_z(minute)}';
    } else {
      return '${_z(hour % 12 == 0 ? 12 : hour % 12)}:${_z(minute)} ${hour > 11 ? "pm" : "am"}';
    }
  }

  /// Returns a simple time String.
  /// TODO: Add localization
  String timeOfDay() {
    return '${hour > 11 ? "pm" : "am"} ${_z(hour % 12 == 0 ? 12 : hour % 12)}:${_z(minute)}'.toUpperCase();
  }

  /// Returns [localizedTimeOfDay()] if the ChatTime is today, the name of the week
  /// day if the ChatTime is this week and a date string else.
  String localizedTimeShort(BuildContext context) {
    final now = DateTime.now();

    final sameYear = now.year == year;

    final sameDay = sameYear && now.month == month && now.day == day;

    final sameWeek = sameYear && !sameDay && now.millisecondsSinceEpoch - millisecondsSinceEpoch < 1000 * 60 * 60 * 24 * 7;

    if (sameDay) {
      return localizedTimeOfDay(context);
    } else if (sameWeek) {
      return DateFormat.EEEE(Localizations.localeOf(context).languageCode).format(this);
    } else if (sameYear) {
      return '${month.toString().padLeft(2, '0')}--${day.toString().padLeft(2, '0')}';
      // return L10n.of(context)!.dateWithoutYear(
      //   month.toString().padLeft(2, '0'),
      //   day.toString().padLeft(2, '0'),
      // );
    }
    return '${year.toString()}--${month.toString().padLeft(2, '0')}--${day.toString().padLeft(2, '0')}';

    // return L10n.of(context)!.dateWithYear(
    //   year.toString(),
    //   month.toString().padLeft(2, '0'),
    //   day.toString().padLeft(2, '0'),
    // );
  }

  String localizedTimeDayDiff() {
    final now = DateTime.now();
    final targetDT = DateTime(year, month, day, hour, minute, second, millisecond, microsecond);

    final sameYear = now.year == year;
    final sameDay = sameYear && now.month == month && now.day == day;

    Duration difference = targetDT.difference(now);
    int days = difference.inDays.abs();
    int hours = difference.inHours.abs();
    int minutes = difference.inMinutes.abs();
    int seconds = difference.inSeconds.abs();

    if (sameDay) {
      if (hours > 0) {
        return '$hours${'메시지.시간 전'.tr()}';
      } else {
        if (minutes > 0) {
          return '$minutes${'메시지.분 전'.tr()}';
        } else {
          if (seconds > 0) {
            return '$seconds${'메시지.초 전'.tr()}';
          } else {
            return '메시지.방금'.tr();
          }
        }
      }
    } else {
      if (days > 30) {
        return '${year.toString()}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
      } else {
        return '$days${'메시지.일 전'.tr()}';
      }
    }

    // return L10n.of(context)!.dateWithYear(
    //   year.toString(),
    //   month.toString().padLeft(2, '0'),
    //   day.toString().padLeft(2, '0'),
    // );
  }

  /// If the DateTime is today, this returns [localizedTimeOfDay()], if not it also
  /// shows the date.
  /// TODO: Add localization
  String localizedTime(BuildContext context) {
    final now = DateTime.now();

    final sameYear = now.year == year;

    final sameDay = sameYear && now.month == month && now.day == day;

    if (sameDay) return localizedTimeOfDay(context);
    return '${localizedTimeShort(context)}, ${localizedTimeOfDay(context)}';
    // return L10n.of(context)!.dateAndTimeOfDay(
    //   localizedTimeShort(context),
    //   localizedTimeOfDay(context),
    // );
  }

  static String _z(int i) => i < 10 ? '0${i.toString()}' : i.toString();
}
