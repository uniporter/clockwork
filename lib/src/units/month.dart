import '../locale/locale.dart';
import '../utils/system_util.dart';
import 'unit.dart';

abstract class Month extends Unit {
    @override final Range<num> range;
    Month(int value, this.range): super(value);

    @override Month operator +(dynamic other) => (super + other) as Month;
    @override Month operator -(dynamic other) => (super - other) as Month;

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