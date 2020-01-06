import '../core/timestamp.dart';
import 'formattable.dart';
import 'tokens/format_token.dart';

typedef Tokenizer<F extends IFormattable> = ParseResult<F> Function(Match);

/// Utility tokenizer for tokens that don't depend on matches.
Tokenizer<F> constTokenizer<F extends IFormattable>(StatefulToken<F> token) => (match) => ParseResult(match.start, match.end, token);

/// Utility tokenizer for tokens that are built based on properties of the match.
Tokenizer<F> lambdaTokenizer<F extends IFormattable>(StatefulToken<F> Function(Match) lambda) => (match) => ParseResult(match.start, match.end, lambda(match));

class ParseResult<F extends IFormattable> {
    final int start;
    final int end;
    final StatefulToken<F> token;

    const ParseResult(this.start, this.end, this.token);
}

/// Defines the order with which parsing is done on each type of [IFormattable].
final Map<Type, Map<Pattern, Tokenizer<IFormattable>>> tokenMap = {
    Timestamp: <Pattern, Tokenizer<Timestamp>>{
      
    },
};