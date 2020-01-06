import '../calendar/calendar.dart';
import '../locale/locale.dart';
import 'format.dart';

/// All constructs that are formattable should include this mixin.
mixin IFormattable {
    /// Format this with [fmt].
    String format(Format fmt, [Locale? locale, Calendar? calendar]) => fmt.format(this, locale, calendar);
}