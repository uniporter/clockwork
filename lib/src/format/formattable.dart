import '../calendar/calendar.dart';
import '../locale/locale.dart' show Locale;
import 'format.dart';

/// All constructs that are formattable should include this mixin.
mixin Formattable {
    /// Format this with [fmt].
    String format(Format fmt, [Locale? locale, Calendar? calendar]) => fmt.format(this, locale, calendar);
}