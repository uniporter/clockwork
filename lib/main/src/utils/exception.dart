import '../core/timestamp.dart';
import 'constants.dart';

abstract class ClockworkException implements Exception {
    String _toStringHelper(String msg) => "$PACKAGE_NAME: $runtimeType: $msg";
}

class GeneralException extends ClockworkException {
    final String msg;

    GeneralException(this.msg) {}

    @override
    String toString() => _toStringHelper(msg);
}

/// Thrown when functions requiring some external data are called and those data haven't been loaded.
class DataNotLoadedException extends ClockworkException {
    final String dataName;

    DataNotLoadedException(this.dataName) {}

    @override
    String toString() => _toStringHelper("You need to load $dataName before using this function.");
}

/// Thrown when Clockwork functions are called with invalid arguments.
class InvalidArgumentException extends ClockworkException {
    final String argName;
    final String meta;

    InvalidArgumentException(this.argName, [this.meta = '']) {}

    @override
    String toString() => _toStringHelper("$argName is not in a valid format. $meta");
}

/// Thrown when trying to create a [Timestamp] where the
/// time indicated by the provided info doesn't actually exist. This is usually due to change of time offsets within the
/// same timezone that results in a lapse in the timezone's calendar.
///
/// For instance, in most regions of the United States, the Daylight Saving Time brings the clock forward by 1 hour during
/// every spring. In 2019, this occurred on `1am, March 10 2019 EST`, at which point all clocks jumped to 2am. Thus
/// if any timestamp factory is called with parameters indicating the time of `1:30am, March 10 2019 EST`, this exception
/// will be thrown.
class TimestampNonexistentException extends ClockworkException {
    final String timestamp;

    TimestampNonexistentException(this.timestamp);

    @override
    String toString() => _toStringHelper("$timestamp does not exist.");
}

/// Thrown when trying to create a [Timestamp] where the
/// time indicated by the provided info points to more than one [Timestamp] instances. This is usually due to change of time
/// offsets within the same timezone that results in a partial repetition in the timezone's calendar.
///
/// For instance, in most regions of the United States, the Daylight Saving Time brings the clock backward by 1 hour during
/// every fall. In 2019, this occurred on `2am, November 3 2019 EST`, at which point all clocks moved back to 1am. Thus if
/// a parameter is given to any [Timestamp] factory that indicates the time of `1:30am, November 3 2019 EST`, it's not clear
/// which specific instance in time, whether before or after the DST shift, is the parameter referring to, and this exception
/// will be thrown.
class AmbiguousTimestampException extends ClockworkException {
    final String timestamp;

    AmbiguousTimestampException(this.timestamp) {}

    @override
    String toString() => _toStringHelper("More than one Timestamp instances can be represented by $timestamp.");
}

/// Thrown when states that Clockwork depend on for basic funcionalities are corrupted. When this exception is thrown
/// it's recommended that the user reloads the library entirely.
class CriticalErrorException extends ClockworkException {
    CriticalErrorException() {}

    @override
    String toString() => _toStringHelper("Clockwork internal states have been corrupted. Reload recommended.");
}