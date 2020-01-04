import 'package:clockwork/src/calendar/calendar.dart';
import 'package:clockwork/src/core/instant.dart';
import 'package:clockwork/src/core/timestamp.dart';
import 'package:clockwork/src/core/timezone.dart';
import 'package:clockwork/src/locale/locale.dart';
import 'package:clockwork/src/units/conversion.dart';
import 'package:clockwork/src/utils/exception.dart';
import 'package:clockwork/src/utils/system_util.dart';

class GregorianCalendar extends Calendar {
    final String name = 'gregorian';

    static final GregorianCalendar _singleton = GregorianCalendar._internal();
    factory GregorianCalendar() => _singleton;
    GregorianCalendar._internal();

    /// Returns a timestamp from the explicitly provided timezone and timestamp components.
    ///
    /// Note: In certain cases a given TimestampComponents and a timezone alone do not suffice to determine an unique instant.
    /// In this case [AmbiguousTimestampException] will be thrown. Othertimes the components are valid but the time actually
    /// doesn't exist, in which case [TimestampNonexistentException] will be thrown.
    Timestamp fromComponents(TimeZone timezone, int year, Month month, int day, [int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]) {
        if (timezone == null) throw InvalidArgumentException('timezone');
        else if (month == Month.skip) throw InvalidArgumentException('month');
        else if (day <= 0 || day > daysPerMonth(month, year)) throw InvalidArgumentException('day');
        else if (hour < 0 || hour > 23) throw InvalidArgumentException('hour');
        else if (minute < 0 || minute > 59) throw InvalidArgumentException('minute');
        else if (second < 0 || second > 59) throw InvalidArgumentException('second');
        else if (millisecond < 0 || millisecond > 999) throw InvalidArgumentException('millisecond');
        else if (microsecond < 0 || microsecond > 999) throw InvalidArgumentException('microsecond');

        final surmisedComponents = GregorianCalendarComponents(
            year: year,
            month: month,
            day: day,
        );

        final surmisedMicrosecondsSinceEpochOffseted = daysSinceEpoch(year, month, day) * microsecondsPerDay + hour * microsecondsPerHour + minute * microsecondsPerMinute + second * microsecondsPerSecond + millisecond * microsecondsPerMillisecond + microsecond;
        final surmisedHistory1 = timezone.history.firstWhere((item) => item.until >= surmisedMicrosecondsSinceEpochOffseted);
        final surmisedOffsetInMicroseconds1 = (timezone.possibleOffsets[surmisedHistory1.index] * microsecondsPerMinute).truncate();
        final surmisedMicrosecondsSinceEpochUTC = surmisedMicrosecondsSinceEpochOffseted + surmisedOffsetInMicroseconds1;

        final surmisedHistory2 = timezone.history.firstWhere((item) => item.until >= surmisedMicrosecondsSinceEpochUTC);
        final surmisedOffsetInMicroseconds2 = (timezone.possibleOffsets[surmisedHistory2.index] * microsecondsPerMinute).truncate();
        if (surmisedOffsetInMicroseconds1 != surmisedOffsetInMicroseconds2) throw TimestampNonexistentException("FUCKed");

        final surmisedHistory2Index = timezone.history.indexOf(surmisedHistory2);
        if (surmisedHistory2Index > 0) {
            final surmisedHistory3 = timezone.history[surmisedHistory2Index - 1];
            final surmisedOffsetInMicroseconds3 = (timezone.possibleOffsets[surmisedHistory3.index] * microsecondsPerMinute).truncate();
            final surmisedMicrosecondsSinceEpochUTC2 = surmisedMicrosecondsSinceEpochOffseted + surmisedOffsetInMicroseconds3;

            final surmisedHistory4 = timezone.history.firstWhere((item) => item.until >= surmisedMicrosecondsSinceEpochUTC2);
            final surmisedOffsetInMicroseconds4 = (timezone.possibleOffsets[surmisedHistory4.index] * microsecondsPerMinute).truncate();
            if (surmisedOffsetInMicroseconds3 == surmisedOffsetInMicroseconds4) throw AmbiguousTimestampException("FUCKed");
        }

        if (surmisedHistory2Index < timezone.history.length - 1) {
            final surmisedHistory5 = timezone.history[surmisedHistory2Index + 1];
            final surmisedOffsetInMicroseconds5 = (timezone.possibleOffsets[surmisedHistory5.index] * microsecondsPerMinute).truncate();
            final surmisedMicrosecondsSinceEpochUTC3 = surmisedMicrosecondsSinceEpochOffseted + surmisedOffsetInMicroseconds5;

            final surmisedHistory6 = timezone.history.firstWhere((item) => item.until >= surmisedMicrosecondsSinceEpochUTC3);
            final surmisedOffsetInMicroseconds6 = (timezone.possibleOffsets[surmisedHistory6.index] * microsecondsPerMinute).truncate();
            if (surmisedOffsetInMicroseconds5 == surmisedOffsetInMicroseconds6) throw AmbiguousTimestampException("FUCKed");
        }

        final artifact = Timestamp(
            timezone,
            Instant(surmisedMicrosecondsSinceEpochUTC),
        );

        _componentsCache[artifact] = surmisedComponents;
        return artifact;
    }
}

enum Length {
    MICROSECOND, MILLISECOND, SECOND, MINUTE, HOUR, DAY, MONTH, YEAR
}

extension LengthExtension on Length {
    operator <(Length other) => this.index < other.index;
    operator <=(Length other) => this.index <= other.index;
    operator >(Length other) => this.index > other.index;
    operator >=(Length other) => this.index >= other.index;
}

enum Era {
    AD, BC
}

extension EraExtension on Era {
    /// Returns the locale-sensitive name of the era.
    String toName([Locale? locale])  => this == Era.AD ? nonNullLocale(locale).gregorianCalendar.eras.name.pre : nonNullLocale(locale).gregorianCalendar.eras.name.post;
    /// Returns the locale-sensitive abbreviation of the era.
    String toAbbr([Locale? locale])  => this == Era.AD ? nonNullLocale(locale).gregorianCalendar.eras.abbr.pre : nonNullLocale(locale).gregorianCalendar.eras.abbr.post;
    /// Returns the locale-sensitive narrow name of the era.
    String toNarrow([Locale? locale]) => this == Era.AD ? nonNullLocale(locale).gregorianCalendar.eras.narrow.pre : nonNullLocale(locale).gregorianCalendar.eras.narrow.post;

    /// Returns the alternative locale-sensitive name of the era.
    String toNameAlt([Locale? locale])  => this == Era.AD ? nonNullLocale(locale).gregorianCalendar.eras.name.preAlt : nonNullLocale(locale).gregorianCalendar.eras.name.postAlt;
    /// Returns the alternative locale-sensitive abbreviation of the era.
    String toAbbrAlt([Locale? locale])  => this == Era.AD ? nonNullLocale(locale).gregorianCalendar.eras.abbr.preAlt : nonNullLocale(locale).gregorianCalendar.eras.abbr.postAlt;
    /// Returns the alternative locale-sensitive narrow name of the era.
    String toNarrowAlt([Locale? locale]) => this == Era.AD ? nonNullLocale(locale).gregorianCalendar.eras.narrow.preAlt : nonNullLocale(locale).gregorianCalendar.eras.narrow.postAlt;
}

enum Quarter {
    skip,
    Spring,
    Summer,
    Fall,
    Winter,
}

extension QuarterExtension on Quarter {
    /// Returns the locale-sensitive abbreviated name of the month.
    String toAbbr([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.format.abbreviated[this.index - 1];
    /// Returns the locale-sensitive narrow name of the month.
    String toNarrow([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.format.narrow[this.index - 1];
    /// Returns the locale-sensitive abbreviated name of the month.
    String toWide([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.format.wide[this.index - 1];
    /// Returns the locale-sensitive abbreviated name of the month. If the locale doesn't contain this info, returns [null].
    String? toShort([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.format.short?.elementAt(this.index - 1);
    /// Returns the standalone, locale-sensitive abbreviated name of the month.
    String toAbbrStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.standalone.abbreviated[this.index - 1];
    /// Returns the standalone, locale-sensitive narrow name of the month.
    String toNarrowStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.standalone.narrow[this.index - 1];
    /// Returns the standalone, locale-sensitive abbreviated name of the month.
    String toWideStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.standalone.wide[this.index - 1];
    /// Returns the standalone, locale-sensitive abbreviated name of the month. If the locale doesn't contain this info, returns [null].
    String? toShortStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.standalone.short?.elementAt(this.index - 1);
}

enum FixedDayPeriod {
    AM,
    PM
}

extension FixedDayPeriodExtension on FixedDayPeriod {
    String? _map(DayPeriods dp, [bool alt = false]) {
        switch (this) {
            case FixedDayPeriod.AM:
                return alt ? dp.amAlt : dp.am;
            case FixedDayPeriod.PM:
                return alt ? dp.pmAlt : dp.pm;
            default:
                return null;
        }
    }

    /// Returns the locale-sensitive abbreviated name of the day period.
    String toAbbr([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.abbreviated) as String;
    /// Returns the locale-sensitive narrow name of the day period.
    String toNarrow([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.narrow) as String;
    /// Returns the locale-sensitive wide name of the day period.
    String toWide([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.wide) as String;
    /// Returns the standalone locale-sensitive abbreviated name of the day period.
    String toAbbrStandalone([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.abbreviated) as String;
    /// Returns the standalone locale-sensitive narrow name of the day period.
    String toNarrowStandalone([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.narrow) as String;
    /// Returns the standalone locale-sensitive wide name of the day period.
    String toWideStandalone([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.wide) as String;

    /// Returns the alternative locale-sensitive abbreviated name of the day period.
    String? toAbbrAlt([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.abbreviated, true);
    /// Returns the alternative locale-sensitive narrow name of the day period.
    String? toNarrowAlt([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.narrow, true);
    /// Returns the alternative locale-sensitive wide name of the day period.
    String? toWideAlt([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.wide, true);
    /// Returns the alternative standalone locale-sensitive abbreviated name of the day period.
    String? toAbbrStandaloneAlt([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.abbreviated, true);
    /// Returns the alternative standalone locale-sensitive narrow name of the day period.
    String? toNarrowStandaloneAlt([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.narrow, true);
    /// Returns the alternative standalone locale-sensitive wide name of the day period.
    String? toWideStandaloneAlt([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.wide, true);
}

enum DayPeriod {
    Midnight,
    Noon,
    Morning1,
    Morning2,
    Afternoon1,
    Evening1,
    Night1,
    Afternoon2,
    Night2,
    Evening2,
}

extension DayPeriodExtension on DayPeriod {
    String? _map(DayPeriods dp) {
        switch (this) {
            case DayPeriod.Midnight: return dp.midnight;
            case DayPeriod.Noon: return dp.noon;
            case DayPeriod.Morning1: return dp.morning1;
            case DayPeriod.Morning2: return dp.morning2;
            case DayPeriod.Afternoon1: return dp.afternoon1;
            case DayPeriod.Evening1: return dp.evening1;
            case DayPeriod.Night1: return dp.night1;
            case DayPeriod.Afternoon2: return dp.afternoon2;
            case DayPeriod.Night2: return dp.night2;
            case DayPeriod.Evening2: return dp.evening2;
            default: return null;
        }
    }

    /// Returns the locale-sensitive abbreviated name of the day period.
    String? toAbbr([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.abbreviated);
    /// Returns the locale-sensitive narrow name of the day period.
    String? toNarrow([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.narrow) as String;
    /// Returns the locale-sensitive wide name of the day period.
    String? toWide([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.wide);
    /// Returns the standalone locale-sensitive abbreviated name of the day period.
    String? toAbbrStandalone([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.abbreviated);
    /// Returns the standalone locale-sensitive narrow name of the day period.
    String? toNarrowStandalone([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.narrow);
    /// Returns the standalone locale-sensitive wide name of the day period.
    String? toWideStandalone([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.wide);
}

enum Month {
    skip,
    January,
    February,
    March,
    April,
    May,
    June,
    July,
    August,
    September,
    October,
    November,
    December,
}

extension MonthExtension on Month {
    bool operator <(Month other) => this.index < other.index;
    bool operator <=(Month other) => this.index <= other.index;
    bool operator >(Month other) => this.index > other.index;
    bool operator >=(Month other) => this.index >= other.index;

    Month operator +(Month other) {
        if (other == Month.skip) throw InvalidArgumentException('other');
        final index = (this.index + other.index) % 12;
        return Month.values[index == Month.skip ? 1 : index];
    }

    Month operator -(Month other) {
        if (other == Month.skip) throw InvalidArgumentException('other');
        final index = (this.index - other.index) % 12;
        return Month.values[index == Month.skip ? 12 : index];
    }

    /// Returns the locale-sensitive abbreviated name of the month.
    String toAbbr([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.format.abbreviated[this.index - 1];
    /// Returns the locale-sensitive narrow name of the month.
    String toNarrow([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.format.narrow[this.index - 1];
    /// Returns the locale-sensitive abbreviated name of the month.
    String toWide([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.format.wide[this.index - 1];
    /// Returns the locale-sensitive abbreviated name of the month. If the locale doesn't contain this info, returns [null].
    String? toShort([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.format.short?.elementAt(this.index - 1);
    /// Returns the standalone, locale-sensitive abbreviated name of the month.
    String toAbbrStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.standalone.abbreviated[this.index - 1];
    /// Returns the standalone, locale-sensitive narrow name of the month.
    String toNarrowStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.standalone.narrow[this.index - 1];
    /// Returns the standalone, locale-sensitive abbreviated name of the month.
    String toWideStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.standalone.wide[this.index - 1];
    /// Returns the standalone, locale-sensitive abbreviated name of the month. If the locale doesn't contain this info, returns [null].
    String? toShortStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.standalone.short?.elementAt(this.index - 1);
}

enum Weekday {
    skip,
    Sunday,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
}

enum WeekdayISO {
    skip,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
    Sunday,
}

extension WeekdayExtension on Weekday {
    operator <(Weekday other) => this.index < other.index;
    operator <=(Weekday other) => this.index <= other.index;
    operator >(Weekday other) => this.index > other.index;
    operator >=(Weekday other) => this.index >= other.index;

    Weekday operator +(Weekday other) {
        if (other == Weekday.skip) throw InvalidArgumentException('other');
        final index = (this.index + other.index) % 7;
        return Weekday.values[index == Weekday.skip ? 1 : index];
    }

    Weekday operator -(Weekday other) {
        if (other == Weekday.skip) throw InvalidArgumentException('other');
        final index = (this.index - other.index) % 7;
        return Weekday.values[index == Weekday.skip ? 7 : index];
    }

    /// Returns the ISO expression of the same weekday.
    WeekdayISO toISO() {
        if (this == Weekday.skip) return WeekdayISO.skip;
        else if (this == Weekday.Sunday) return WeekdayISO.Sunday;
        else return WeekdayISO.values[this.index - 1];
    }

    /// Returns the locale-sensitive abbreviated name of the weekday.
    String toAbbr([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.abbreviated[this.index - 1];
    /// Returns the locale-sensitive narrow name of the weekday.
    String toNarrow([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.narrow[this.index - 1];
    /// Returns the locale-sensitive abbreviated name of the weekday.
    String toWide([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.wide[this.index - 1];
    /// Returns the locale-sensitive abbreviated name of the weekday. If the locale doesn't contain this info, returns [null].
    String? toShort([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.short?.elementAt(this.index - 1);
    /// Returns the standalone, locale-sensitive abbreviated name of the weekday.
    String toAbbrStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.abbreviated[this.index - 1];
    /// Returns the standalone, locale-sensitive narrow name of the weekday.
    String toNarrowStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.narrow[this.index - 1];
    /// Returns the standalone, locale-sensitive abbreviated name of the weekday.
    String toWideStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.wide[this.index - 1];
    /// Returns the standalone, locale-sensitive abbreviated name of the weekday. If the locale doesn't contain this info, returns [null].
    String? toShortStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.short?.elementAt(this.index - 1);
}

extension WeekdayISOExtension on WeekdayISO {
    operator <(WeekdayISO other) => this.index < other.index;
    operator <=(WeekdayISO other) => this.index <= other.index;
    operator >(WeekdayISO other) => this.index > other.index;
    operator >=(WeekdayISO other) => this.index >= other.index;

    WeekdayISO operator +(WeekdayISO other) {
        if (other == WeekdayISO.skip) throw InvalidArgumentException('other');
        final index = (this.index + other.index) % 7;
        return WeekdayISO.values[index == WeekdayISO.skip ? 1 : index];
    }

    WeekdayISO operator -(WeekdayISO other) {
        if (other == WeekdayISO.skip) throw InvalidArgumentException('other');
        final index = (this.index - other.index) % 7;
        return WeekdayISO.values[index == WeekdayISO.skip ? 7 : index];
    }

    /// Returns the default [Weekday] representation, where the week starts on Sunday.
    Weekday toDefault() {
        if (this == WeekdayISO.skip) return Weekday.skip;
        else if (this == WeekdayISO.Sunday) return Weekday.Sunday;
        else return Weekday.values[this.index + 1];
    }

    /// Returns the locale-sensitive abbreviated name of the weekday.
    String toAbbr([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.abbreviated[this.toDefault().index - 1];
    /// Returns the locale-sensitive narrow name of the weekday.
    String toNarrow([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.narrow[this.toDefault().index - 1];
    /// Returns the locale-sensitive abbreviated name of the weekday.
    String toWide([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.wide[this.toDefault().index - 1];
    /// Returns the locale-sensitive abbreviated name of the weekday. If the locale doesn't contain this info, returns [null].
    String? toShort([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.short?.elementAt(this.toDefault().index - 1);
    /// Returns the standalone, locale-sensitive abbreviated name of the weekday.
    String toAbbrStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.abbreviated[this.toDefault().index - 1];
    /// Returns the standalone, locale-sensitive narrow name of the weekday.
    String toNarrowStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.narrow[this.toDefault().index - 1];
    /// Returns the standalone, locale-sensitive abbreviated name of the weekday.
    String toWideStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.wide[this.toDefault().index - 1];
    /// Returns the standalone, locale-sensitive abbreviated name of the weekday. If the locale doesn't contain this info, returns [null].
    String? toShortStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.short?.elementAt(this.toDefault().index - 1);
}

Map<Timestamp, GregorianCalendarComponents> _componentsCache = {};

extension GregorianCalendarExtension on Timestamp {
    void _cacheComponent() => _componentsCache.containsKey(this) ? null : _componentsCache[this] = GregorianCalendarComponents.fromTimestamp(this);

    GregorianCalendarComponents get _components {
        _cacheComponent();
        return _componentsCache[this];
    }

    /// Returns the era.
    Era get era => year >= 1 ? Era.AD : Era.BC;
    /// Returns the year.
    int get year => _components.year;
    /// Returns the year of era.
    int get yearOfEra => year >= 1 ? year : year.abs() + 1;
    /// Returns the Month.
    Month get month => _components.month;
    /// Returns the day.
    int get day => _components.day;

    /// Returns the weekday.
    Weekday get weekday => Weekday.values[(daysSinceEpoch(year, month, day) + 4) % 7 + 1];
    /// Returns the ISO weekday.
    WeekdayISO get weekdayISO => WeekdayISO.values[(daysSinceEpoch(year, month, day) + 3) % 7 + 1];

    /// Returns the quarter.
    Quarter get quarter => Quarter.values[(month.index - 1) ~ 3 + 1];

    /// Returns the fixed day period (AM/PM).
    FixedDayPeriod get fixedDayPeriod => hour < 12 ? FixedDayPeriod.AM : FixedDayPeriod.PM;
    /// Returns the day period. This is a locale-dependent getter. Currently the locale defaults to [currLocale], but we expect this to change.
    DayPeriod get dayPeriod {
        final minutesSinceMidnight = hour * minutesPerHour + minute;
        return currLocale.dayPeriodsRule.keys.firstWhere((dayPeriod) => currLocale.dayPeriodsRule[dayPeriod].contains(minutesSinceMidnight));
    }

    /// Returns the week number of year according to the ISO8601 standard.
    int get weekOfYearISO {
        final isCurrLeapYear = isLeapYear(year);
        final isPrevLeapYear = isLeapYear(year - 1);

        final dayOfYearNumber = isCurrLeapYear && month.index > 2 ? dayOfYear + 1 : dayOfYear;
        final jan1Weekday = startOf(Length.YEAR).weekdayISO;
        final currWeekday = weekdayISO;

        var weekNumber;
        if (dayOfYearNumber <= (8 - jan1Weekday.index) && jan1Weekday > WeekdayISO.Thursday) {
            if (jan1Weekday == WeekdayISO.Friday || jan1Weekday == WeekdayISO.Saturday && isPrevLeapYear) weekNumber = 53;
            else weekNumber = 52;
        } else if (daysPerYear(year) - dayOfYearNumber < 4 - currWeekday.index) weekNumber = 1;
        else {
            final j = dayOfYearNumber + (7 - currWeekday.index) + (jan1Weekday.index - 1);
            weekNumber = j / 7;
            if (jan1Weekday.index > 4) weekNumber -= 1;
        }

        return weekNumber;
    }

    /// Returns the week year number according to the ISO8601 standard.
    int get weekYearISO {
        final isCurrLeapYear = isLeapYear(year);

        final dayOfYearNumber = isCurrLeapYear && month.index > 2 ? dayOfYear + 1 : dayOfYear;
        final jan1Weekday = startOf(Length.YEAR).weekdayISO;
        final currWeekday = weekdayISO;

        int weekYear;
        if (dayOfYearNumber <= 8 - jan1Weekday.index && jan1Weekday.index > 4) weekYear = year - 1;
        else if (daysPerYear(year) - dayOfYearNumber < 4 - currWeekday.index) weekYear = year + 1;
        else weekYear = year;

        return weekYear;
    }

    /// Return a [Timestamp] at the start of [unit].
    Timestamp startOf(Length unit) {
        return GregorianCalendar().fromComponents(
            timezone,
            unit >= Length.YEAR ? 0 : year,
            unit >= Length.MONTH ? Month.January : month,
            unit >= Length.DAY ? 0 : day,
            unit >= Length.HOUR ? 0 : hour,
            unit >= Length.MINUTE ? 0 : minute,
            unit >= Length.SECOND ? 0 : second,
            unit >= Length.MILLISECOND ? 0 : millisecond,
            unit >= Length.MICROSECOND ? 0 : microsecond,
        );
    }

    /// Return a [Timestamp] at the end of [unit]. TODO: Implement
    Timestamp endOf(Length unit) {
        return GregorianCalendar().fromComponents(
            timezone,
            unit >= Length.YEAR ? 0 : year,
            unit >= Length.MONTH ? Month.January : month,
            unit >= Length.DAY ? 0 : day,
            unit >= Length.HOUR ? 0 : hour,
            unit >= Length.MINUTE ? 0 : minute,
            unit >= Length.SECOND ? 0 : second,
            unit >= Length.MILLISECOND ? 0 : millisecond,
            unit >= Length.MICROSECOND ? 0 : microsecond,
        );
    }

    /// Returns the number of days since the beginning of the year.
    int get dayOfYear => IterableRange<int>(1, month.index, (i) => i++).fold(0, (counter, month) => counter += daysPerMonth(Month.values[month], year)) + day;
}

/// A struct that holds the components specific to Gregorian calendars: [year], [month], and [day].
class GregorianCalendarComponents {
    final int year;
    final Month month;
    final int day;

    const GregorianCalendarComponents({
        required this.year,
        required this.month,
        required this.day,
    });

    /// Create a [GregorianCalendarComponents] from a given [Timestamp]. This is the recommended way to initialize a [GregorianCalendarComponents].
    factory GregorianCalendarComponents.fromTimestamp(Timestamp ts) {
        /// This is the timezoned microsecond timestamp of [ts]. For instance, if a region has offset +01:00, the utc microsecondsSinceEpoch is `500`,
        /// then this variable is `500 + 1 * microsecondsPerHour`.
        final microsecondsSinceEpoch = ts.instant.microSecondsSinceEpoch() + ts.timezone.offset(ts.instant.microSecondsSinceEpoch()).asMicroseconds();
        final microsecondsSinceInternalEpoch = microsecondsSinceEpoch + -(ts.timezone.possibleOffsets[ts.timezone.history.firstWhere((his) => his.until >= microsecondsSinceEpoch).index] * microsecondsPerMinute).truncate();
        final daysSinceEpoch = microsecondsSinceInternalEpoch ~/ microsecondsPerDay;

        /// Turns epoch to `Mar 1st, 0000`.
        final daysSinceInternalEpoch = daysSinceEpoch + 719468;
        final era = (daysSinceInternalEpoch >= 0 ? daysSinceInternalEpoch : daysSinceInternalEpoch - 146096) ~/ 146097;
        final dayOfEra = daysSinceInternalEpoch - era * 146097;
        final yearOfEra = (dayOfEra - dayOfEra ~/ 1460 + dayOfEra ~/ 36524 - dayOfEra ~/ 146096) ~/ 365;

        final dayOfYear = dayOfEra - (365 * yearOfEra + yearOfEra ~/ 4 - yearOfEra ~/ 100);
        final internalMonth = (5 * dayOfYear + 2) ~/ 153;
        final finalMonth  = internalMonth + (internalMonth < 10 ? 3 : -9);
        final finalDay = dayOfYear - (153 * internalMonth + 2) ~/ 5 + 1;
        final finalYear = yearOfEra + era * 400;

        return GregorianCalendarComponents(
            year: finalYear,
            month: Month.values[finalMonth],
            day: finalDay,
        );
    }
}

/// Returns whether [year] is a leap year.
bool isLeapYear(int year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
}

/// Returns the number of days since the epoch corresponding to the given [year], [month], and [day].
int daysSinceEpoch(int year, Month month, int day) {
    if (month == Month.skip) throw InvalidArgumentException('month');
    if (day <= 0 || day > daysPerMonth(month, year)) throw InvalidArgumentException('day');

    if (month.index <= 2) year--; // Converts year to the internal year numbering which starts from March.
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
int _dayOfInternalYear(Month month, int day) {
    return ((153 * (month.index + (month.index > 2 ? -3 : 9)) + 2) / 5 + day - 1).toInt();
}

final int daysPerLeapYear = Month.values.skip(0).fold(0, (count, month) => count += daysPerMonth(month, leapYearsSinceEpoch().first));
final int daysPerNonLeapYear = Month.values.skip(0).fold(0, (count, month) => count += daysPerMonth(month, nonLeapYearsSinceEpoch().first));

final int microsecondsPerLeapYear = microsecondsPerDay * daysPerLeapYear;
final int microsecondsPerNonLeapYear = microsecondsPerDay * daysPerNonLeapYear;


/// Returns the number of days in [year].
int daysPerYear(int year) => isLeapYear(year) ? daysPerLeapYear : daysPerNonLeapYear;

int microsecondsInMonth(Month month, int year) {
    if (month == Month.skip) throw InvalidArgumentException('month');

    return microsecondsPerDay * daysPerMonth(month, year);
}

int microsecondsPerYear(int year) => isLeapYear(year) ? microsecondsPerLeapYear : microsecondsPerNonLeapYear;


/// Returns the number of days in [month] of [year].
int daysPerMonth(Month month, int year) {
    const MONTHS_WITH_31_DAYS = [Month.January, Month.March, Month.May, Month.July, Month.August, Month.October, Month.December];
    const MONTHS_WITH_30_DAYS = [Month.April, Month.June, Month.September, Month.November];

    if (month == Month.skip) throw InvalidArgumentException('month');

    if (MONTHS_WITH_31_DAYS.contains(month)) return 31;
    else if (MONTHS_WITH_30_DAYS.contains(month)) return 30;
    else if (isLeapYear(year)) return 29;
    else return 28;
}

/// Returns an iterable of leap years since epoch. This is an infinite list so don't *ever* try to convert it to a [List].
Iterable<int> leapYearsSinceEpoch() sync* {
    int currYear = Timestamp.epochUTC().year;
    while (true) if (isLeapYear(currYear)) yield currYear++;
}

/// Returns an iterable of non leap years since epoch. This is an infinite list so don't *ever* try to convert it to a [List].
Iterable<int> nonLeapYearsSinceEpoch() sync* {
    int currYear = Timestamp.epochUTC().year;
    while (true) if (!isLeapYear(currYear)) yield currYear++;
}