import 'package:datex/src/utils/exception.dart';
import 'package:datex/src/utils/settings.dart';

Iterable<int> range(int bottom, int top) sync* {
    for (int i = bottom; i < top; ++i) yield i;
}

/// Reports an error occurred within the DateX framework.
///
/// The function will handle the error based on the [exceptionHandler] settings. If it's set to
/// [ExceptionHandler.SILENT], then the function will return [null]. If instead it's set to
/// [ExceptionHandler.EXPLICIT], the function will throw the [exception]. Thus, you should always call
/// this function by `return error(YOUR EXCEPTION HERE)`.
Null error(DateXException exception) {
    switch (exceptionHandler) {
        case ExceptionHandler.EXPLICIT:
            throw exception;

        case ExceptionHandler.SILENT:
            return null;

        default:
            throw CriticalErrorException();
    }
}

typedef ForEachLambda<T> = void Function(T, int);
typedef Folder<T, A> = A Function(A, T, int, Iterable<T>);

extension IterableExtension<T> on Iterable<T> {
    void forEachX(ForEachLambda lambda) {
        final it = this.iterator;
        int currIndex = 0;
        while (it.moveNext()) {
            lambda(it.current, currIndex++);
        }
    }

    A foldX<A>(A initial, Folder<T, A> folder, [A Function(A) last]) {
        A curr = initial;
        this.forEachX((elem, index) => curr = folder(curr, elem, index, this));
        return last == null ? curr : last(curr);
    }
}