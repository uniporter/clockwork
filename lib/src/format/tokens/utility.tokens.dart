import 'package:clockwork/src/format/tokens/format_token.dart';
import 'package:clockwork/src/format/formattable.dart';
import 'package:clockwork/src/locale/locale.dart';

/// Returns a new token that's a clone of [t].
FormatToken<T> alias<T extends IFormattable>(FormatToken<T> t) => t;

/// Returns a new token that pads the original token [t] to length [len] with `0`.
FormatToken<T> pad<T extends IFormattable>(FormatToken<T> t, int len) => (ts) => t(ts).padLeft(len, '0');

/// Returns a new token that adds the ordinal numeral postfix to the output of [t].
FormatToken<T> ordinal<T extends IFormattable>(FormatToken<T> t) => (ts) {
    final output = t(ts);
    final cardinal = int.parse(output);
    final lastTwoDigits = cardinal % 100;
    final lastDigit = lastTwoDigits % 10;

    final suffixGuess = lastDigit == 1 ? 'st'
        : lastDigit == 2 ? 'nd'
        : lastDigit == 3 ? 'rd'
        : 'th';

    return output + (lastTwoDigits >= 11 && lastTwoDigits <= 13 ? 'th' : suffixGuess);
};

/// Returns a token that placeholds for nothing but spaces of size [len].
FormatToken space(int len) => (ts) => ''.padLeft(len, ' ');

/// Returns a token that placeholds for [str].
FormatToken string(String str) => (ts) => str;

/// Returns a token that's a concatenation of tokens in [list].
FormatToken<T> concat<T extends IFormattable>(Iterable<FormatToken<T>> list) => (ts) => list.map((token) => token(ts)).join();

/// Returns a token that's a concatenation of tokens in [it] separated by [sep]. By default we use the culture-specific time separator, normally
/// represented with the token `:`.
FormatToken<T> separated<T extends IFormattable>(Iterable<FormatToken<T>> it, [String? sep]) => (ts) {
    final str = it.expand((elem) => [elem, string(sep ?? ':')]).map((token) => token(ts)).join();
    return str.substring(0, str.length - (sep ?? ':').length);
};

/// Returns a [FormatToken] from a [LocaleDependentFormatToken] by using the current system locale, defined by [locale]. This function essentially
/// curries away the locale parameter in [token].
FormatToken<T> withCurrentLocale<T extends IFormattable>(LocaleDependentFormatToken<T> token) => (ts) => token(ts, locale);