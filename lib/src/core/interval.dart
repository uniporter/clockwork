import 'package:meta/meta.dart';

import '../format/formattable.dart';
import '../units/unit.dart';
import '../utils/exception.dart';

@Immutable()
/// Represents the length of a period of time.
class Interval with Formattable implements Comparable<Interval> {
    /// Length of the interval in microseconds.
    final int _len;

    /// Default constructor. If no parameter is given, an interval of length 0 microseconds is returned.
    /// The parameters accept all integers.
    Interval({
        num days = 0,
        num hours = 0,
        num minutes = 0,
        num seconds = 0,
        num milliseconds = 0,
        num microseconds = 0,
     }) : _len = (days * Day.microsecondsPer + hours * Hour.microsecondsPer + minutes * Minute.microsecondsPer + seconds * Second.microsecondsPer + milliseconds * Millisecond.microsecondsPer + microseconds).toInt();

    factory Interval.fromDuration(Duration duration) => Interval(microseconds: duration.inMicroseconds);

    int get microsecond => _len % Millisecond.microsecondsPer;
    /// Returns the number of microseconds spanned by this Interval.
    int asMicroseconds() => _len;

    int get millisecond => _len % Second.microsecondsPer;
    /// Returns the number of milliseconds spanned by this Interval.
    double asMilliseconds() => _len / Millisecond.microsecondsPer;

    int get second => _len % Minute.microsecondsPer;
    /// Returns the number of seconds spanned by this Interval.
    double asSeconds() => _len / Second.microsecondsPer;

    int get minute => _len % Hour.microsecondsPer;
    /// Returns the number of minutes spanned by this Interval.
    double asMinutes() => _len / Minute.microsecondsPer;

    int get hour => _len % Day.microsecondsPer;
    /// Returns the number of hours spanned by this Interval.
    double asHours() => _len / Hour.microsecondsPer;

    int get day => _len ~/ Day.microsecondsPer;
    /// Returns the number of days spanned by this Interval.
    double asDays() => _len / Day.microsecondsPer;

    /// Returns the absolute value of this [Interval].
    Interval abs() => Interval(microseconds: asMicroseconds().abs());

    /// Returns a clone of this [Interval]. Notice that none of the operations on [Interval] modify the original [Interval],
    /// so you don't have to clone it before performing any operations.
    Interval clone() => Interval(microseconds: asMicroseconds());

    @override int compareTo(covariant Interval other) => asMicroseconds().compareTo(other.asMicroseconds());
    @override bool operator ==(covariant Interval other) => compareTo(other) == 0;
    @override int get hashCode => asMicroseconds().hashCode;
    bool operator >(Interval other) => compareTo(other) > 0;
    bool operator >=(Interval other) => compareTo(other) >= 0;
    bool operator <(Interval other) => compareTo(other) < 0;
    bool operator <=(Interval other) => compareTo(other) <= 0;
    Interval operator +(Interval other) => Interval(microseconds: asMicroseconds() + other.asMicroseconds());
    Interval operator -(Interval other) => Interval(microseconds: asMicroseconds() - other.asMicroseconds());
    Interval operator *(num factor) => Interval(microseconds: (asMicroseconds() * factor).round());
    Interval operator ~/(num factor) => factor == 0 ? throw InvalidArgumentException('factor') : Interval(microseconds: (asMicroseconds() / factor).round());
}
