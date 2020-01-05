import 'package:clockwork/src/calendar/calendar.dart';
import 'package:clockwork/src/format/formattable.dart';
import 'package:clockwork/src/format/parser.dart';
import 'package:clockwork/src/format/tokens/format_token.dart';
import 'package:clockwork/src/format/tokens/utility.tokens.dart';
import 'package:clockwork/src/locale/locale.dart';
import 'package:clockwork/src/utils/exception.dart';
import 'package:clockwork/src/utils/system_util.dart';

/// Describes a [Format] for a particular [IFormattable] object.
class Format<T extends IFormattable> {
    final List<StatefulToken<T, ReducibleMetadata<T>>> tokens;

    const Format(this.tokens);
    /// Returns a [Format] based on the description of [str].
    Format.parse(String str) : tokens = _parseHelper<T>(str, 0);
    /// Returns a [Format] by concatenating the [Format]s in [it].
    Format.concat(Iterable<Format<T>> it) : tokens = [for (var format in it) ...format.tokens];

    static List<StatefulToken<T, ReducibleMetadata<T>>> _parseHelper<T extends IFormattable>(String str, int progress) {
        if (str == '' || progress >= tokenMap[T].length) return [];
        Iterable<Match> matches;
        while ((matches = tokenMap[T].keys.elementAt(progress).allMatches(str)).isEmpty) {
            progress++;
            if (progress >= tokenMap[T].length) return [string<T>(str)];
        }

        final results = matches.map((match) => tokenMap[T].values.elementAt(progress)(match) as ParseResult<T, ReducibleMetadata<T>>).toList();
        progress++;

        return results.foldX<List<StatefulToken<T, ReducibleMetadata<T>>>>(
            [if (results.first.start != 0) ..._parseHelper<T>(str.substring(0, results.first.start), progress)],
            (prevArray, val, index, results) {
                if (prevArray.isEmpty) return prevArray..add(val.token);
                else if (index != 0 && results.elementAt(index - 1).end != val.start) return prevArray..addAll(_parseHelper<T>(str.substring(results.elementAt(index - 1).end, val.start), progress))..add(val.token);
                else return prevArray..add(val.token);
            },
            (prevArray) {
                if (results.last.end != str.length) return prevArray..addAll(_parseHelper<T>(str.substring(results.last.end), progress));
                else return prevArray;
            },
        );
    }

    /// Format [f] with optionally provided [locale] and [calendar]. If not provided we use the default data, i.e. [currLocale] and [currCalendar].
    String format(T f, [Locale? locale, Calendar? calendar]) {
        final dummyMetadata = DummyTokenMetadata<T>();
        final localeMetadata = TokenMetadataWithLocale<T>(locale: nonNullLocale(locale));
        final calendarMetadata = TokenMetadataWithCalendar<T>(calendar: nonNullCalendar(calendar));
        final localeCalendarMetadata = TokenMetadataWithCalendarLocale<T>(locale: nonNullLocale(locale), calendar: nonNullCalendar(calendar));

        /// We purify all tokens before using them to format [f].
        final pureTokens = tokens.map((token) {
            // TODO: Let's try to make this routine less idiotic.
            if (token is StatefulToken<T, DummyTokenMetadata<T>>) return dummyMetadata.reduce(token);
            else if (token is StatefulToken<T, TokenMetadataWithLocale<T>>) return localeMetadata.reduce(token);
            else if (token is StatefulToken<T, TokenMetadataWithCalendar<T>>) return calendarMetadata.reduce(token);
            else if (token is StatefulToken<T, TokenMetadataWithCalendarLocale<T>>) return localeCalendarMetadata.reduce(token);
            else throw CriticalErrorException();
        });
        return pureTokens.map((token) => token(f)).join();
    }
}