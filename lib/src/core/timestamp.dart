import 'package:clockwork/src/format/format.dart';
import 'package:clockwork/src/format/formattable.dart';
import 'package:clockwork/src/core/instant.dart';
import 'package:clockwork/src/core/interval.dart';
import 'package:clockwork/src/core/timezone.dart';
import 'package:clockwork/src/units/conversion.dart';
import 'package:clockwork/src/units/era.dart';
import 'package:clockwork/src/units/length.dart';
import 'package:clockwork/src/units/month.dart';
import 'package:clockwork/src/units/weekday.dart';
import 'package:clockwork/src/utils/exception.dart';
import 'package:clockwork/src/utils/misc.dart';
import 'package:clockwork/src/utils/system_util.dart';

/// A timezone-aware instant. This is simply a container for a [TimeZone] and an [Instant] object, but provides most utility
/// methods you will find for DateTime objects in other datetime libraries.
class Timestamp with IFormattable {
    final TimeZone timezone;
    final Instant instant;

    /// Figuring out the components of the timestamp is a nontrivial amount of calculation, so we defer the calculation
    /// until absolutely necessary, that is, when some function that requires the calculation is called.
    late final TimestampComponents _components;

    bool _componentsInitialized = false;

    Timestamp(this.timezone, this.instant, [TimestampComponents? components]) {
        if (components != null) {
            _components = components;
            _componentsInitialized = true;
        }
    }

    /// Returns a Timestamp set to present with the `Etc/UTC` timezone.
    Timestamp.nowUTC() : timezone = TimeZone.utc(), instant = Instant.now();

    /// Returns a Timestamp set to present with the local timezone (as given by [TimeZone.local]). See that method
    /// for more precise definition on what is the local timezone.
    Timestamp.nowLocal() : timezone = TimeZone.local(), instant = Instant.now();

    /// Returns a timestamp representing [i] in the `Etf/UTC` timezone.
    Timestamp.fromInstantUTC(Instant i) : timezone = TimeZone.utc(), instant = i;

    /// Returns a timestamp representing [i] in the local timezone.
    Timestamp.fromInstantLocal(Instant i) : timezone = TimeZone.local(), instant = i;

    /// Returns a timestamp from the explicitly provided timezone and timestamp components.
    ///
    /// Note: In certain cases a given TimestampComponents and a timezone alone do not suffice to determine an unique instant.
    /// In this case [AmbiguousTimestampException] will be thrown. Othertimes the components are valid but the time actually
    /// doesn't exist, in which case [TimestampNonexistentException] will be thrown.
    factory Timestamp.explicit(TimeZone timezone, int year, int month, int day, [int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]) {
        if (timezone == null) throw InvalidArgumentException('timezone');
        else if (year < 0) throw InvalidArgumentException('year');
        else if (month <= 0 || month > 12) throw InvalidArgumentException('month');
        else if (day <= 0 || day > daysPerMonth(month, year)) throw InvalidArgumentException('day');
        else if (hour < 0 || hour > 23) throw InvalidArgumentException('hour');
        else if (minute < 0 || minute > 59) throw InvalidArgumentException('minute');
        else if (second < 0 || second > 59) throw InvalidArgumentException('second');
        else if (millisecond < 0 || millisecond > 999) throw InvalidArgumentException('millisecond');
        else if (microsecond < 0 || microsecond > 999) throw InvalidArgumentException('microsecond');

        final surmisedComponents = TimestampComponents(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            millisecond: millisecond,
            microsecond: microsecond,
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

        return Timestamp(
            timezone,
            Instant(surmisedMicrosecondsSinceEpochUTC),
            surmisedComponents,
        );
    }

    /// Returns a new [Timestamp] of the same instant but in [newZone].
    Timestamp switchTimeZone(TimeZone newZone) => this.instant.toTimestamp(newZone);

    /// Returns `this + dur`. Wrapper for the [+] operator.
    Timestamp add(Interval dur) => this + dur;

    /// Returns `this - dur`. Wrapper for the [-] operator.
    Timestamp subtract(Interval dur) => this - dur;

    /// Returns the difference between the underlying instant of the two timestamps.
    Interval difference(Timestamp other) => this.instant.difference(other.instant);

    TimestampComponents get components {
        if (!_componentsInitialized) _components = TimestampComponents.fromTimestamp(this);
        return _components;
    }

    /// Returns the era.
    Era get era => components.year >= 1 ? Era.AD : Era.BC;

    /// Returns the year.
    int get year => components.year;

    /// Returns the year of era.
    int get yearOfEra => components.year >= 1 ? components.year : components.year.abs() + 1;

    /// Returns the month.
    Month get month => Month.values[components.month];

    int get day => components.day;
    int get hour => components.hour;
    int get minute => components.minute;
    int get second => components.second;
    int get millisecond => components.millisecond;
    int get microsecond => components.microsecond;

    /// Returns the corresponding weekday of the [Timestamp].
    Weekday get weekday => Weekday.values[(daysSinceEpoch(components.year, components.month, components.day) + 4) % 7 + 1];

    /// Returns the corresponding ISO weekday of the [Timestamp].
    WeekdayISO get weekdayISO => WeekdayISO.values[(daysSinceEpoch(components.year, components.month, components.day) + 3) % 7 + 1];

    /// Returns the corresponding quarter of the [Timestamp].
    int get quarter => (components.month - 1) ~/ 3 + 1;

    /// Returns the number of days since the beginning of the year.
    int get dayOfYear => range(1, components.month).fold(0, (counter, month) => counter += daysPerMonth(components.month, components.year)) + components.day;

    /// Returns the week number of year according to the ISO8601 standard.
    int get weekOfYearISO {
        final isCurrLeapYear = isLeapYear(components.year);
        final isPrevLeapYear = isLeapYear(components.year - 1);

        final dayOfYearNumber = isCurrLeapYear && components.month > 2 ? dayOfYear + 1 : dayOfYear;
        final jan1Weekday = startOf(Length.YEAR).weekdayISO;
        final currWeekday = weekdayISO;

        var weekNumber;
        if (dayOfYearNumber <= (8 - jan1Weekday.index) && jan1Weekday > WeekdayISO.Thursday) {
            if (jan1Weekday == WeekdayISO.Friday || jan1Weekday == WeekdayISO.Saturday && isPrevLeapYear) weekNumber = 53;
            else weekNumber = 52;
        } else if (daysPerYear(components.year) - dayOfYearNumber < 4 - currWeekday.index) weekNumber = 1;
        else {
            final j = dayOfYearNumber + (7 - currWeekday.index) + (jan1Weekday.index - 1);
            weekNumber = j / 7;
            if (jan1Weekday.index > 4) weekNumber -= 1;
        }

        return weekNumber;
    }

    /// Returns the week year number according to the ISO8601 standard.
    int get weekYearISO {
        final isCurrLeapYear = isLeapYear(components.year);

        final dayOfYearNumber = isCurrLeapYear && components.month > 2 ? dayOfYear + 1 : dayOfYear;
        final jan1Weekday = startOf(Length.YEAR).weekdayISO;
        final currWeekday = weekdayISO;

        int weekYear;
        if (dayOfYearNumber <= 8 - jan1Weekday.index && jan1Weekday.index > 4) weekYear = components.year - 1;
        else if (daysPerYear(components.year) - dayOfYearNumber < 4 - currWeekday.index) weekYear = components.year + 1;
        else weekYear = components.year;

        return weekYear;
    }

    /// Returns whether the [Timestamp] is in AM or PM.
    bool get isPM => components.hour >= 12;

    /// Return a [Timestamp] at the start of [unit].
    Timestamp startOf(Length unit) {
        return Timestamp.explicit(
            timezone,
            unit >= Length.YEAR ? 0 : this.components.year,
            unit >= Length.MONTH ? 0 : this.components.month,
            unit >= Length.DAY ? 0 : this.components.day,
            unit >= Length.HOUR ? 0 : this.components.hour,
            unit >= Length.MINUTE ? 0 : this.components.minute,
            unit >= Length.SECOND ? 0 : this.components.second,
            unit >= Length.MILLISECOND ? 0 : this.components.millisecond,
            unit >= Length.MICROSECOND ? 0 : this.components.microsecond,
        );
    }

    /// Return a [Timestamp] at the end of [unit].
    Timestamp endOf(Length unit) {
        return Timestamp.explicit(
            timezone,
            unit >= Length.YEAR ? 0 : this.components.year,
            unit >= Length.MONTH ? 0 : this.components.month,
            unit >= Length.DAY ? 0 : this.components.day,
            unit >= Length.HOUR ? 0 : this.components.hour,
            unit >= Length.MINUTE ? 0 : this.components.minute,
            unit >= Length.SECOND ? 0 : this.components.second,
            unit >= Length.MILLISECOND ? 0 : this.components.millisecond,
            unit >= Length.MICROSECOND ? 0 : this.components.microsecond,
        );
    }

    /// Returns a ISO8601 standard description of the [Timestamp].
    String formatISO() => format(Format.ISO8601);

    @override String toString() => formatISO();

    @override bool operator ==(covariant Timestamp other) => this.timezone == other.timezone && this.instant == other.instant;
    Timestamp operator +(Interval dur) => Timestamp(this.timezone, this.instant + dur);
    Timestamp operator -(Interval dur) => Timestamp(this.timezone, this.instant - dur);
}

/// A struct that holds explicit information for the calendar composition of a [Timestamp].
class TimestampComponents {
    final int year;
    final int month;
    final int day;
    final int hour;
    final int minute;
    final int second;
    final int millisecond;
    final int microsecond;

    const TimestampComponents({
        required this.year,
        required this.month,
        required this.day,
        this.hour = 0,
        this.minute = 0,
        this.second = 0,
        this.millisecond = 0,
        this.microsecond = 0,
    });

    /// Create a [TimestampComponents] from a given [Timestamp]. This is the recommended way to initialize a [TimestampComponents].
    factory TimestampComponents.fromTimestamp(Timestamp ts) {
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

        /// Now we figure out the other units.
        final finalHour = (microsecondsSinceEpoch % microsecondsPerDay) ~/ microsecondsPerHour;
        final finalMinute = (microsecondsSinceEpoch % microsecondsPerHour) ~/ microsecondsPerMinute;
        final finalSecond = (microsecondsSinceEpoch % microsecondsPerMinute) ~/ microsecondsPerSecond;
        final finalMillisecond = (microsecondsSinceEpoch % microsecondsPerSecond) ~/ microsecondsPerMillisecond;
        final finalMicrosecond = microsecondsSinceEpoch % microsecondsPerMillisecond;

        return TimestampComponents(
            year: finalYear,
            month: finalMonth,
            day: finalDay,
            hour: finalHour,
            minute: finalMinute,
            second: finalSecond,
            millisecond: finalMillisecond,
            microsecond: finalMicrosecond,
        );
    }
}