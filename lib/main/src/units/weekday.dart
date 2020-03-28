import '../locale/locale.dart';
import '../utils/system_util.dart';
import 'unit.dart';

/// Representes a weekday. The range is fixed to be from 1 to 7, so we're assuming that all calendars have weeks of length
/// 7 (which is true for most of the widely used calendars in the world).
abstract class Weekday extends Unit {
    @override final Range<num> range = const Range(1, 7, false);

    Weekday(int value, [num len = double.infinity]) : super(value, len);

    @override Weekday operator +(int other) => (super + other) as Weekday;
    @override Weekday operator -(int other) => (super - other) as Weekday;

    /// Returns the locale-sensitive abbreviated name of the weekday.
    String toAbbr([Locale? locale]);
    /// Returns the locale-sensitive narrow name of the weekday.
    String toNarrow([Locale? locale]);
    /// Returns the locale-sensitive abbreviated name of the weekday.
    String toWide([Locale? locale]);
    /// Returns the locale-sensitive abbreviated name of the weekday. If the locale doesn't contain this info, returns null.
    String? toShort([Locale? locale]);
    /// Returns the standalone, locale-sensitive abbreviated name of the weekday.
    String toAbbrStandalone([Locale? locale]);
    /// Returns the standalone, locale-sensitive narrow name of the weekday.
    String toNarrowStandalone([Locale? locale]);
    /// Returns the standalone, locale-sensitive abbreviated name of the weekday.
    String toWideStandalone([Locale? locale]);
    /// Returns the standalone, locale-sensitive abbreviated name of the weekday. If the locale doesn't contain this info, returns null.
    String? toShortStandalone([Locale? locale]);
}