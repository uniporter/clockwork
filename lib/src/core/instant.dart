import 'package:clockwork/src/core/interval.dart';
import 'package:clockwork/src/core/timestamp.dart';
import 'package:clockwork/src/core/timezone.dart';

/// Represents an instant in the entire chronology of time. This object is timezone/location invariant.
class Instant implements Comparable<Instant> {
    final int _microSecondsSinceEpoch;

    const Instant(this._microSecondsSinceEpoch);

    factory Instant.epoch() => const Instant(0);
    factory Instant.now() => Instant(DateTime.now().microsecondsSinceEpoch);
    factory Instant.fromDateTime(DateTime val) => Instant(val.microsecondsSinceEpoch);

    /// Returns the number of microseconds since the Unix Epoch time, 1970-01-01T00:00:00Z (UTC).
    int microSecondsSinceEpoch() => _microSecondsSinceEpoch;

    /// Returns an `Interval` representing the difference of this from `other`.
    Interval difference(Instant other) => Interval(microseconds: this.microSecondsSinceEpoch() - other.microSecondsSinceEpoch());

    /// Returns `this + dur`. Wrapper for the `+` operator.
    Instant add(Interval dur) => this + dur;

    /// Returns `this - dur`. Wrapper for the `-` operator.
    Instant subtract(Interval dur) => this - dur;

    /// Returns a timestamp representing this instance of time in the `Etf/UTC` timezone.
    Timestamp toTimestampUTC() => Timestamp.fromInstantUTC(this);

    /// Returns a timestamp representing this instance of time in the local timezone.
    Timestamp toTimestampLocal() => Timestamp.fromInstantLocal(this);

    /// Returns a timestamp representing this instance of time in `timezone`.
    Timestamp toTimestamp(TimeZone timezone) => Timestamp(timezone, this);

    @override int compareTo(covariant Instant other) => this.microSecondsSinceEpoch().compareTo(other.microSecondsSinceEpoch());
    @override bool operator ==(covariant Instant other) => this.microSecondsSinceEpoch() == other.microSecondsSinceEpoch();
    bool operator >(Instant other) => this.microSecondsSinceEpoch() > other.microSecondsSinceEpoch();
    bool operator >=(Instant other) => this.microSecondsSinceEpoch() >= other.microSecondsSinceEpoch();
    bool operator <(Instant other) => this.microSecondsSinceEpoch() < other.microSecondsSinceEpoch();
    bool operator <=(Instant other) => this.microSecondsSinceEpoch() <= other.microSecondsSinceEpoch();
    Instant operator +(Interval dur) => Instant(this.microSecondsSinceEpoch() + dur.asMicroseconds());
    Instant operator -(Interval dur) => Instant(this.microSecondsSinceEpoch() - dur.asMicroseconds());
}