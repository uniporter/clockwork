import '../../calendar/calendar.dart';
import '../../locale/locale.dart';
import '../formattable.dart';
import 'utility.tokens.dart';

/// A Token that doesn't depend on any external states: that is, given an [IFormattable], the token's output is
/// deterministic.
class PureToken<F extends IFormattable> {
    final String? Function(F f) _formatter;
    const PureToken(this._formatter);

    String? call(F f) => _formatter(f);

    /// Returns a new token that's a clone of this.
    PureToken<F> clone() => PureToken((f) => this(f));

    /// Returns a new token that formats the numeral returned by this at as long as it takes
    /// to display the numeral fully, then pads it so the resulting length is at least [len].
    ///
    /// If [unpadded] is set, then we assume that this doesn't have any padding; the function will run faster as a result.
    PureToken<F> withMinLength(int len, [bool unpadded = false]) => PureToken((f) {
        final shortForm = unpadded ? this(f) : this(f)?.replaceFirst(RegExp(r"^0+"), '');   // This is the form that displays the numeral fully without any extra 0s.
        return shortForm?.padLeft(len, '0');
    });

    /// Returns a new token that adds the ordinal numeral postfix to the output.
    PureToken<F> ordinalize() => PureToken((f) {
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

    /// Returns a [PureToken] that augments this with fallbacks. That is, when this acting on an [IFormattable] returns `null`,
    /// we will act tokens in [fallbacks] on the [IFormattable] one by one until a non-null value is found with the value then returned.
    PureToken<F> withFallback(Iterable<PureToken<F>> fallbacks) {
        return PureToken((f) => this(f) ?? fallbacks.map((token) => token(f)).firstWhere((res) => res != null));
    }
}

/// A token that depends on external states, namely [Calendar] and [Locale].
class StatefulToken<F extends IFormattable> {
    final String? Function(F f, Calendar calendar, Locale locale) _formatter;
    const StatefulToken(this._formatter);

    String? call(F f, Calendar c, Locale l) => _formatter(f, c, l);

    /// Returns a new token that's a clone of this.
    StatefulToken<F> clone() => StatefulToken((f, c, l) => this(f, c, l));

    /// Returns a new token that formats the numeral returned by this at as long as it takes
    /// to display the numeral fully, then pads it so the resulting length is at least [len].
    ///
    /// If [unpadded] is set, then we assume that this doesn't have any padding; the function will run faster as a result.
    StatefulToken<F> withMinLength(int len, [bool unpadded = false]) => StatefulToken((f, c, l) {
        final shortForm = unpadded ? this(f, c, l) : this(f, c, l)?.replaceFirst(RegExp(r"^0+"), '');   // This is the form that displays the numeral fully without any extra 0s.
        return shortForm?.padLeft(len, '0');
    });

    /// Returns a new token that adds the ordinal numeral postfix to the output.
    StatefulToken<F> ordinalize() => StatefulToken((f, c, l) {
        final output = this(f, c, l);
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

    /// Returns a [StatefulToken] that augments this with fallbacks. That is, when this acting on an [IFormattable] returns `null`,
    /// we will act tokens in [fallbacks] on the [IFormattable] one by one until a non-null value is found with the value then returned.
    StatefulToken<F> withFallback(Iterable<StatefulToken<F>> fallbacks) {
        return StatefulToken((f, c, l) => this(f, c, l) ?? fallbacks.map((token) => token(f, c, l)).firstWhere((res) => res != null));
    }
}

extension PureTokenIterableExtension<F extends IFormattable> on Iterable<PureToken<F>> {
    /// Returns a token that's a concatenation of tokens in this.
    PureToken<F> concat() => PureToken((f) => map((token) => token(f)).join());
}

extension StatefulTokenIterableExtension<F extends IFormattable> on Iterable<StatefulToken<F>> {
    /// Returns a token that's a concatenation of tokens in this.
    StatefulToken<F> concat() => StatefulToken((f, c, l) => map((token) => token(f, c, l)).join());

    /// Returns a token that's a concatenation of tokens in this separated by [sep]. By default we use the culture-specific time separator, normally
    /// represented with the token `:`.
    StatefulToken<F> seperated([String? sep]) => StatefulToken((f, c, l) {
        final str = expand<StatefulToken<F>>((elem) => [elem, string<F>(sep ?? ':')]).map((token) => token(f, c, l)).join();
        return str.substring(0, str.length - (sep ?? ':').length);
    });
}