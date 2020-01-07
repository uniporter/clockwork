import 'package:meta/meta.dart';

import '../utils/exception.dart';
import '../utils/system_util.dart';

export 'day.dart';
export 'day_period.dart';
export 'era.dart';
export 'fixed_day_period.dart';
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

class Unit extends RangedValue {
    Unit(value) : super(value);

    final Unit Function(int value) builder = (value) => Unit(value);

    int get size => (range.ceilingExclusive ? range.ceiling - range.floor : range.ceiling - range.floor + 1) as int;

    /// Prints the underlying [value] of this.
    @override String toString() => value.toString();

    /// Adds this with another [Unit] or [int].
    ///
    /// The operation will throw an [InvalidArgumentException] if the result is not within [range].
    ///
    /// Note: Since currently Dart doesn't have union types, we cannot specify the type of the argument (ideally
    /// we will make it `int | covariant Unit`). The function will thus throw exceptions if [other] is of
    /// neither type.
    Unit operator +(dynamic other) {
        if (runtimeType == other.runtimeType) {
            final value = this.value + (other as Unit).value;
            return range.contains(value) ? builder(value) : throw InvalidArgumentException('other');
        } else if (other is int) {
            final value = this.value + other;
            return range.contains(value) ? builder(value) : throw InvalidArgumentException('other');
        } else throw InvalidArgumentException('other');
    }

    /// Subtract another [Unit] or [int] from this.
    ///
    /// The operation will throw an [InvalidArgumentException] if the result is not within [range].
    ///
    /// Note: Since currently Dart doesn't have union types, we cannot specify the type of the argument (ideally
    /// we will make it `int | covariant Unit`). The function will thus throw exceptions if [other] is of
    /// neither type.
    Unit operator -(dynamic other) {
        if (runtimeType == other.runtimeType) {
            final value = this.value - (other as Unit).value;
            return range.contains(value) ? builder(value) : throw InvalidArgumentException('other');
        } else if (other is int) {
            final value = this.value - other;
            return range.contains(value) ? builder(value) : throw InvalidArgumentException('other');
        } else throw InvalidArgumentException('other');
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
    @override bool operator <(covariant dynamic other) => value.compareTo(other.value) < 0;
    @override bool operator >(covariant dynamic other) => value.compareTo(other.value) > 0;
    @override bool operator <=(covariant dynamic other) => value.compareTo(other.value) <= 0;
    @override bool operator >=(covariant dynamic other) => value.compareTo(other.value) >= 0;

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