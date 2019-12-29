import 'package:datex/src/units/conversion.dart';
import 'package:datex/src/utils/exception.dart';
import 'package:datex/src/core/timestamp.dart';
import 'package:datex/src/core/timezone.dart';
import 'package:datex/src/core/instant.dart';

final EPOCH = Timestamp(TimeZone.utc(), Instant.epoch(), const TimestampComponents(year: 1970, month: 1, day: 1));

/// Returns whether [year] is a leap year.
bool isLeapYear(int year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
}

/// Returns an iterable of leap years since epoch. This is an infinite list so don't *ever* try to convert it to a [List].
Iterable<int> leapYearsSinceEpoch() sync* {
    int currYear = EPOCH.year;
    while (true) if (isLeapYear(currYear)) yield currYear++;
}

/// Returns an iterable of non leap years since epoch. This is an infinite list so don't *ever* try to convert it to a [List].
Iterable<int> nonLeapYearsSinceEpoch() sync* {
    int currYear = EPOCH.year;
    while (true) if (!isLeapYear(currYear)) yield currYear++;
}

/// Returns the number of days since the epoch corresponding to the given [year], [month], and [day].
int daysSinceEpoch(int year, int month, int day) {
    if (month <= 0 || month > 12) return error(InvalidArgumentException('month'));
    if (day <= 0 || day > daysPerMonth(month, year)) return error(InvalidArgumentException('day'));

    if (month <= 2) year--; // Converts year to the internal year numbering which starts from March.
    final era = (year >= 0 ? year : year - 399) ~/ 400;
    final yearOfEra = year - era * 400;
    final dayOfYear = _dayOfInternalYear(month, day);
    final dayOfEra = yearOfEra * 365 + yearOfEra ~/ 4 - yearOfEra ~/ 100 + dayOfYear;
    return era * 146097 + dayOfEra - 719468;
}

/// Returns the index of day of the given timestamp in a year, assuming March 1st is the first day of the year. The numbering starts
/// with 0, so for instance March 1st gives 0, March 2nd gives 1, etc.
///
/// This function doesn't depend on what year it is because, due to the way we set up the internal year system, the only factor influencing
/// the day index, whether the year is a leap year or not (and thus whether Feb 29th exists), has no impact because Feb 29 is always the last
/// day of an internal year, so all other days have the same index regardless of whether the year is leap or not.
///
/// The function utilizes a clever algorithm by Howard Hinnant. For more information visit http://howardhinnant.github.io/date_algorithms.html.
int _dayOfInternalYear(int month, int day) {
    return ((153 * (month + (month > 2 ? -3 : 9)) + 2) / 5 + day - 1).toInt();
}