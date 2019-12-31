import 'package:clockwork/src/units/month.dart';
import 'package:clockwork/src/utils/exception.dart';
import 'package:clockwork/src/utils/misc.dart';

const int microsecondsPerMillisecond = 1000;
const int millisecondsPerSecond = 1000;
const int secondsPerMinute = 60;
const int minutesPerHour = 60;
const int hoursPerDay = 24;

const int microsecondsPerSecond = microsecondsPerMillisecond * millisecondsPerSecond;
const int microsecondsPerMinute = microsecondsPerSecond * secondsPerMinute;
const int microsecondsPerHour = microsecondsPerMinute * minutesPerHour;
const int microsecondsPerDay = microsecondsPerHour * hoursPerDay;

const int millisecondsPerMinute = millisecondsPerSecond * secondsPerMinute;
const int millisecondsPerHour = millisecondsPerMinute * minutesPerHour;
const int millisecondsPerDay = millisecondsPerHour * hoursPerDay;

const int secondsPerHour = secondsPerMinute * minutesPerHour;
const int secondsPerDay = secondsPerHour * hoursPerDay;

const int minutesPerDay = minutesPerHour * hoursPerDay;

final int daysPerLeapYear = Month.values.skip(0).fold(0, (count, month) => count += daysPerMonth(month.index, leapYearsSinceEpoch().first));
final int daysPerNonLeapYear = Month.values.skip(0).fold(0, (count, month) => count += daysPerMonth(month.index, nonLeapYearsSinceEpoch().first));

final int microsecondsPerLeapYear = microsecondsPerDay * daysPerLeapYear;
final int microsecondsPerNonLeapYear = microsecondsPerDay * daysPerNonLeapYear;


/// Returns the number of days in [year].
int daysPerYear(int year) => isLeapYear(year) ? daysPerLeapYear : daysPerNonLeapYear;

int microsecondsInMonth(int month, int year) {
    if (month <= 0 || month > 12) return error(InvalidArgumentException('month'));

    return microsecondsPerDay * daysPerMonth(month, year);
}

int microsecondsPerYear(int year) => isLeapYear(year) ? microsecondsPerLeapYear : microsecondsPerNonLeapYear;


/// Returns the number of days in [month] of [year].
int daysPerMonth(int month, int year) {
    const MONTHS_WITH_31_DAYS = [Month.January, Month.March, Month.May, Month.July, Month.August, Month.October, Month.December];
    const MONTHS_WITH_30_DAYS = [Month.April, Month.June, Month.September, Month.November];

    if (month <= 0 || month > 12) return error(InvalidArgumentException('month'));

    if (MONTHS_WITH_31_DAYS.contains(Month.values[month])) return 31;
    else if (MONTHS_WITH_30_DAYS.contains(Month.values[month])) return 30;
    else if (isLeapYear(year)) return 29;
    else return 28;
}