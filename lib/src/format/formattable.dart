import 'package:clockwork/src/format/format.dart';

/// All constructs that are formattable should include this mixin.
mixin IFormattable {
    /// Format [this] with [fmt].
    String format(Format fmt) => fmt.format(this);
}