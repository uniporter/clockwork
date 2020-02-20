import 'clock.dart';
import 'interval.dart';
import 'timestamp.dart';
import 'timezone.dart';

/// Represents an instant in the entire chronology of time. This object is timezone/location invariant.
class Instant implements Comparable<Instant> {
    final int _microSecondsSinceEpoch;

    const Instant(this._microSecondsSinceEpoch);

    /// Returns the Linux epoch instant, `Midnight, January 1st, 1970, UTC`.
    factory Instant.epoch() => const Instant(0);
    /// Returns an instant representing now.
    factory Instant.now() => clock.now();
    /// Returns an instant representing the moment of a [DateTime] object.
    factory Instant.fromDateTime(DateTime val) => Instant(val.microsecondsSinceEpoch);

    /// Returns the number of microseconds since the Unix Epoch time, 1970-01-01T00:00:00Z (UTC).
    int microsecondsSinceEpoch() => _microSecondsSinceEpoch;

    /// Returns an [Interval] representing the difference of this from [other].
    Interval difference(Instant other) => Interval(microseconds: microsecondsSinceEpoch() - other.microsecondsSinceEpoch());

    /// Returns `this + dur`. Wrapper for the [+] operator.
    Instant add(Interval dur) => this + dur;

    /// Returns `this - dur`. Wrapper for the [-] operator.
    Instant subtract(Interval dur) => this - dur;

    /// Returns a timestamp representing this instance of time in the `Etf/UTC` timezone.
    Timestamp toTimestampUTC() => Timestamp.fromInstantUTC(this);

    /// Returns a timestamp representing this instance of time in the local timezone.
    Timestamp toTimestampLocal() => Timestamp.fromInstantLocal(this);

    /// Returns a timestamp representing this instance of time in `timezone`.
    Timestamp toTimestamp(TimeZone timezone) => Timestamp(timezone, this);

    @override int compareTo(covariant Instant other) => microsecondsSinceEpoch().compareTo(other.microsecondsSinceEpoch());
    @override bool operator ==(covariant Instant other) => compareTo(other) == 0;
    @override int get hashCode => microsecondsSinceEpoch().hashCode;
    bool operator >(Instant other) => compareTo(other) > 0;
    bool operator >=(Instant other) => compareTo(other) >= 0;
    bool operator <(Instant other) => compareTo(other) < 0;
    bool operator <=(Instant other) => compareTo(other) <= 0;
    Instant operator +(Interval dur) => Instant(microsecondsSinceEpoch() + dur.asMicroseconds());
    Instant operator -(Interval dur) => Instant(microsecondsSinceEpoch() - dur.asMicroseconds());
}