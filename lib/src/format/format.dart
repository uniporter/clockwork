import 'package:clockwork/src/core/interval.dart';
import 'package:clockwork/src/format/formattable.dart';
import 'package:clockwork/src/format/parser.dart';
import 'package:clockwork/src/format/tokens/format_token.dart';
import 'package:clockwork/src/format/tokens/timestamp.tokens.dart' as TimestampToken;
import 'package:clockwork/src/format/tokens/interval.tokens.dart' as IntervalToken;
import 'package:clockwork/src/format/tokens/utility.tokens.dart';
import 'package:clockwork/src/core/timestamp.dart';
import 'package:clockwork/src/utils/system_util.dart';

/// Describes a [Format] for a particular [IFormattable] object.
class Format<T extends IFormattable> {
    final List<FormatToken<T>> tokens;

    const Format(this.tokens);
    /// Returns a [Format] based on the description of [str].
    Format.parse(String str) : tokens = _parseHelper<T>(str, 0);
    /// Returns a [Format] by concatenating the [Format]s in [it].
    Format.concat(Iterable<Format<T>> it) : tokens = [for (var format in it) ...format.tokens];

    static List<FormatToken> _parseHelper<T extends IFormattable>(String str, int progress) {
        if (str == '' || progress >= tokenMap[T].length) return [];
        Iterable<Match> matches;
        while ((matches = tokenMap[T].keys.elementAt(progress).allMatches(str)).isEmpty) {
            progress++;
            if (progress >= tokenMap[T].length) return [string(str)];
        }

        final results = matches.map((match) => tokenMap[T].values.elementAt(progress)(match)).toList();
        progress++;

        return results.foldX<List<FormatToken>>(
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

    String format(T ts) {
        return tokens.map((token) => token(ts)).join();
    }
}

extension TimestampFormats on Format<Timestamp> {
    /// The standard ISO8601 format: `YYYY-MM-DD[T]HH:MM:sso<Z+HH:MM>`.
    static final ISO8601 = Format<Timestamp>([separated([TimestampToken.yyyy, TimestampToken.MM, TimestampToken.dd], '-'), string('T'), separated([TimestampToken.HH, TimestampToken.MM, TimestampToken.ss]), TimestampToken.o("Z+HH:MM")]);

}

extension IntervalFormats on Format<Interval> {
    /// The standard roundtrip format for intervals: `-D:hh:mm:ss.FFFFFFFFF`.
    static final o = Format<Interval>([IntervalToken.minus, separated([IntervalToken.totalDays(1), IntervalToken.hh, IntervalToken.mm, IntervalToken.ss]), string('.'), IntervalToken.fracSecMinLength(9)]);
    /// Long format: `+hh:mm:ss`.
    static final l = Format<Interval>([IntervalToken.plus, separated([IntervalToken.hh, IntervalToken.mm, IntervalToken.ss])]);
    /// Medium format: `+hh:mm`.
    static final m = Format<Interval>([IntervalToken.plus, separated([IntervalToken.hh, IntervalToken.mm])]);
    /// Short format: `+hh`.
    static const s = Format<Interval>([IntervalToken.plus, IntervalToken.hh]);
    /// Long format without punctutation: `+hhmmss`.
    static const L = Format<Interval>([IntervalToken.plus, IntervalToken.hh, IntervalToken.mm, IntervalToken.ss]);
    /// Medium format without punctuation: `+hhmm`.
    static const M = Format<Interval>([IntervalToken.plus, IntervalToken.hh, IntervalToken.mm]);
    /// Short format without punctuation: `+hh`.
    static const S = Format<Interval>([IntervalToken.plus, IntervalToken.hh]);
}