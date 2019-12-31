import 'package:clockwork/src/utils/exception.dart';

/// How Clockwork will handle exceptions.
enum ExceptionHandler {
    /// Clockwork will not throw any exceptions, but will return [null] to the caller function.
    SILENT,
    /// Clockwork will explicitly throw the relevant exceptions for all functions.
    EXPLICIT,
}

ExceptionHandler _exceptionHandler = ExceptionHandler.EXPLICIT;

ExceptionHandler get exceptionHandler => _exceptionHandler;

set setExceptionHandler(ExceptionHandler handler) {
    if (handler == null) throw InvalidArgumentException('handler');
    _exceptionHandler = handler;
}