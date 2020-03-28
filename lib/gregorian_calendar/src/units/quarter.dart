import '../../../main/clockwork.dart';

class GregorianQuarter extends Quarter {
    @override UnitBuilder<GregorianQuarter> builder = (value) => GregorianQuarter(value);

    GregorianQuarter(int value): super(value, const Range(1, 4, false), 4);

    static final Spring = GregorianQuarter(1);
    static final Summer = GregorianQuarter(2);
    static final Fall = GregorianQuarter(3);
    static final Winter = GregorianQuarter(4);

    @override String toAbbr([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.format.abbreviated[this() - 1];
    @override String toNarrow([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.format.narrow[this() - 1];
    @override String toWide([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.format.wide[this() - 1];
    @override String? toShort([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.format.short?.elementAt(this() - 1);
    @override String toAbbrStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.standalone.abbreviated[this() - 1];
    @override String toNarrowStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.standalone.narrow[this() - 1];
    @override String toWideStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.standalone.wide[this() - 1];
    @override String? toShortStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.quarters.standalone.short?.elementAt(this() - 1);
}