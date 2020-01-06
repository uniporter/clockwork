import '../locale/locale.dart';
import '../utils/system_util.dart';
import 'unit.dart';

abstract class Era extends Unit {
    @override final Range<num> range;
    Era(int value, this.range) : super(value);

    @override Era operator +(dynamic other) => (super + other) as Era;
    @override Era operator -(dynamic other) => (super - other) as Era;

    /// Returns the locale-sensitive name of the era.
    String toName([Locale? locale]);
    /// Returns the locale-sensitive abbreviation of the era.
    String toAbbr([Locale? locale]);
    /// Returns the locale-sensitive narrow name of the era.
    String toNarrow([Locale? locale]);
    /// Returns the alternative locale-sensitive name of the era.
    String toNameAlt([Locale? locale]);
    /// Returns the alternative locale-sensitive abbreviation of the era.
    String toAbbrAlt([Locale? locale]);
    /// Returns the alternative locale-sensitive narrow name of the era.
    String toNarrowAlt([Locale? locale]);
}