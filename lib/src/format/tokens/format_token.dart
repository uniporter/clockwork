import 'package:clockwork/src/format/formattable.dart';

/// A function that transforms an [IFormattable] into a string that represents info about the [IFormattable].
typedef FormatToken<T extends IFormattable> = String Function(T ts);