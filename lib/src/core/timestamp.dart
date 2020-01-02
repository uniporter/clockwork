import 'package:clockwork/src/core/instant.dart';
import 'package:clockwork/src/core/interval.dart';
import 'package:clockwork/src/core/timezone.dart';
import 'package:clockwork/src/format/format.dart';
import 'package:clockwork/src/format/formattable.dart';
import 'package:clockwork/src/units/conversion.dart';

/// A timezone-aware instant. This is simply a container for a [TimeZone] and an [Instant] object, but provides most utility
/// methods you will find for DateTime objects in other datetime libraries.
///
/// By default, [Timestamp] comes equipped with support for the Gregorian Calendar. This is hard-coded and cannot be removed. To add more calendar
/// supports for [Timestamp], simply define an extension on [Timestamp], but make sure no naming conflicts occur.
class Timestamp with IFormattable {
    final TimeZone timezone;
    final Instant instant;

    const Timestamp(this.timezone, this.instant);

    /// Returns a Timestamp set to present with the `Etc/UTC` timezone.
    Timestamp.nowUTC() : timezone = TimeZone.utc(), instant = Instant.now();

    /// Returns a Timestamp set to present with the local timezone (as given by [TimeZone.local]). See that method
    /// for more precise definition on what is the local timezone.
    Timestamp.nowLocal() : timezone = TimeZone.local(), instant = Instant.now();

    /// Returns a timestamp representing [i] in the `Etf/UTC` timezone.
    Timestamp.fromInstantUTC(Instant i) : timezone = TimeZone.utc(), instant = i;

    /// Returns a timestamp representing [i] in the local timezone.
    Timestamp.fromInstantLocal(Instant i) : timezone = TimeZone.local(), instant = i;

    /// Returns the epoch time in UTC timezone.
    Timestamp.epochUTC() : timezone = TimeZone.utc(), instant = Instant.epoch();

    /// Returns a new [Timestamp] of the same instant but in [newZone].
    Timestamp switchTimeZone(TimeZone newZone) => this.instant.toTimestamp(newZone);

    /// Returns `this + dur`. Wrapper for the [+] operator.
    Timestamp add(Interval dur) => this + dur;

    /// Returns `this - dur`. Wrapper for the [-] operator.
    Timestamp subtract(Interval dur) => this - dur;

    /// Returns the difference between the underlying instant of the two timestamps.
    Interval difference(Timestamp other) => this.instant.difference(other.instant);


    int get zonedMicrosecondsSinceEpoch => instant.microSecondsSinceEpoch() + timezone.offset(instant.microSecondsSinceEpoch()).asMicroseconds();

    /// Returns the hour.
    int get hour => (zonedMicrosecondsSinceEpoch % microsecondsPerDay) ~/ microsecondsPerHour;
    /// Returns the minute.
    int get minute => (zonedMicrosecondsSinceEpoch % microsecondsPerHour) ~/ microsecondsPerMinute;
    /// Returns the second.
    int get second => (zonedMicrosecondsSinceEpoch % microsecondsPerMinute) ~/ microsecondsPerSecond;
    /// Returns the millisecond.
    int get millisecond => (zonedMicrosecondsSinceEpoch % microsecondsPerSecond) ~/ microsecondsPerMillisecond;
    /// Returns the microsecond.
    int get microsecond => zonedMicrosecondsSinceEpoch % microsecondsPerMillisecond;

    /// Returns a ISO8601 standard description of the [Timestamp].
    String formatISO() => format(TimestampFormats.ISO8601);

    @override String toString() => formatISO();

    @override bool operator ==(covariant Timestamp other) => this.timezone == other.timezone && this.instant == other.instant;
    Timestamp operator +(Interval dur) => Timestamp(this.timezone, this.instant + dur);
    Timestamp operator -(Interval dur) => Timestamp(this.timezone, this.instant - dur);
}
