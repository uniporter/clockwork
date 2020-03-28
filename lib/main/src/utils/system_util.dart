import 'dart:collection';

import 'exception.dart';

/// An [int]-like data structure that imposes a range restriction on the kind of integers it can hold.
class RangedValue implements Comparable<RangedValue> {
    final int value;
    final Range<num> range = const Range<num>(double.negativeInfinity, double.infinity);

    RangedValue(this.value) {
        if (!range.has(value)) throw InvalidArgumentException('value', 'REQUIRES: ${range.floor} <= val ${range.ceilingExclusive ? "<" : "<="} ${range.ceiling}, HAS: $value');
    }

    /// Returns the underlying integer value of this.
    int call() => value;

    /// Returns the 0-indexed underlying value of this.
    ///
    /// This getter subtracts [this.range.floor] from the underlying index to accommodate other systems with indices starting from 0.
    int get index => (this() - range.floor).toInt();

    @override String toString() => value.toString();

    @override bool operator ==(covariant RangedValue other) => value == other.value;
    @override int get hashCode => value.hashCode;
    @override int compareTo(covariant RangedValue other) => value.compareTo(other.value);
    bool operator <(covariant RangedValue other) => compareTo(other) < 0;
    bool operator >(covariant RangedValue other) => compareTo(other) > 0;
    bool operator <=(covariant RangedValue other) => compareTo(other) <= 0;
    bool operator >=(covariant RangedValue other) => compareTo(other) >= 0;
}

/// Represents a range of any [Comparable] types with a [floor] and a [ceiling].
class Range<T extends Comparable> {
    final T floor;
    final T ceiling;
    final bool ceilingExclusive;

    const Range(this.floor, this.ceiling, [this.ceilingExclusive = true]);

    bool has(T val) => ceilingExclusive ? (floor.compareTo(val) <= 0 && ceiling.compareTo(val) > 0)
        : (floor.compareTo(val) <= 0 && ceiling.compareTo(val) >= 0);
}

/// Represents a [Range] that can also iterate through its elements from its [floor].
class IterableRange<T extends Comparable> extends Range<T> with IterableMixin<T> {
    @override final T floor;
    @override final T ceiling;
    @override final bool ceilingExclusive;

    final T Function(T) _it;

    IterableRange(this.floor, this.ceiling, this._it, [this.ceilingExclusive = true])
        : super(floor, ceiling, ceilingExclusive);

    @override Iterator<T> get iterator => _RangeIterator(this, _it);
}

class _RangeIterator<T extends Comparable> implements Iterator<T> {
    T? _current;
    final IterableRange<T> _range;
    final T Function(T) _it;

    bool _started = false;

    _RangeIterator(this._range, this._it);

    @override T? get current => _current;

    @pragma("vm:prefer-inline")
    @override
    bool moveNext() {
        if (_current == null && !_started) {
            final movable = _range.has(_range.floor);
            _current = movable ? _range.floor : null;
            _started = true;
            return movable;
        } else if (_current == null && _started) {
            return false;
        } else {
            final candidate = _it(_current as T);
            _current = _range.has(candidate) ? candidate : null;
            return _current == null ? false : true;
        }
    }
}

/// An identity function. Since Dart does not allow const lambdas, we have to write a static function here.
T identity<T>(T elem) => elem;

/// Type signature for the inner lambda for [Iterable<T>.forEachX].
typedef ForEachLambda<T> = void Function(T, int);
/// Type signature for the inner lambda for [Iterable<T>.foldX].
typedef Folder<T, A> = A Function(A, T, int, Iterable<T>);

/// An extension to existing methods of [Iterable].
extension IterableExtension<T> on Iterable<T> {
    /// Exhanced [Iterable.forEach] where the inner lambda also provides the index of the current item as a parameter.
    void forEachX(ForEachLambda lambda) {
        final it = iterator;
        int currIndex = 0;
        while (it.moveNext()) {
            lambda(it.current, currIndex++);
        }
    }

    /// Exhanced [Iterable.fold] where the inner lambda also provides the index of the current item as well as the
    /// [Iterable] being iterated over as parameters. An optional [last] parameter is also added to modify the reduced
    /// value after the iteration is complete.
     A foldX<A>(A initial, Folder<T, A> folder, [A Function(A)? last]) {
        A curr = initial;
        forEachX((elem, index) => curr = folder(curr, elem, index, this));
        return last == null ? curr : last(curr);
    }
}