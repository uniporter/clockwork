import 'package:datex/src/utils/exception.dart';

/// How DateX will handle exceptions.
enum ExceptionHandler {
    /// DateX will not throw any exceptions, but will return [null] to the caller function.
    SILENT,
    /// DateX will explicitly throw the relevant exceptions for all functions.
    EXPLICIT,
}

ExceptionHandler _exceptionHandler = ExceptionHandler.EXPLICIT;

ExceptionHandler get exceptionHandler => _exceptionHandler;

set setExceptionHandler(ExceptionHandler handler) {
    if (handler == null) throw InvalidArgumentException('handler');
    _exceptionHandler = handler;
}