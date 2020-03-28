import '../core/interval.dart';
import '../core/timestamp.dart';
import '../utils/exception.dart';
import '../utils/system_util.dart';
import 'format.dart';
import 'formattable.dart';
import 'tokens/format_token.dart';
import 'tokens/interval.tokens.dart' as IntervalTokens;
import 'tokens/timestamp.tokens.dart' as TimestampTokens;
import 'tokens/utility.tokens.dart';

/// This cache stores a one-to-one mapping between format patterns and the parsed [Format]s
final _formatCache = <Type, Map<String, Format>> {};

class _PatternSpec<F extends Formattable> {
    final _Tokenizer<F> tokenizer;
    final String identifier;
    final Pattern pattern;

    _PatternSpec(this.pattern, this.identifier, this.tokenizer);
}

/// Interface for any [Format] parser.
abstract class Parser {
    /// Returns a [Format] based on [pattern].
    Format<F> parse<F extends Formattable>(String pattern);
}

/// Default token-based format parser. Unless you have some special requests, you should use this parser. This is a singleton class.
class DefaultParser implements Parser {
    static final DefaultParser _singleton = DefaultParser._internal();
    factory DefaultParser() => _singleton;
    DefaultParser._internal();

    /// Utility tokenizer for tokens that don't depend on matches.
    static _Tokenizer<F> constTokenizer<F extends Formattable>(StatefulToken<F> token) => (match) => ParseResult(match.start, match.end, token);
    /// Utility tokenizer for tokens that are built based on properties of the match.
    static _Tokenizer<F> lambdaTokenizer<F extends Formattable>(StatefulToken<F> Function(Match) lambda) => (match) => ParseResult(match.start, match.end, lambda(match));

    @override
    Format<F> parse<F extends Formattable>(String pattern) {
        if (_formatCache[F] == null) {
            _formatCache[F] = Map<String, Format<F>>();
        }
        if (_formatCache[F][pattern] == null) {
            _formatCache[F][pattern] = Format<F>(_parseHelper(pattern, 0));
        }
        return _formatCache[F][pattern] as Format<F>;
    }

    /// Defines the order with which parsing is done on each type of [Formattable]. For each type of [Formattable], an entry is created
    /// with the type of [Formattable] as the key. The value is a [List] of "passes". Each pass is essentially a map of token identifiers to
    /// a [_PatternSpec] describing the said token. All tokens in the same pass are combined into one [RegExp] and parsed simultaneously. The parsing
    /// process goes through all the passes by the order defined here. Thus, you should make sure that all tokens in each pass do not conflict with
    /// each other.
    static final Map<Type, List<Map<String, _PatternSpec>>> tokenMap = {
        Interval: <Map<String, _PatternSpec<Interval>>>[
            {
                "str": _PatternSpec(RegExp(r"<[^<>]*?>"), "str", lambdaTokenizer((match) => string(match.input.substring(match.start + 1, match.end - 1)))),
                "space": _PatternSpec(RegExp(r"\s+?"), "space", lambdaTokenizer((match) => string(match.input.substring(match.start, match.end)))),
            },
            {
                "HH": _PatternSpec("HH", "HH", constTokenizer(IntervalTokens.HH)),
                "mm": _PatternSpec("mm", "mm", constTokenizer(IntervalTokens.mm)),
                "ss": _PatternSpec("ss", "ss", constTokenizer(IntervalTokens.ss)),
                "plus": _PatternSpec(RegExp(r"\+"), "plus", constTokenizer(IntervalTokens.plus)),
            },
            {
                "H": _PatternSpec("H", "H", constTokenizer(IntervalTokens.H)),
                "m": _PatternSpec("m", "m", constTokenizer(IntervalTokens.m)),
                "s": _PatternSpec("s", "s", constTokenizer(IntervalTokens.s)),
            },
        ],
        Timestamp: <Map<String, _PatternSpec<Timestamp>>>[
            {
                "str": _PatternSpec(RegExp(r"<[^<>]*?>"), "str", lambdaTokenizer((match) => string(match.input.substring(match.start + 1, match.end - 1)))),
                "space": _PatternSpec(RegExp(r"\s+?"), "space", lambdaTokenizer((match) => string(match.input.substring(match.start, match.end)))),
            },
            {
                "OOOO": _PatternSpec("OOOO", "OOOO", constTokenizer(TimestampTokens.OOOO)),
                "GGGGG": _PatternSpec("GGGGG", "GGGGG", constTokenizer(TimestampTokens.GGGGG)),
                "YPlus": _PatternSpec(RegExp(r"Y{3,}"), "YPlus", lambdaTokenizer((match) => TimestampTokens.YPlus(match.end - match.start))),
                "yPlus": _PatternSpec(RegExp(r"y{3,}"), "yPlus", lambdaTokenizer((match) => TimestampTokens.yPlus(match.end - match.start))),
                "uPlus": _PatternSpec(RegExp(r"u{2,}"), "uPlus", lambdaTokenizer((match) => TimestampTokens.uPlus(match.end - match.start))),
                "UUUUU": _PatternSpec("UUUUU", "UUUUU", constTokenizer(TimestampTokens.UUUUU)),
                "rPlus": _PatternSpec(RegExp(r"r{2,}"), "rPlus", lambdaTokenizer((match) => TimestampTokens.rPlus(match.end - match.start))),
                "QQQQQ": _PatternSpec("QQQQQ", "QQQQQ", constTokenizer(TimestampTokens.QQQQQ)),
                "qqqqq": _PatternSpec("qqqqq", "qqqqq", constTokenizer(TimestampTokens.qqqqq)),
                "MMMMM": _PatternSpec("MMMMM", "MMMMM", constTokenizer(TimestampTokens.MMMMM)),
                "LLLLL": _PatternSpec("LLLLL", "LLLLL", constTokenizer(TimestampTokens.LLLLL)),
                "ww": _PatternSpec("ww", "ww", constTokenizer(TimestampTokens.ww)),
                "W": _PatternSpec("W", "W", constTokenizer(TimestampTokens.W)),
                "dd": _PatternSpec("dd", "dd", constTokenizer(TimestampTokens.dd)),
                "DDD": _PatternSpec("DDD", "DDD", constTokenizer(TimestampTokens.DDD)),
                "EEEEEE": _PatternSpec("EEEEEE", "EEEEEE", constTokenizer(TimestampTokens.EEEEEE)),
                "eeeeee": _PatternSpec("eeeeee", "eeeeee", constTokenizer(TimestampTokens.eeeeee)),
                "cccccc": _PatternSpec("cccccc", "cccccc", constTokenizer(TimestampTokens.cccccc)),
                "aaaaa": _PatternSpec("aaaaa", "aaaaa", constTokenizer(TimestampTokens.aaaaa)),
                "bbbbb": _PatternSpec("bbbbb", "bbbbb", constTokenizer(TimestampTokens.bbbbb)),
                "BBBBB": _PatternSpec("BBBBB", "BBBBB", constTokenizer(TimestampTokens.BBBBB)),
                "HH": _PatternSpec("HH", "HH", constTokenizer(TimestampTokens.HH)),
                "KK": _PatternSpec("KK", "KK", constTokenizer(TimestampTokens.KK)),
                "mm": _PatternSpec("mm", "mm", constTokenizer(TimestampTokens.mm)),
                "ss": _PatternSpec("ss", "ss", constTokenizer(TimestampTokens.ss)),
                "SPlus": _PatternSpec(RegExp(r"S+"), "SPlus", lambdaTokenizer((match) => TimestampTokens.SPlus(match.end - match.start))),
                "XXXXX": _PatternSpec("XXXXX", "XXXXX", constTokenizer(TimestampTokens.XXXXX)),
                "xxxxx": _PatternSpec("xxxxx", "xxxxx", constTokenizer(TimestampTokens.xxxxx)),
                "ZZZZZ": _PatternSpec("ZZZZZ", "ZZZZZ", constTokenizer(TimestampTokens.ZZZZZ)),
            },
            {
                "GGGG": _PatternSpec("GGGG", "GGGG", constTokenizer(TimestampTokens.GGGG)),
                "yy": _PatternSpec("yy", "yy", constTokenizer(TimestampTokens.yy)),
                "YY": _PatternSpec("YY", "YY", constTokenizer(TimestampTokens.YY)),
                "u": _PatternSpec("u", "u", constTokenizer(TimestampTokens.u)),
                "UUUU": _PatternSpec("UUUU", "UUUU", constTokenizer(TimestampTokens.UUUU)),
                "r": _PatternSpec("r", "r", constTokenizer(TimestampTokens.r)),
                "QQQQ": _PatternSpec("QQQQ", "QQQQ", constTokenizer(TimestampTokens.QQQQ)),
                "qqqq": _PatternSpec("qqqq", "qqqq", constTokenizer(TimestampTokens.qqqq)),
                "MMMM": _PatternSpec("MMMM", "MMMM", constTokenizer(TimestampTokens.MMMM)),
                "LLLL": _PatternSpec("LLLL", "LLLL", constTokenizer(TimestampTokens.LLLL)),
                "w": _PatternSpec("w", "w", constTokenizer(TimestampTokens.w)),
                "d": _PatternSpec("d", "d", constTokenizer(TimestampTokens.d)),
                "DD": _PatternSpec("DD", "DD", constTokenizer(TimestampTokens.DD)),
                "EEEEE": _PatternSpec("EEEEE", "EEEEE", constTokenizer(TimestampTokens.EEEEE)),
                "eeeee": _PatternSpec("eeeee", "eeeee", constTokenizer(TimestampTokens.eeeee)),
                "ccccc": _PatternSpec("ccccc", "ccccc", constTokenizer(TimestampTokens.ccccc)),
                "aaaa": _PatternSpec("aaaa", "aaaa", constTokenizer(TimestampTokens.aaaa)),
                "bbbb": _PatternSpec("bbbb", "bbbb", constTokenizer(TimestampTokens.bbbb)),
                "BBBB": _PatternSpec("BBBB", "BBBB", constTokenizer(TimestampTokens.BBBB)),
                "H": _PatternSpec("H", "H", constTokenizer(TimestampTokens.H)),
                "K": _PatternSpec("K", "K", constTokenizer(TimestampTokens.K)),
                "m": _PatternSpec("m", "m", constTokenizer(TimestampTokens.m)),
                "s": _PatternSpec("s", "s", constTokenizer(TimestampTokens.s)),
                "XXXX": _PatternSpec("XXXX", "XXXX", constTokenizer(TimestampTokens.XXXX)),
                "xxxx": _PatternSpec("xxxx", "xxxx", constTokenizer(TimestampTokens.xxxx)),
                "ZZZZ": _PatternSpec("ZZZZ", "ZZZZ", constTokenizer(TimestampTokens.ZZZZ)),
            },
            {
                "GGG": _PatternSpec("GGG", "GGG", constTokenizer(TimestampTokens.GGG)),
                "y": _PatternSpec("y", "y", constTokenizer(TimestampTokens.y)),
                "Y": _PatternSpec("Y", "Y", constTokenizer(TimestampTokens.Y)),
                "UUU": _PatternSpec("UUU", "UUU", constTokenizer(TimestampTokens.UUU)),
                "QQQ": _PatternSpec("QQQ", "QQQ", constTokenizer(TimestampTokens.QQQ)),
                "qqq": _PatternSpec("qqq", "qqq", constTokenizer(TimestampTokens.qqq)),
                "MMM": _PatternSpec("MMM", "MMM", constTokenizer(TimestampTokens.MMM)),
                "LLL": _PatternSpec("LLL", "LLL", constTokenizer(TimestampTokens.LLL)),
                "D": _PatternSpec("D", "D", constTokenizer(TimestampTokens.D)),
                "EEEE": _PatternSpec("EEEE", "EEEE", constTokenizer(TimestampTokens.EEEE)),
                "eeee": _PatternSpec("eeee", "eeee", constTokenizer(TimestampTokens.eeee)),
                "cccc": _PatternSpec("cccc", "cccc", constTokenizer(TimestampTokens.cccc)),
                "aaa": _PatternSpec("aaa", "aaa", constTokenizer(TimestampTokens.aaa)),
                "bbb": _PatternSpec("bbb", "bbb", constTokenizer(TimestampTokens.bbb)),
                "BBB": _PatternSpec("BBB", "BBB", constTokenizer(TimestampTokens.BBB)),
                "XXX": _PatternSpec("XXX", "XXX", constTokenizer(TimestampTokens.XXX)),
                "xxx": _PatternSpec("xxx", "xxx", constTokenizer(TimestampTokens.xxx)),
                "ZZZ": _PatternSpec("ZZZ", "ZZZ", constTokenizer(TimestampTokens.ZZZ)),
            },
            {
                "GG": _PatternSpec("GG", "GG", constTokenizer(TimestampTokens.GG)),
                "UU": _PatternSpec("UU", "UU", constTokenizer(TimestampTokens.UU)),
                "QQ": _PatternSpec("QQ", "QQ", constTokenizer(TimestampTokens.QQ)),
                "qq": _PatternSpec("qq", "qq", constTokenizer(TimestampTokens.qq)),
                "MM": _PatternSpec("MM", "MM", constTokenizer(TimestampTokens.MM)),
                "LL": _PatternSpec("LL", "LL", constTokenizer(TimestampTokens.LL)),
                "EEE": _PatternSpec("EEE", "EEE", constTokenizer(TimestampTokens.EEE)),
                "eee": _PatternSpec("eee", "eee", constTokenizer(TimestampTokens.eee)),
                "ccc": _PatternSpec("ccc", "ccc", constTokenizer(TimestampTokens.ccc)),
                "aa": _PatternSpec("aa", "aa", constTokenizer(TimestampTokens.aa)),
                "bb": _PatternSpec("bb", "bb", constTokenizer(TimestampTokens.bb)),
                "BB": _PatternSpec("BB", "BB", constTokenizer(TimestampTokens.BB)),
                "XX": _PatternSpec("XX", "XX", constTokenizer(TimestampTokens.XX)),
                "xx": _PatternSpec("xx", "xx", constTokenizer(TimestampTokens.xx)),
                "ZZ": _PatternSpec("ZZ", "ZZ", constTokenizer(TimestampTokens.ZZ)),
            },
            {
                "G": _PatternSpec("G", "G", constTokenizer(TimestampTokens.G)),
                "U": _PatternSpec("U", "U", constTokenizer(TimestampTokens.U)),
                "Q": _PatternSpec("Q", "Q", constTokenizer(TimestampTokens.Q)),
                "q": _PatternSpec("q", "q", constTokenizer(TimestampTokens.q)),
                "M": _PatternSpec("M", "M", constTokenizer(TimestampTokens.M)),
                "L": _PatternSpec("L", "L", constTokenizer(TimestampTokens.L)),
                "E": _PatternSpec("E", "E", constTokenizer(TimestampTokens.E)),
                "e": _PatternSpec("e", "e", constTokenizer(TimestampTokens.e)),
                "c": _PatternSpec("c", "c", constTokenizer(TimestampTokens.c)),
                "a": _PatternSpec("a", "a", constTokenizer(TimestampTokens.a)),
                "b": _PatternSpec("b", "b", constTokenizer(TimestampTokens.b)),
                "B": _PatternSpec("B", "B", constTokenizer(TimestampTokens.B)),
                "X": _PatternSpec("X", "X", constTokenizer(TimestampTokens.X)),
                "x": _PatternSpec("x", "x", constTokenizer(TimestampTokens.x)),
                "Z": _PatternSpec("Z", "Z", constTokenizer(TimestampTokens.Z)),
            }
        ],
    };

    static final Map<Type, List<RegExp>> parseOrder = tokenMap.map((type, passList) => MapEntry(type, passList.map((pass) {
        return RegExp(pass.values.map((patternSpec) {
            final pattern = patternSpec.pattern;
            return "(?<${patternSpec.identifier}>${pattern is RegExp ? pattern.pattern : pattern is String ? pattern : throw CriticalErrorException()})";
        }).join('|'));
    }).toList()));

    List<StatefulToken<F>> _parseHelper<F extends Formattable>(String str, int progress) {
        final List tm = tokenMap[F];
        final List po = parseOrder[F];
        if (str == '' || progress >= tm.length) return [string<F>(str)];
        Iterable<RegExpMatch> matches;
        while ((matches = po[progress].allMatches(str)).isEmpty) {
            progress++;
            if (progress >= tm.length) {
                return [string<F>(str)];
            }
        }

        final results = matches.map((match) {
            return tm[progress][tm[progress].keys.firstWhere((identifier) => match.namedGroup(identifier) != null)].tokenizer(match) as ParseResult<F>;
        }).toList();
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
}

typedef _Tokenizer<F extends Formattable> = ParseResult<F> Function(Match);

class ParseResult<F extends Formattable> {
    final int start;
    final int end;
    final StatefulToken<F> token;

    const ParseResult(this.start, this.end, this.token);
}