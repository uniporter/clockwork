import 'package:datex/datex.dart';
import 'package:datex/src/format/format_token.dart';
import 'package:datex/src/utils/system_util.dart';

typedef Tokenizer = ParseResult Function(Match);

/// Utility tokenizer for tokens that don't depend on matches.
Tokenizer constTokenizer(FormatToken token) => (match) => ParseResult(match.start, match.end, token);

/// Utility tokenizer for tokens that are built based on properties of the match.
Tokenizer lambdaTokenizer(FormatToken Function(Match) lambda) => (match) => ParseResult(match.start, match.end, lambda(match));

class ParseResult {
    final int start;
    final int end;
    final FormatToken token;

    const ParseResult(this.start, this.end, this.token);

    @override
    String toString() {
        return "Start: $start, End: $end, Token: ${token(Timestamp.nowUTC())}";
    }
}

/// Records the order in which parsing is done, as well as the [Pattern] with which we determine which token it's placeholding for.
final Map<Pattern, Tokenizer> tokenMap = {
    // Escaped strings.
    RegExp(r"(\[[^\[\]]*\])"): lambdaTokenizer((match) => string(match.group(0).replaceAll(RegExp(r"[\[\]]"), ''))),
    // Whitespaces.
    RegExp(r"(\s+)"): lambdaTokenizer((match) => space(match.end - match.start)),

    // Month units.
    "MMMM": constTokenizer(MMMM),
    "MMM": constTokenizer(MMM),
    "MM": constTokenizer(MM),
    "Mo": constTokenizer(Mo),
    "M": constTokenizer(M),

    // Quarter units.
    "Qo": constTokenizer(Qo),
    "Q": constTokenizer(Q),

    // Day-Of-Month units.
    "DD": constTokenizer(DD),
    "Do": constTokenizer(Do),
    "D": constTokenizer(D),

    // Day-Of-Year units.
    "DDDD": constTokenizer(DDDD),
    "DDDo": constTokenizer(DDDo),
    "DDD": constTokenizer(DDD),

    // Day-Of-Week units.
    "dddd": constTokenizer(dddd),
    "ddd": constTokenizer(ddd),
    "dd": constTokenizer(dd),
    "do": constTokenizer(do_),
    "d": constTokenizer(d),
    "E": constTokenizer(E),
    "e": constTokenizer(e),

    // Week-Of-Year units.
    "ww": constTokenizer(ww),
    "wo": constTokenizer(wo),
    "w": constTokenizer(w),
    "WW": constTokenizer(WW),
    "Wo": constTokenizer(Wo),
    "W": constTokenizer(W),

    // Year units.
    "YYYY": constTokenizer(YYYY),
    "YY": constTokenizer(YY),
    "Y": constTokenizer(Y),

    // Week-Year units.
    "gggg": constTokenizer(gggg),
    "gg": constTokenizer(gg),
    "GGGG": constTokenizer(GGGG),
    "GG": constTokenizer(GG),

    // AM/PM units.
    "A": constTokenizer(A),
    "a": constTokenizer(a),

    // Hour units.
    "HH": constTokenizer(HH),
    "hh": constTokenizer(hh),
    "kk": constTokenizer(kk),
    "H": constTokenizer(H),
    "h": constTokenizer(h),
    "k": constTokenizer(k),

    // Minute units.
    "mm": constTokenizer(mm),
    "m": constTokenizer(m),

    // Second units:
    "ss": constTokenizer(ss),
    "s": constTokenizer(s),

    // Fractional second units:
    RegExp(r"(S+)"): lambdaTokenizer((match) => fracSec(match.end - match.start)),

    // Timezone units.
    "zz": constTokenizer(zz),
    "ZZ": constTokenizer(ZZ),
    "z": constTokenizer(z),
    "Z": constTokenizer(Z),

    // Timestamp units.
    "X": constTokenizer(X),
    "x": constTokenizer(x),
};

class Format {
    final List<FormatToken> tokens;

    const Format(this.tokens);

    factory Format.parse(String str) => Format(_parseHelper(str, 0));

    static List<FormatToken> _parseHelper(String str, int progress) {
        if (str == '' || progress >= tokenMap.length) return [];
        Iterable<Match> matches;
        while ((matches = tokenMap.keys.elementAt(progress).allMatches(str)).isEmpty) {
            progress++;
            if (progress >= tokenMap.length) return [string(str)];
        }

        final results = matches.map((match) => tokenMap.values.elementAt(progress)(match)).toList();
        progress++;

        return results.foldX<List<FormatToken>>(
            [if (results.first.start != 0) ..._parseHelper(str.substring(0, results.first.start), progress)],
            (prevArray, val, index, results) {
                if (prevArray.isEmpty) return prevArray..add(val.token);
                else if (index != 0 && results.elementAt(index - 1).end != val.start) return prevArray..addAll(_parseHelper(str.substring(results.elementAt(index - 1).end, val.start), progress))..add(val.token);
                else return prevArray..add(val.token);
            },
            (prevArray) {
                if (results.last.end != str.length) return prevArray..addAll(_parseHelper(str.substring(results.last.end), progress));
                else return prevArray;
            },
        );
    }

    String format(Timestamp ts) => tokens.map((token) => token(ts)).join();
}