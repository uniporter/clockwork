import 'package:clockwork/src/core/instant.dart';

/// An interface that represents a clock. Its only function is to return the current time as an [Instant].
///
/// By default, all clockwork constructs use [DefaultClock], which uses Dart's native methods to find the
/// current time. In production code you should stick with [DefaultClock]. However, when you're testing code,
/// and need to manually manipulate the current time, you can implement this interface.
abstract class IClock {
    /// Returns the current time as an [Instant].
    Instant now();
}

/// The default [IClock] that uses Dart's native methods to find the current time. Do not instantiate [DefaultClock]
/// on your own. The constant, singleton instance of [DefaultClock] can be retrieved from [DEFAULT_CLOCK].
class DefaultClock implements IClock {
    const DefaultClock();
    @override Instant now() => Instant(DateTime.now().microsecondsSinceEpoch);
}

/// Singleton instance of [DefaultClock]. You should never instantiate [DefaultClock].
const DEFAULT_CLOCK = DefaultClock();

IClock _clock = DEFAULT_CLOCK;

/// The current [IClock] used by the system.
IClock get clock => _clock;

/// Set the [IClock] used by the system to [clock].
set setClock(IClock clock) {
    _clock = clock;
}