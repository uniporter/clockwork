import 'package:clockwork/src/calendar/calendar.dart';
import 'package:clockwork/src/format/format.dart';
import 'package:clockwork/src/locale/locale.dart';

/// All constructs that are formattable should include this mixin.
mixin IFormattable {
    /// Format [this] with [fmt].
    String format(Format fmt, [Locale? locale, Calendar? calendar]) => fmt.format(this, locale, calendar);
}