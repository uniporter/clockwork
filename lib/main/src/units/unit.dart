import 'package:meta/meta.dart';

import '../utils/exception.dart';
import '../utils/system_util.dart';

export 'day.dart';
export 'day_period.dart';
export 'era.dart';
export 'hour.dart';
export 'microsecond.dart';
export 'millisecond.dart';
export 'minute.dart';
export 'month.dart';
export 'quarter.dart';
export 'second.dart';
export 'unit.dart';
export 'week.dart';
export 'weekday.dart';
export 'year.dart';

typedef UnitBuilder<U extends Unit> = U Function(int value);

class Unit extends RangedValue {
    final num len;

    Unit(value, [this.len = double.infinity]) : super(value);

    final UnitBuilder<Unit> builder = (value) => Unit(value);

    int get size => (range.ceilingExclusive ? range.ceiling - range.floor : range.ceiling - range.floor + 1) as int;

    /// Prints the underlying [value] of this.
    @override String toString() => value.toString();

    /// Adds this with another [Unit].
    ///
    /// The operation will throw an [InvalidArgumentException] if the result is not within [range].
    ///
    /// Note: Since currently Dart doesn't have union types, we cannot specify the type of the argument (ideally
    /// we will make it `int | covariant Unit`). The function will thus throw exceptions if [other] is of
    /// neither type.
    Unit operator +(int other) {
        final value = ((this.value + other - 1) % len + 1).toInt();
        return range.has(value) ? builder(value) : throw InvalidArgumentException('other');
    }

    /// Subtract another [Unit] or [int] from this.
    ///
    /// The operation will throw an [InvalidArgumentException] if the result is not within [range].
    ///
    /// Note: Since currently Dart doesn't have union types, we cannot specify the type of the argument (ideally
    /// we will make it `int | covariant Unit`). The function will thus throw exceptions if [other] is of
    /// neither type.
    Unit operator -(int other) {
        final value = ((this.value - other - 1) % len + 1).toInt();
        return range.has(value) ? builder(value) : throw InvalidArgumentException('other');
    }

    /// Compare the value of this with [other].
    ///
    /// Note: Since currently Dart doesn't have union types, we cannot specify the type of the argument (ideally
    /// we will make it `int | covariant Unit`). The function will thus throw exceptions if [other] is of
    /// neither type.
    @override
    int compareTo(covariant dynamic other) {
        if (runtimeType == other.runtimeType) return value.compareTo((other as Unit).value);
        else if (other is int) return value.compareTo(other);
        else throw InvalidArgumentException('other');
    }
    @override bool operator <(covariant dynamic other) => compareTo(other) < 0;
    @override bool operator >(covariant dynamic other) => compareTo(other) > 0;
    @override bool operator <=(covariant dynamic other) => compareTo(other) <= 0;
    @override bool operator >=(covariant dynamic other) => compareTo(other) >= 0;

    /// A simple wrapper overload of the [runtimeType] getter by simply returning the superclass' implementation.
    /// We're only reimplementing this because we want to decorate this method with [nonVirtual] and this requires
    /// a concrete implementation.
    ///
    /// We're forbidding [runtimeType] from being overriden by subclasses because the arithmetic operators depend on
    /// the native [runtimeType] implementation to properly function.
    @nonVirtual
    @override
    Type get runtimeType => super.runtimeType;
}