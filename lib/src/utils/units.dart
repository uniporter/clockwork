import 'package:datex/src/util.dart';
import 'package:datex/src/utils/exception.dart';
import 'package:datex/src/utils/system_util.dart';

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

enum TimeUnit {
    MICROSECOND, MILLISECOND, SECOND, MINUTE, HOUR, DAY, MONTH, YEAR
}

extension TimeUnitExtension on TimeUnit {
    operator <(TimeUnit other) => this.index < other.index;
    operator <=(TimeUnit other) => this.index <= other.index;
    operator >(TimeUnit other) => this.index > other.index;
    operator >=(TimeUnit other) => this.index >= other.index;
}

enum Month {
    skip,
    JANUARY,
    FEBRUARY,
    MARCH,
    APRIL,
    MAY,
    JUNE,
    JULY,
    AUGUST,
    SEPTEMBER,
    OCTOBER,
    NOVEMBER,
    DECEMBER
}

extension MonthExtension on Month {
    bool operator <(TimeUnit other) => this.index < other.index;
    bool operator <=(TimeUnit other) => this.index <= other.index;
    bool operator >(TimeUnit other) => this.index > other.index;
    bool operator >=(TimeUnit other) => this.index >= other.index;

    Month operator +(Month other) {
        if (other == Month.skip) error(InvalidArgumentException('other'));
        final index = (this.index + other.index) % 12;
        return Month.values[index == Month.skip ? 1 : index];
    }

    Month operator -(Month other) {
        if (other == Month.skip) error(InvalidArgumentException('other'));
        final index = (this.index - other.index) % 12;
        return Month.values[index == Month.skip ? 12 : index];
    }
}

enum Weekday {
    skip,
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    SUNDAY
}

extension WeekdayExtension on Weekday {
    operator <(Weekday other) => this.index < other.index;
    operator <=(Weekday other) => this.index <= other.index;
    operator >(Weekday other) => this.index > other.index;
    operator >=(Weekday other) => this.index >= other.index;

    Weekday operator +(Weekday other) {
        if (other == Weekday.skip) error(InvalidArgumentException('other'));
        final index = (this.index + other.index) % 7;
        return Weekday.values[index == Weekday.skip ? 1 : index];
    }

    Weekday operator -(Weekday other) {
        if (other == Weekday.skip) error(InvalidArgumentException('other'));
        final index = (this.index - other.index) % 7;
        return Weekday.values[index == Weekday.skip ? 7 : index];
    }
}

/// Returns the number of days in [month] of [year].
int daysPerMonth(int month, int year) {
    const MONTHS_WITH_31_DAYS = [Month.JANUARY, Month.MARCH, Month.MAY, Month.JULY, Month.AUGUST, Month.OCTOBER, Month.DECEMBER];
    const MONTHS_WITH_30_DAYS = [Month.APRIL, Month.JUNE, Month.SEPTEMBER, Month.NOVEMBER];

    if (month <= 0 || month > 12) return error(InvalidArgumentException('month'));

    if (MONTHS_WITH_31_DAYS.contains(Month.values[month])) return 31;
    else if (MONTHS_WITH_30_DAYS.contains(Month.values[month])) return 30;
    else if (isLeapYear(year)) return 29;
    else return 28;
}

/// Returns the number of days in [year].
int daysPerYear(int year) => isLeapYear(year) ? daysPerLeapYear : daysPerNonLeapYear;

int microsecondsInMonth(int month, int year) {
    if (month <= 0 || month > 12) return error(InvalidArgumentException('month'));

    return microsecondsPerDay * daysPerMonth(month, year);
}

int microsecondsPerYear(int year) => isLeapYear(year) ? microsecondsPerLeapYear : microsecondsPerNonLeapYear;