import '../formattable.dart';
import 'format_token.dart';

/// Returns a token that placeholds for nothing but spaces of size [len].
StatefulToken<F> space<F extends IFormattable>(int len) => StatefulToken((t, c, l) => ''.padLeft(len, ' '));

/// Returns a token that placeholds for [str].
StatefulToken<F> string<F extends IFormattable>(String str) => StatefulToken((t, c, l) => str);