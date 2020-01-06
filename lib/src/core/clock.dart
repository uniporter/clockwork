import '../core/instant.dart';

/// An interface that represents a clock. Its only function is to return the current time as an [Instant].
///
/// By default, all clockwork constructs use [DefaultClock], which uses Dart's native methods to find the
/// current time. In production code you should stick with [DefaultClock]. However, when you're testing code,
/// and need to manually manipulate the current time, you can implement this interface.
abstract class Clock {
    /// Returns the current time as an [Instant].
    Instant now();
}

/// The default [Clock] that uses Dart's native methods to find the current time. This is a singleton class.
class DefaultClock implements Clock {
    static final DefaultClock _singleton = DefaultClock._internal();
    factory DefaultClock() => _singleton;
    DefaultClock._internal();

    @override Instant now() => Instant(DateTime.now().microsecondsSinceEpoch);
}

Clock _clock = DefaultClock();

/// The current [Clock] used by the system.
Clock get clock => _clock;

/// Set the [Clock] used by the system to [clock].
set clock(Clock clock) {
    _clock = clock;
}