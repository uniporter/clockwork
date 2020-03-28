import '../format/formattable.dart';
import '../units/unit.dart';
import 'instant.dart';
import 'interval.dart';
import 'timezone.dart';

/// A timezone-aware instant. This is simply a container for a [TimeZone] and an [Instant] object, but provides most utility
/// methods you will find for [DateTime] objects in other datetime libraries.
///
/// By default, [Timestamp] comes equipped with support for the Gregorian Calendar. This is hard-coded and cannot be removed. To add more calendar
/// supports for [Timestamp], simply define an extension on [Timestamp], but make sure that no naming conflicts occur.
class Timestamp with Formattable {
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
    Timestamp switchTimeZone(TimeZone newZone) => instant.toTimestamp(newZone);

    /// Returns `this + dur`. Wrapper for the [+] operator.
    Timestamp add(Interval dur) => this + dur;

    /// Returns `this - dur`. Wrapper for the [-] operator.
    Timestamp subtract(Interval dur) => this - dur;

    /// Returns the difference between the underlying instant of the two timestamps.
    Interval difference(Timestamp other) => instant.difference(other.instant);

    int get zonedMicrosecondsSinceEpoch => instant.microsecondsSinceEpoch() + timezone.offset(instant.microsecondsSinceEpoch()).asMicroseconds();

    /// Returns the hour.
    Hour get hour => Hour((zonedMicrosecondsSinceEpoch % Day.microsecondsPer) ~/ Hour.microsecondsPer);
    /// Returns the minute.
    Minute get minute => Minute((zonedMicrosecondsSinceEpoch % Hour.microsecondsPer) ~/ Minute.microsecondsPer);
    /// Returns the second.
    Second get second => Second((zonedMicrosecondsSinceEpoch % Minute.microsecondsPer) ~/ Second.microsecondsPer);
    /// Returns the millisecond.
    Millisecond get millisecond => Millisecond((zonedMicrosecondsSinceEpoch % Second.microsecondsPer) ~/ Millisecond.microsecondsPer);
    /// Returns the microsecond.
    Microsecond get microsecond => Microsecond(zonedMicrosecondsSinceEpoch % Millisecond.microsecondsPer);

    @override bool operator ==(covariant Timestamp other) => timezone == other.timezone && instant == other.instant;
    @override int get hashCode => (timezone.hashCode ~/ 2) + (instant.hashCode ~/ 2);
    Timestamp operator +(Interval dur) => Timestamp(timezone, instant + dur);
    Timestamp operator -(Interval dur) => Timestamp(timezone, instant - dur);
}
