/// Returns an [Iterable] that iterates through all integers from [bottom] inclusive to [top] exclusive.
Iterable<int> range(int bottom, int top) sync* {
    for (int i = bottom; i < top; ++i) yield i;
}

typedef Concept<T extends Conceptable> = bool Function(T);
abstract class Conceptable {
    void checkConcept(Set<Concept> concepts) {
        if (!concepts.fold(true, (res, concept) => res && concept(this))) throw Exception();
    }

    Conceptable(Set<Concept> concepts) {
        checkConcept(concepts);
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

