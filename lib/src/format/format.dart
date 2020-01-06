import '../calendar/calendar.dart';
import '../locale/locale.dart';
import '../utils/system_util.dart';
import 'formattable.dart';
import 'parser.dart';
import 'tokens/format_token.dart';
import 'tokens/utility.tokens.dart';

/// Describes a [Format] for a particular [IFormattable] object.
class Format<F extends IFormattable> {
    final List<StatefulToken<F>> tokens;

    const Format(this.tokens);
    /// Returns a [Format] based on the description of [str].
    Format.parse(String str) : tokens = _parseHelper<F>(str, 0);
    /// Returns a [Format] by concatenating the [Format]s in [it].
    Format.concat(Iterable<Format<F>> it) : tokens = [for (var format in it) ...format.tokens];

    static List<StatefulToken<F>> _parseHelper<F extends IFormattable>(String str, int progress) {
        if (str == '' || progress >= tokenMap[F].length) return [];
        Iterable<Match> matches;
        while ((matches = tokenMap[F].keys.elementAt(progress).allMatches(str)).isEmpty) {
            progress++;
            if (progress >= tokenMap[F].length) return [string<F>(str)];
        }

        final results = matches.map((match) => tokenMap[F].values.elementAt(progress)(match) as ParseResult<F>).toList();
        progress++;

        return results.foldX<List<StatefulToken<F>>>(
            [if (results.first.start != 0) ..._parseHelper<F>(str.substring(0, results.first.start), progress)],
            (prevArray, val, index, results) {
                if (prevArray.isEmpty) return prevArray..add(val.token);
                else if (index != 0 && results.elementAt(index - 1).end != val.start) return prevArray..addAll(_parseHelper<F>(str.substring(results.elementAt(index - 1).end, val.start), progress))..add(val.token);
                else return prevArray..add(val.token);
            },
            (prevArray) {
                if (results.last.end != str.length) return prevArray..addAll(_parseHelper<F>(str.substring(results.last.end), progress));
                else return prevArray;
            },
        );
    }

    /// Format [f] with optionally provided [locale] and [calendar]. If not provided we use the default data, i.e. [currLocale] and [currCalendar].
    String format(F f, [Locale? locale, Calendar? calendar]) {
        /// We purify all tokens before using them to format [f].
        final pureTokens = tokens.map((token) => (F f) => token(f, nonNullCalendar(calendar), nonNullLocale(locale)));
        return pureTokens.map((token) => token(f)).join();
    }
}