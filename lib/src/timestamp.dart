import 'package:datex/src/instant.dart';
import 'package:datex/src/interval.dart';
import 'package:datex/src/timezone.dart';
import 'package:datex/src/util.dart';
import 'package:datex/src/utils/exception.dart';
import 'package:datex/src/utils/system_util.dart';
import 'package:datex/src/utils/units.dart';

/// A timezone-aware instant. This is simply a container for a [TimeZone] and an [Instant] object, but provides most utility
/// methods you will find for DateTime objects in other datetime libraries.
class Timestamp {
    final TimeZone timezone;
    final Instant instant;
    /// Figuring out the components of the timestamp is a nontrivial amount of calculation, so we defer the calculation
    /// until absolutely necessary, that is, when some function that requires the calculation is called.
    TimestampComponents _components = null;

    Timestamp(this.timezone, this.instant, [this._components]);

    /// Returns a Timestamp set to present with the `Etc/UTC` timezone.
    factory Timestamp.nowUTC() => Timestamp(TimeZone.utc(), Instant.now());

    /// Returns a Timestamp set to present with the local timezone (as given by [TimeZone.local]). See that method
    /// for more precise definition on what is the local timezone.
    factory Timestamp.nowLocal() => Timestamp(TimeZone.local(), Instant.now());

    /// Returns a timestamp representing [i] in the `Etf/UTC` timezone. Wrapper around `i.toTimestampUTC`.
    factory Timestamp.fromInstantUTC(Instant i) => i.toTimestampUTC();

    /// Returns a timestamp representing [i] in the local timezone. Wrapper around `i.toTimestampLocal`.
    factory Timestamp.fromInstantLocal(Instant i) => i.toTimestampLocal();

    /// Returns a timestamp from the explicitly provided timezone and timestamp components.
    ///
    /// Note: In certain cases a given TimestampComponents and a timezone alone do not suffice to determine an unique instant.
    /// In this case [AmbiguousTimestampException] will be thrown. Othertimes the components are valid but the time actually
    /// doesn't exist, in which case [TimestampNonexistentException] will be thrown.
    factory Timestamp.explicit(TimeZone timezone, int year, int month, int day, [int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]) {
        if (timezone == null) return error(InvalidArgumentException('timezone'));
        else if (year < 0) return error(InvalidArgumentException('year'));
        else if (month <= 0 || month > 12) return error(InvalidArgumentException('month'));
        else if (day <= 0 || day > daysPerMonth(month, year)) return error(InvalidArgumentException('day'));
        else if (hour < 0 || hour > 23) return error(InvalidArgumentException('hour'));
        else if (minute < 0 || minute > 59) return error(InvalidArgumentException('minute'));
        else if (second < 0 || second > 59) return error(InvalidArgumentException('second'));
        else if (millisecond < 0 || millisecond > 999) return error(InvalidArgumentException('millisecond'));
        else if (microsecond < 0 || microsecond > 999) return error(InvalidArgumentException('microsecond'));

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
        if (surmisedOffsetInMicroseconds1 != surmisedOffsetInMicroseconds2) return error(TimestampNonexistentException("FUCKed"));

        final surmisedHistory2Index = timezone.history.indexOf(surmisedHistory2);
        if (surmisedHistory2Index > 0) {
            final surmisedHistory3 = timezone.history[surmisedHistory2Index - 1];
            final surmisedOffsetInMicroseconds3 = (timezone.possibleOffsets[surmisedHistory3.index] * microsecondsPerMinute).truncate();
            final surmisedMicrosecondsSinceEpochUTC2 = surmisedMicrosecondsSinceEpochOffseted + surmisedOffsetInMicroseconds3;

            final surmisedHistory4 = timezone.history.firstWhere((item) => item.until >= surmisedMicrosecondsSinceEpochUTC2);
            final surmisedOffsetInMicroseconds4 = (timezone.possibleOffsets[surmisedHistory4.index] * microsecondsPerMinute).truncate();
            if (surmisedOffsetInMicroseconds3 == surmisedOffsetInMicroseconds4) return error(AmbiguousTimestampException("FUCKed"));
        }

        if (surmisedHistory2Index < timezone.history.length - 1) {
            final surmisedHistory5 = timezone.history[surmisedHistory2Index + 1];
            final surmisedOffsetInMicroseconds5 = (timezone.possibleOffsets[surmisedHistory5.index] * microsecondsPerMinute).truncate();
            final surmisedMicrosecondsSinceEpochUTC3 = surmisedMicrosecondsSinceEpochOffseted + surmisedOffsetInMicroseconds5;

            final surmisedHistory6 = timezone.history.firstWhere((item) => item.until >= surmisedMicrosecondsSinceEpochUTC3);
            final surmisedOffsetInMicroseconds6 = (timezone.possibleOffsets[surmisedHistory6.index] * microsecondsPerMinute).truncate();
            if (surmisedOffsetInMicroseconds5 == surmisedOffsetInMicroseconds6) return error(AmbiguousTimestampException("FUCKed"));
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
        if (_components == null) _findComponents();
        return _components;
    }

    /// Returns the [year] element in the [TimestampComponents] of the [Timestamp].
    int get year => components.year;

    /// Returns the [month] element in the [TimestampComponents] of the [Timestamp].
    Month get month => Month.values[components.month];

    /// Returns the [day] element in the [TimestampComponents] of the [Timestamp].
    int get day => components.day;

    /// Returns the [minute] element in the [TimestampComponents] of the [Timestamp].
    int get minute => components.minute;

    /// Returns the [second] element in the [TimestampComponents] of the [Timestamp].
    int get second => components.second;

    /// Returns the [millisecond] element in the [TimestampComponents] of the [Timestamp].
    int get millisecond => components.millisecond;

    /// Returns the [microsecond] element in the [TimestampComponents] of the [Timestamp].
    int get microsecond => components.microsecond;

    /// Returns the corresponding [weekday] of the [Timestamp].
    Weekday get weekday => Weekday.values[(daysSinceEpoch(components.year, components.month, components.day) + 3) % 7 + 1];

    /// Return a [Timestamp] at the start of [unit].
    Timestamp startOf(TimeUnit unit) {
        if (unit == null) return error(InvalidArgumentException('unit'));

        return Timestamp.explicit(
            timezone,
            unit >= TimeUnit.YEAR ? 0 : this.components.year,
            unit >= TimeUnit.MONTH ? 0 : this.components.month,
            unit >= TimeUnit.DAY ? 0 : this.components.day,
            unit >= TimeUnit.HOUR ? 0 : this.components.hour,
            unit >= TimeUnit.MINUTE ? 0 : this.components.minute,
            unit >= TimeUnit.SECOND ? 0 : this.components.second,
            unit >= TimeUnit.MILLISECOND ? 0 : this.components.millisecond,
            unit >= TimeUnit.MICROSECOND ? 0 : this.components.microsecond,
        );
    }

    /// Return a [Timestamp] at the end of [unit].
    Timestamp endOf(TimeUnit unit) {
        if (unit == null) return error(InvalidArgumentException('unit'));

        return Timestamp.explicit(
            timezone,
            unit >= TimeUnit.YEAR ? 0 : this.components.year,
            unit >= TimeUnit.MONTH ? 0 : this.components.month,
            unit >= TimeUnit.DAY ? 0 : this.components.day,
            unit >= TimeUnit.HOUR ? 0 : this.components.hour,
            unit >= TimeUnit.MINUTE ? 0 : this.components.minute,
            unit >= TimeUnit.SECOND ? 0 : this.components.second,
            unit >= TimeUnit.MILLISECOND ? 0 : this.components.millisecond,
            unit >= TimeUnit.MICROSECOND ? 0 : this.components.microsecond,
        );
    }

    @override bool operator ==(covariant Timestamp other) => this.timezone == other.timezone && this.instant == other.instant;
    Timestamp operator +(Interval dur) => Timestamp(this.timezone, this.instant + dur);
    Timestamp operator -(Interval dur) => Timestamp(this.timezone, this.instant - dur);

    void _findComponents() => _components ??= TimestampComponents.fromTimestamp(this);
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
        this.year,
        this.month,
        this.day,
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
        final microsecondsSinceEpoch = ts.instant.microSecondsSinceEpoch() + (ts.timezone.offset(ts.instant.microSecondsSinceEpoch()) * microsecondsPerMinute).truncate();
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