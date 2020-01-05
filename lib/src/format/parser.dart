import 'package:clockwork/src/core/timestamp.dart';
import 'package:clockwork/src/format/formattable.dart';
import 'package:clockwork/src/format/tokens/format_token.dart';

typedef Tokenizer<T extends IFormattable, M extends ReducibleMetadata<T>> = ParseResult<T, M> Function(Match);

/// Utility tokenizer for tokens that don't depend on matches.
Tokenizer<T, M> constTokenizer<T extends IFormattable, M extends ReducibleMetadata<T>>(StatefulToken<T, M> token) => (match) => ParseResult(match.start, match.end, token);

/// Utility tokenizer for tokens that are built based on properties of the match.
Tokenizer<T, M> lambdaTokenizer<T extends IFormattable, M extends ReducibleMetadata<T>>(StatefulToken<T, M> Function(Match) lambda) => (match) => ParseResult(match.start, match.end, lambda(match));

class ParseResult<T extends IFormattable, M extends ReducibleMetadata<T>> {
    final int start;
    final int end;
    final StatefulToken<T, M> token;

    const ParseResult(this.start, this.end, this.token);
}

/// Defines the order with which parsing is done on each type of [IFormattable].
final tokenMap = <Type, Map<Pattern, Tokenizer<IFormattable, ReducibleMetadata>>>{
    Timestamp: <Pattern, Tokenizer<Timestamp, ReducibleMetadata<Timestamp>>>{
      
    },
};