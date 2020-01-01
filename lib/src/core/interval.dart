import 'package:clockwork/src/format/formattable.dart';
import 'package:clockwork/src/units/conversion.dart';
import 'package:clockwork/src/utils/exception.dart';

/// Represents the length of a period of time.
class Interval with IFormattable implements Comparable<Interval> {
    /// Length of the interval in microseconds.
    final int _len;

    /// Default constructor. If no parameter is given, an interval of length 0 microseconds is returned.
    /// The parameters accept all integers.
    const Interval({
        num days = 0,
        num hours = 0,
        num minutes = 0,
        num seconds = 0,
        num milliseconds = 0,
        num microseconds = 0,
    }) : _len = (days * microsecondsPerDay + hours * microsecondsPerHour + minutes * microsecondsPerMinute + seconds * microsecondsPerSecond + milliseconds * microsecondsPerMillisecond + microseconds) as int;

    factory Interval.fromDuration(Duration duration) => Interval(microseconds: duration.inMicroseconds);

    int get microsecond => _len % microsecondsPerMillisecond;
    /// Returns the number of microseconds spanned by this Interval.
    int asMicroseconds() => _len;

    int get millisecond => _len % microsecondsPerSecond;
    /// Returns the number of milliseconds spanned by this Interval.
    double asMilliseconds() => _len / microsecondsPerMillisecond;

    int get second => _len % microsecondsPerMinute;
    /// Returns the number of seconds spanned by this Interval.
    double asSeconds() => _len / microsecondsPerSecond;

    int get minute => _len % microsecondsPerHour;
    /// Returns the number of minutes spanned by this Interval.
    double asMinutes() => _len / microsecondsPerMinute;

    int get hour => _len % microsecondsPerDay;
    /// Returns the number of hours spanned by this Interval.
    double asHours() => _len / microsecondsPerHour;

    int get day => _len ~/ microsecondsPerDay;
    /// Returns the number of days spanned by this Interval.
    double asDays() => _len / microsecondsPerDay;

    /// Returns the absolute value of this [Interval].
    Interval abs() => Interval(microseconds: asMicroseconds().abs());

    /// Returns a clone of this [Interval]. Notice that none of the operations on [Interval] modify the original [Interval],
    /// so you don't have to clone it before performing any operations.
    Interval clone() => Interval(microseconds: asMicroseconds());

    @override int compareTo(covariant Interval other) => this.asMicroseconds().compareTo(other.asMicroseconds());
    @override bool operator ==(covariant Interval other) => this.asMicroseconds() == other.asMicroseconds();
    bool operator >(Interval other) => this.asMicroseconds() > other.asMicroseconds();
    bool operator >=(Interval other) => this.asMicroseconds() >= other.asMicroseconds();
    bool operator <(Interval other) => this.asMicroseconds() < other.asMicroseconds();
    bool operator <=(Interval other) => this.asMicroseconds() <= other.asMicroseconds();
    Interval operator +(Interval other) => Interval(microseconds: this.asMicroseconds() + other.asMicroseconds());
    Interval operator -(Interval other) => Interval(microseconds: this.asMicroseconds() - other.asMicroseconds());
    Interval operator *(num factor) => Interval(microseconds: (this.asMicroseconds() * factor).round());
    Interval operator ~/(num factor) => factor == 0 ? throw InvalidArgumentException('factor') : Interval(microseconds: (this.asMicroseconds() / factor).round());
}
