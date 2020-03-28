import '../formattable.dart';
import 'format_token.dart';

/// Returns a token that placeholds for nothing but spaces of size [len].
StatefulToken<F> space<F extends Formattable>(int len) => StatefulToken((t, c, l) => ''.padLeft(len, ' '), '$len spaces');

/// Returns a token that placeholds for [str].
StatefulToken<F> string<F extends Formattable>(String str) => StatefulToken((t, c, l) => str, 'string: $str');