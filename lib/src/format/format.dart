import 'package:clockwork/src/format/formattable.dart';
import 'package:clockwork/src/format/parser.dart';
import 'package:clockwork/src/format/tokens/format_token.dart';
import 'package:clockwork/src/format/tokens/timestamp.tokens.dart' as TimestampToken;
import 'package:clockwork/src/format/tokens/utility.tokens.dart';
import 'package:clockwork/src/core/timestamp.dart';
import 'package:clockwork/src/utils/system_util.dart';

/// Describes a [Format] for a particular [IFormattable] object.
class Format<T extends IFormattable> {
    /// The standard ISO8601 format: `YYYY-MM-DD[T]HH:MM:sso<Z+HH:MM>`.
    static final ISO8601 = Format<Timestamp>([separated([TimestampToken.yyyy, TimestampToken.MM, TimestampToken.dd], '-'), string('T'), separated([TimestampToken.HH, TimestampToken.MM, TimestampToken.ss], ':'), TimestampToken.o("Z+HH:MM")]);

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