import '../locale/locale.dart';
import '../utils/system_util.dart';
import 'unit.dart';

abstract class Quarter extends Unit {
    @override final Range<num> range;

    Quarter(int value, this.range, [num len = double.infinity]) : super(value, len);

    @override Quarter operator +(int other) => (super + other) as Quarter;
    @override Quarter operator -(int other) => (super - other) as Quarter;

    /// Returns the locale-sensitive abbreviated name of the month.
    String toAbbr([Locale? locale]);
    /// Returns the locale-sensitive narrow name of the month.
    String toNarrow([Locale? locale]);
    /// Returns the locale-sensitive abbreviated name of the month.
    String toWide([Locale? locale]);
    /// Returns the locale-sensitive abbreviated name of the month. If the locale doesn't contain this info, returns null.
    String? toShort([Locale? locale]);
    /// Returns the standalone, locale-sensitive abbreviated name of the month.
    String toAbbrStandalone([Locale? locale]);
    /// Returns the standalone, locale-sensitive narrow name of the month.
    String toNarrowStandalone([Locale? locale]);
    /// Returns the standalone, locale-sensitive abbreviated name of the month.
    String toWideStandalone([Locale? locale]);
    /// Returns the standalone, locale-sensitive abbreviated name of the month. If the locale doesn't contain this info, returns null.
    String? toShortStandalone([Locale? locale]);
}