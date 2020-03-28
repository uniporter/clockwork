import '../../../main/clockwork.dart';

import 'units.dart';
import '../utils.dart';

class GregorianMonth extends Month {
    @override UnitBuilder<GregorianMonth> builder = (value) => GregorianMonth(value);

    static final daysInMonthMap = <GregorianMonth, int?>{
        January: 31,
        February: null,
        March: 31,
        April: 30,
        May: 31,
        June: 30,
        July: 31,
        August: 31,
        September: 30,
        October: 31,
        November: 30,
        December: 31,
    };
    GregorianMonth(int value) : super(value, const Range(1, 12, false), 12);

    int get hashCode => this.value.hashCode;

    static final January = GregorianMonth(1);
    static final February = GregorianMonth(2);
    static final March = GregorianMonth(3);
    static final April = GregorianMonth(4);
    static final May = GregorianMonth(5);
    static final June = GregorianMonth(6);
    static final July = GregorianMonth(7);
    static final August = GregorianMonth(8);
    static final September = GregorianMonth(9);
    static final October = GregorianMonth(10);
    static final November = GregorianMonth(11);
    static final December = GregorianMonth(12);

    static int weeksPer(GregorianMonth month, GregorianYear year, [Locale? locale, GregorianWeekday? firstDayOfMonth]) {
        if (firstDayOfMonth == null) {
            final zeroBasedWeekdayFirstDayOfMonth = (daysSinceEpoch(year, month, GregorianDay(1, month, year)) - 2) % 7;
            firstDayOfMonth = zeroBasedWeekdayFirstDayOfMonth == 0 ? GregorianWeekday.Saturday : GregorianWeekday(zeroBasedWeekdayFirstDayOfMonth);
        }

        final partialWeekLength = (nonNullLocale(locale).weekData.firstDayOfWeek - firstDayOfMonth()) % 7;
        final isFirstDayCounted = partialWeekLength == 0 || partialWeekLength >= nonNullLocale(locale).weekData.minDaysInWeek;

        /// The first day of *next month*.
        final firstDayOfNextMonth = (firstDayOfMonth() + daysPer(month, year)) % 7 != 0 ? GregorianWeekday((firstDayOfMonth() + daysPer(month, year)) % 7) : GregorianWeekday.Saturday;
        final nextPartialWeekLength = (nonNullLocale(locale).weekData.firstDayOfWeek - firstDayOfNextMonth()) % 7;
        final isLastWeekOfMonthCounted = nextPartialWeekLength != 0 && nextPartialWeekLength < nonNullLocale(locale).weekData.minDaysInWeek;

        final daysInMonth = daysPer(month, year);
        return (daysInMonth / 7).ceil() + (isFirstDayCounted ? 1 : 0) + (isLastWeekOfMonthCounted ? 0 : -1);
    }
    static int daysPer(GregorianMonth month, GregorianYear year) => daysInMonthMap[month] ?? (GregorianYear.isLeapYear(year) ? 29 : 28);
    static int hoursPer(GregorianMonth month, GregorianYear year) => daysPer(month, year) * Day.hoursPer;
    static int minutesPer(GregorianMonth month, GregorianYear year) => daysPer(month, year) * Day.minutesPer;
    static int secondsPer(GregorianMonth month, GregorianYear year) => daysPer(month, year) * Day.secondsPer;
    static int millisecondsPer(GregorianMonth month, GregorianYear year) => daysPer(month, year) * Day.millisecondsPer;
    static int microsecondsPer(GregorianMonth month, GregorianYear year) => daysPer(month, year) * Day.microsecondsPer;

    @override GregorianMonth operator +(int other) => (super + other) as GregorianMonth;
    @override GregorianMonth operator -(int other) => (super - other) as GregorianMonth;

    @override String toAbbr([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.format.abbreviated[this.value - 1];
    @override String toNarrow([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.format.narrow[this.value - 1];
    @override String toWide([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.format.wide[this.value - 1];
    @override String? toShort([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.format.short?.elementAt(this.value - 1);
    @override String toAbbrStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.standalone.abbreviated[this.value - 1];
    @override String toNarrowStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.standalone.narrow[this.value - 1];
    @override String toWideStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.standalone.wide[this.value - 1];
    @override String? toShortStandalone([Locale? locale]) => nonNullLocale(locale).gregorianCalendar.months.standalone.short?.elementAt(this.value - 1);
}