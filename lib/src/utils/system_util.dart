import 'package:datex/src/utils/exception.dart';
import 'package:datex/src/utils/settings.dart';

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