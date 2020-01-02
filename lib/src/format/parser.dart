import 'package:clockwork/src/format/formattable.dart';
import 'package:clockwork/src/format/tokens/format_token.dart';
import 'package:clockwork/src/format/tokens/timestamp.tokens.dart' as TimestampToken;
import 'package:clockwork/src/format/tokens/interval.tokens.dart' as IntervalToken;
import 'package:clockwork/src/format/tokens/utility.tokens.dart';
import 'package:clockwork/src/core/interval.dart';
import 'package:clockwork/src/core/timestamp.dart';

typedef Tokenizer<T extends IFormattable> = ParseResult<T> Function(Match);

/// Utility tokenizer for tokens that don't depend on matches.
Tokenizer<T> constTokenizer<T extends IFormattable>(FormatToken<T> token) => (match) => ParseResult(match.start, match.end, token);

/// Utility tokenizer for tokens that are built based on properties of the match.
Tokenizer<T> lambdaTokenizer<T extends IFormattable>(FormatToken<T> Function(Match) lambda) => (match) => ParseResult(match.start, match.end, lambda(match));

class ParseResult<T extends IFormattable> {
    final int start;
    final int end;
    final FormatToken<T> token;

    const ParseResult(this.start, this.end, this.token);
}

/// Defines the order with which parsing is done on each type of [IFormattable].
final tokenMap = <Type, Map<Pattern, Tokenizer<IFormattable>>>{
    Timestamp: <Pattern, Tokenizer<Timestamp>>{
        // Escaped strings.
        RegExp(r"(\[[^\[\]]*\])"): lambdaTokenizer((match) => string(match.group(0).replaceAll(RegExp(r"[\[\]]"), ''))),
        // Whitespaces.
        RegExp(r"(\s+)"): lambdaTokenizer((match) => space(match.end - match.start)),

        // Dot token.
        RegExp(r"\.(?<fmt>\w*)"): lambdaTokenizer((match) => TimestampToken.dot((match as RegExpMatch).namedGroup("fmt"))),

        // Timezone.
        RegExp(r"o<(?<tzFmt>[^<>]*)>"): lambdaTokenizer((match) => TimestampToken.o((match as RegExpMatch).namedGroup('tzFmt'))),
        RegExp("x"): constTokenizer(TimestampToken.x),

        // Month units.
        "MMMM": constTokenizer(TimestampToken.MMMM),
        "MMM": constTokenizer(TimestampToken.MMM),
        "MM": constTokenizer(TimestampToken.MM),
        "M": constTokenizer(TimestampToken.M),

        // Day-Of-Week units.
        "dddd": constTokenizer(TimestampToken.dddd),
        "ddd": constTokenizer(TimestampToken.ddd),
        "dd": constTokenizer(TimestampToken.dd),
        "d": constTokenizer(TimestampToken.d),

        // Year units.
        "yyyy": constTokenizer(TimestampToken.yyyy),
        "yy": constTokenizer(TimestampToken.yy),
        "uuuu": constTokenizer(TimestampToken.uuuu),
        "uuu": constTokenizer(TimestampToken.uuu),
        "uu": constTokenizer(TimestampToken.uu),
        "u": constTokenizer(TimestampToken.u),

        // Era units.
        "gg": constTokenizer(TimestampToken.gg),
        "g": constTokenizer(TimestampToken.g),

        // AM/PM units.
        "tt": constTokenizer(TimestampToken.tt),
        "t": constTokenizer(TimestampToken.t),

        // Hour units.
        "HH": constTokenizer(TimestampToken.HH),
        "hh": constTokenizer(TimestampToken.hh),
        "kk": constTokenizer(TimestampToken.kk),
        "H": constTokenizer(TimestampToken.H),
        "h": constTokenizer(TimestampToken.h),
        "k": constTokenizer(TimestampToken.k),

        // Minute units.
        "mm": constTokenizer(TimestampToken.mm),
        "m": constTokenizer(TimestampToken.m),

        // Second units:
        "ss": constTokenizer(TimestampToken.ss),
        "s": constTokenizer(TimestampToken.s),

        // Fractional second units:
        RegExp(r"(f+)"): lambdaTokenizer((match) => TimestampToken.fracSecConstLength(match.end - match.start)),
        RegExp(r"(F+)"): lambdaTokenizer((match) => TimestampToken.fracSecMinLength(match.end - match.start)),

        // Separators.
        ":": constTokenizer(TimestampToken.timeSeparator),
        "/": constTokenizer(TimestampToken.dateSeparator),
    },
    Interval: <Pattern, Tokenizer<Interval>>{
        // Escaped strings.
        RegExp(r"(\[[^\[\]]*\])"): lambdaTokenizer((match) => string(match.group(0).replaceAll(RegExp(r"[\[\]]"), ''))),
        // Whitespaces.
        RegExp(r"(\s+)"): lambdaTokenizer((match) => space(match.end - match.start)),

        // Dot token.
        RegExp(r"\.(?<fmt>\w*)"): lambdaTokenizer((match) => IntervalToken.dot((match as RegExpMatch).namedGroup("fmt"))),

        // Z indicator.
        RegExp(r"^Z(?<fmt>\w*)"): lambdaTokenizer((match) => IntervalToken.Z((match as RegExpMatch).namedGroup("fmt"))),

        // Day units.
        RegExp(r"(D+)"): lambdaTokenizer((match) => IntervalToken.totalDays(match.end - match.start)),

        // Hour units.
        "hh": constTokenizer(IntervalToken.hh),
        "h": constTokenizer(IntervalToken.h),
        RegExp(r"(H+)"): lambdaTokenizer((match) => IntervalToken.totalHours(match.end - match.start)),

        // Minute units.
        "mm": constTokenizer(IntervalToken.mm),
        "m": constTokenizer(IntervalToken.m),
        RegExp(r"(M+)"): lambdaTokenizer((match) => IntervalToken.totalMinutes(match.end - match.start)),

        // Second units.
        "ss": constTokenizer(IntervalToken.ss),
        "s": constTokenizer(IntervalToken.s),
        RegExp(r"(S+)"): lambdaTokenizer((match) => IntervalToken.totalSeconds(match.end - match.start)),

        // Fractional second units:
        RegExp(r"(f+)"): lambdaTokenizer((match) => IntervalToken.fracSecConstLength(match.end - match.start)),
        RegExp(r"(F+)"): lambdaTokenizer((match) => IntervalToken.fracSecMinLength(match.end - match.start)),

        // Sign indicators.
        "+": constTokenizer(IntervalToken.plus),
        "-": constTokenizer(IntervalToken.minus),

        // Separators.
        ":": constTokenizer(IntervalToken.separator),
    },
};