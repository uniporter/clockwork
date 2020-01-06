import '../locale/locale.dart';
import '../utils/system_util.dart';
import 'unit.dart';

/// Represents the notion of Year.
abstract class Year extends Unit {
    @override final Range<num> range = const Range(double.negativeInfinity, double.infinity);
    Year(int value): super(value);

    @override Year operator +(dynamic other) => (super + other) as Year;
    @override Year operator -(dynamic other) => (super - other) as Year;
}

/// Represents the notion of cyclic years.
abstract class CyclicYear extends Year {
    CyclicYear(int value): super(value);

    /// Returns the locale-specific abbreviated name of the cyclic year.
    String toAbbr([Locale? locale]);
    /// Returns the locale-specific wide name of the cyclic year.
    String toWide([Locale? locale]);
    /// Returns the locale-specific narrow name of the cyclic year.
    String toNarrow([Locale? locale]);
}