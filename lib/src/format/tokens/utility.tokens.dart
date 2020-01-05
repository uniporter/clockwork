import 'package:clockwork/src/format/tokens/format_token.dart';
import 'package:clockwork/src/format/formattable.dart';

/// Returns a token that placeholds for nothing but spaces of size [len].
StatefulToken<T, DummyTokenMetadata<T>> space<T extends IFormattable>(int len) => StatefulToken((t, [m]) => ''.padLeft(len, ' '));

/// Returns a token that placeholds for [str].
StatefulToken<T, DummyTokenMetadata<T>> string<T extends IFormattable>(String str) => StatefulToken((t, [m]) => str);