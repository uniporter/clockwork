import 'dart:collection';

/// Represents a range of any [Comparable] types with a [floor] and a [ceiling].
class Range<T extends Comparable<T>> {
    final T floor;
    final T ceiling;
    final bool ceilingExclusive;

    const Range(this.floor, this.ceiling, [this.ceilingExclusive = true]);

    bool contains(T val) => ceilingExclusive ? (floor.compareTo(val) <= 0 && ceiling.compareTo(val) > 0)
        : (floor.compareTo(val) <= 0 && ceiling.compareTo(val) >= 0);
}

/// Represents a [Range] that can also iterate through its elements from its [floor].
class IterableRange<T extends Comparable<T>> extends Range<T> with IterableMixin<T> {
    final T floor;
    final T ceiling;
    final bool ceilingExclusive;

    final T Function(T) _it;

    IterableRange(this.floor, this.ceiling, this._it, [this.ceilingExclusive = true])
        : super(floor, ceiling, ceilingExclusive);

    Iterator<T> get iterator => _RangeIterator(this, _it);
}

class _RangeIterator<T extends Comparable<T>> implements Iterator<T> {
    T? _current = null;
    final IterableRange<T> _range;
    final T Function(T) _it;

    bool _started = false;

    _RangeIterator(this._range, this._it);

    T? get current => _current;
    bool moveNext() {
        if (_current == null && !_started) {
            _current = _range.floor;
            _started = true;
            return true;
        } else if (_current == null && _started) {
            return false;
        } else {
            final candidate = _it(_current as T);
            _current = _range.contains(candidate) ? candidate : null;
            return _current == null ? false : true;
        }
    }
}

/// An identity function. Since Dart does not allow const lambdas, we have to write a static function here.
T identity<T>(T elem) => elem;

/// Type signature for the inner lambda for [IterableExtension.forEach].
typedef ForEachLambda<T> = void Function(T, int);
/// Type signature for the inner lambda for [IterableExtension.foldX].
typedef Folder<T, A> = A Function(A, T, int, Iterable<T>);

/// An extension to existing methods of [Iterable].
extension IterableExtension<T> on Iterable<T> {
    /// Exhanced [Iterable.forEach] where the inner lambda also provides the index of the current item as a parameter.
    void forEachX(ForEachLambda lambda) {
        final it = this.iterator;
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
        this.forEachX((elem, index) => curr = folder(curr, elem, index, this));
        return last == null ? curr : last(curr);
    }
}

