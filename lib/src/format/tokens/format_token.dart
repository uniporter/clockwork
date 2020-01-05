import 'package:clockwork/src/calendar/calendar.dart';
import 'package:clockwork/src/format/formattable.dart';
import 'package:clockwork/src/format/tokens/utility.tokens.dart';
import 'package:clockwork/src/locale/locale.dart';

class PureToken<T extends IFormattable> {
    final String? Function(T f) formatter;
    const PureToken(this.formatter);

    String? call(T f) => formatter(f);

    /// Returns a new token that's a clone of [t].
    PureToken<T> clone() => PureToken((f) => this(f));

    /// Given a token [t] with numerical outputs (with or without padding), returns a new token that formats the numeral at as long as it takes
    /// to display the numeral fully, then pads it so the resulting length is at least [len].
    ///
    /// If [pure] is set, then we assume that [t] doesn't have any padding; the function will run faster as a result.
    PureToken<T> withMinLength(int len, [bool unpadded = false]) => PureToken((f) {
        final shortForm = unpadded ? this(f) : this(f)?.replaceFirst(RegExp(r"^0+"), '');   // This is the form that displays the numeral fully without any extra 0s.
        return shortForm?.padLeft(len, '0');
    });

    /// Returns a new token that adds the ordinal numeral postfix to the output.
    PureToken<T> ordinalize() => PureToken((f) {
        final output = this(f);
        if (output == null) return null;
        final cardinal = int.parse(output);
        final lastTwoDigits = cardinal % 100;
        final lastDigit = lastTwoDigits % 10;

        final suffixGuess = lastDigit == 1 ? 'st'
            : lastDigit == 2 ? 'nd'
            : lastDigit == 3 ? 'rd'
            : 'th';

        return output + (lastTwoDigits >= 11 && lastTwoDigits <= 13 ? 'th' : suffixGuess);
    });

    /// Returns a [FormatToken] that augments [token] with fallbacks. That is, when [token] acting on an [IFormattable] returns [null],
    /// we will act tokens in [fallbacks] on the [IFormattable] one by one until a non-null value is found with the value then returned.
    PureToken<T> withFallback(Iterable<PureToken<T>> fallbacks) {
        return PureToken((f) => this(f) ?? fallbacks.map((token) => token(f)).firstWhere((res) => res != null));
    }
}

class StatefulToken<F extends IFormattable, M extends ReducibleMetadata<F>> {
    final String? Function(F f, [M? metadata]) formatter;
    const StatefulToken(this.formatter);

    String? call(F f, [M? metadata]) => formatter(f, metadata);

    /// Returns a new token that's a clone of [t].
    StatefulToken<F, M> clone() => StatefulToken((f, [m]) => this(f, m));

    /// Given a token [t] with numerical outputs (with or without padding), returns a new token that formats the numeral at as long as it takes
    /// to display the numeral fully, then pads it so the resulting length is at least [len].
    ///
    /// If [pure] is set, then we assume that [t] doesn't have any padding; the function will run faster as a result.
    StatefulToken<F, M> withMinLength(int len, [bool unpadded = false]) => StatefulToken((f, [m]) {
        final shortForm = unpadded ? this(f, m) : this(f, m)?.replaceFirst(RegExp(r"^0+"), '');   // This is the form that displays the numeral fully without any extra 0s.
        return shortForm?.padLeft(len, '0');
    });

    /// Returns a new token that adds the ordinal numeral postfix to the output.
    StatefulToken<F, M> ordinalize() => StatefulToken((f, [m]) {
        final output = this(f, m);
        if (output == null) return null;
        final cardinal = int.parse(output);
        final lastTwoDigits = cardinal % 100;
        final lastDigit = lastTwoDigits % 10;

        final suffixGuess = lastDigit == 1 ? 'st'
            : lastDigit == 2 ? 'nd'
            : lastDigit == 3 ? 'rd'
            : 'th';

        return output + (lastTwoDigits >= 11 && lastTwoDigits <= 13 ? 'th' : suffixGuess);
    });

    /// Returns a [FormatToken] that augments [token] with fallbacks. That is, when [token] acting on an [IFormattable] returns [null],
    /// we will act tokens in [fallbacks] on the [IFormattable] one by one until a non-null value is found with the value then returned.
    StatefulToken<F, M> withFallback(Iterable<StatefulToken<F, M>> fallbacks) {
        return StatefulToken((f, [m]) => this(f, m) ?? fallbacks.map((token) => token(f, m)).firstWhere((res) => res != null));
    }
}

/// Metadata for [StatefulToken]. It carries a [reduce] method which can purify the token into a [PureToken] by embedding the metadata inside the token itself.
abstract class ReducibleMetadata<T extends IFormattable> {
    const ReducibleMetadata();

    /// Reduces a [StatefulToken] into a [PureToken] by embedding the state info inside the token itself.
    ///
    /// Notice that you don't really need to override this method unless you want absolute type safety. Currently because Dart doesn't allow referencing self
    /// types in type parameters, when we call `o.reduce(t)` where `o` is an instance of a subclass of [ReducibleMetadata], `t` only have to be a [StatefulToken]
    /// with metadata of *any* [ReducibleMetadata], when ideally we want to restrict `t` to take in metadata of the type of `o` only. Overriding this method
    /// in subclasses, replacing [ReducibleMetadata] in the parameter type signature with the subclass' name, and not implementing the method will fix this issue,
    /// but is slightly more verbose.
    PureToken<T> reduce(covariant StatefulToken<T, ReducibleMetadata<T>> t) => PureToken((T f) => t(f, this));
}

/// A dummy metadata class for tokens that require no metadata. This class is designed so every token, inherently stateful or not, is passed into the [Format]
/// constructor as a [StatefulToken], as the internal structure of [Format] stores tokens in a list and elements in the list need to be of the same type.
class DummyTokenMetadata<T extends IFormattable> extends ReducibleMetadata<T> {
    const DummyTokenMetadata();
    @override PureToken<T> reduce(StatefulToken<T, DummyTokenMetadata<T>> t);
}

/// [ReducibleMetadata] that carries locale info.
class TokenMetadataWithLocale<T extends IFormattable> extends ReducibleMetadata<T> {
    final Locale locale;
    const TokenMetadataWithLocale({required this.locale});
    @override PureToken<T> reduce(StatefulToken<T, TokenMetadataWithLocale<T>> t);
}

/// [ReducibleMetadata] that carries calendar info.
class TokenMetadataWithCalendar<T extends IFormattable> extends ReducibleMetadata<T> {
    final Calendar calendar;
    const TokenMetadataWithCalendar({required this.calendar});
    @override PureToken<T> reduce(StatefulToken<T, TokenMetadataWithCalendar<T>> t);
}

/// [ReducibleMetadata] that carries both calendar and locale info.
class TokenMetadataWithCalendarLocale<T extends IFormattable> extends ReducibleMetadata<T> {
    final Calendar calendar;
    final Locale locale;
    const TokenMetadataWithCalendarLocale({required this.locale, required this.calendar});
    @override PureToken<T> reduce(StatefulToken<T, TokenMetadataWithCalendarLocale<T>> t);
}

extension PureTokenIterableExtension<T extends IFormattable> on Iterable<PureToken<T>> {
    /// Returns a token that's a concatenation of tokens in [this].
    PureToken<T> concat() => PureToken((f) => this.map((token) => token(f)).join());
}

extension StatefulTokenIterableExtension<T extends IFormattable, M extends ReducibleMetadata<T>> on Iterable<StatefulToken<T, M>> {
    /// Returns a token that's a concatenation of tokens in [this].
    StatefulToken<T, M> concat() => StatefulToken((f, [m]) => this.map((token) => token(f, m)).join());

    /// Returns a token that's a concatenation of tokens in [it] separated by [sep]. By default we use the culture-specific time separator, normally
    /// represented with the token `:`.
    StatefulToken<T, M> seperated([String? sep]) => StatefulToken((f, [m]) {
        final str = this.expand<StatefulToken<T, ReducibleMetadata<T>>>((elem) => [elem, string<T>(sep ?? ':')]).map((token) => token(f, m)).join();
        return str.substring(0, str.length - (sep ?? ':').length);
    });
}