import 'package:clockwork/src/format/formattable.dart';
import 'package:clockwork/src/locale/locale.dart';

/// A function that transforms an [IFormattable] into a string that represents info about the [IFormattable].
typedef FormatToken<T extends IFormattable> = String Function(T ts);

/// A function that transforms an [IFormattable] into a string that represents info about the [IFormattable].
/// In this case the token is [Locale]-dependent.
typedef LocaleDependentFormatToken<T extends IFormattable> = String Function(T ts, Locale locale);