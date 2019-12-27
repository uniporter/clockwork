import 'package:datex/src/units/conversion.dart';
import 'package:datex/src/utils/exception.dart';
import 'package:datex/src/utils/system_util.dart';

class Interval implements Comparable<Interval> {
    /// Length of the interval in microseconds.
    final int _len;

    /// Default constructor. If no parameter is given, an interval of length 0 microseconds is returned.
    /// The parameters accept all integers.
    const Interval({
        int days = 0,
        int hours = 0,
        int minutes = 0,
        int seconds = 0,
        int milliseconds = 0,
        int microseconds = 0,
    }) : _len = days * microsecondsPerDay + hours * microsecondsPerHour + minutes * microsecondsPerMinute + seconds * microsecondsPerSecond + milliseconds * microsecondsPerMillisecond + microseconds;

    factory Interval.fromDuration(Duration duration) => Interval(microseconds: duration.inMicroseconds);

    /// Returns the microsecond component of this Interval. Value's ranged between -999 and 999.
    int microseconds() => _len.remainder(microsecondsPerMillisecond);
    /// Returns the number of microseconds spanned by this Interval.
    int asMicroseconds() => _len;

    /// Returns the number of milliseconds spanned by this Interval.
    double asMilliseconds() => _len / microsecondsPerMillisecond;

    /// Returns the number of seconds spanned by this Interval.
    double asSeconds() => _len / microsecondsPerSecond;

    /// Returns the number of minutes spanned by this Interval.
    double asMinutes() => _len / microsecondsPerMinute;

    /// Returns the number of hours spanned by this Interval.
    double asHours() => _len / microsecondsPerHour;

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
    Interval operator ~/(num factor) => factor == 0 ? error(InvalidArgumentException('factor')) : Interval(microseconds: (this.asMicroseconds() / factor).round());
}
