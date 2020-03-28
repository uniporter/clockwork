
import '../../../main/clockwork.dart';

class GregorianWeekday extends Weekday {
    @override final UnitBuilder<GregorianWeekday> builder = (value) => GregorianWeekday(value);

    GregorianWeekday(int value): super(value, 7);

    static final Sunday = GregorianWeekday(1);
    static final Monday = GregorianWeekday(2);
    static final Tuesday = GregorianWeekday(3);
    static final Wednesday = GregorianWeekday(4);
    static final Thursday = GregorianWeekday(5);
    static final Friday = GregorianWeekday(6);
    static final Saturday = GregorianWeekday(7);

    @override GregorianWeekday operator +(int other) => (super + other) as GregorianWeekday;
    @override GregorianWeekday operator -(int other) => (super - other) as GregorianWeekday;

    /// Prints the number representing the weekday based on [locale.format.weekData.firstDayOfWeek].
    @override String toString([Locale? locale]) {
        final firstDayOfWeek = nonNullLocale(locale).weekData.firstDayOfWeek;
        return ((this() - firstDayOfWeek) % 7 + 1).toString();
    }

    @override String toAbbr([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.abbreviated[index];
    @override String toNarrow([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.narrow[index];
    @override String toWide([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.wide[index];
    @override String? toShort([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.format.short?.[index];
    @override String toAbbrStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.abbreviated[index];
    @override String toNarrowStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.narrow[index];
    @override String toWideStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.wide[index];
    @override String? toShortStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.weekdays.standalone.short?.[index];
}