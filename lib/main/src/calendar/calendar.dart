import '../../../gregorian_calendar/gregorian_calendar.dart';

import '../core/timestamp.dart';
import '../locale/locale.dart';
import '../units/unit.dart';

Calendar _currCalendar = GregorianCalendar();
/// Set the default [Calendar].
set currCalendar(Calendar currCalendar) {
    _currCalendar = currCalendar;
}
/// Retrieve the default [Calendar].
Calendar get currCalendar => _currCalendar;

Calendar nonNullCalendar(Calendar? calendar) => calendar ?? currCalendar;

abstract class Calendar extends Object {
    final String name = 'abstract';

    const Calendar();

    /// Returns the year of the era. If the calendar doesn't support years, the default implementation returns
    /// the Gregorian year of era.
    Year yearOfEra(Timestamp ts) => ts.yearOfEra;

    /// Returns the year. If the calendar doesn't support years, the default implementation returns the Gregorian year.
    Year year(Timestamp ts) => ts.year;

    /// Returns the week year of [ts] with respect to this [Calendar]. If the calendar doesn't support week years,
    /// the default implementation returns the gregorian week year.
    Year weekYear(Timestamp ts, [Locale? locale]) => ts.weekYear(locale);

    /// Returns the cyclic year of [ts]. If the calendar doesn't support cyclic years, the default implementation returns
    /// the Gregorian year of era number.
    Year cyclicYear(Timestamp ts) => ts.yearOfEra;

    /// Returns the relative Gregorian year of [ts]. This is defined as the [GregorianYear] for the beginning of the [Calendar]-specific
    /// year. The default implementation returns the Gregorian year of [ts].
    GregorianYear relativeGregorianYear(Timestamp ts) => ts.year;

    /// Returns the quarter of [ts]. If the calendar doesn't support quarters, the default implementation returns the Gregorian quarter.
    Quarter quarter(Timestamp ts) => ts.quarter;

    /// Returns the era of [ts] with respect to this [Calendar]. If the calendar doesn't support eras, the default implementation
    /// returns the Gregorian era.
    Era era(Timestamp ts) => ts.era;

    /// Returns the weekday of [ts]. If the calendar doesn't support weekdays, the default implementation returns the Gregorian weekday.
    Weekday weekday(Timestamp ts) => ts.weekday;

    /// Returns the week of year of [ts]. If the calendar doesn't support week of year, the default implementation returns the Gregorian week of year.
    /// If [locale] is not specified, we use the [currLocale].
    Week weekOfYear(Timestamp ts, [Locale? locale]) => ts.weekOfYear(locale);

    /// Returns the week of month of [ts]. If the calendar doesn't support week of month, the default implementation returns the Gregorian week of month.
    /// If [locale] is not specified, we use the [currLocale].
    Week weekOfMonth(Timestamp ts, [Locale? locale]) => ts.weekOfMonth(locale);

    /// Returns the day of [ts].
    Day day(Timestamp ts) => ts.day;

    /// Returns the day of year of [ts].
    Day dayOfYear(Timestamp ts) => ts.dayOfYear;

    /// Returns the month of [ts].
    Month month(Timestamp ts) => ts.month;

    /// Returns the fixed day period (AM/PM) of [ts].
    DayPeriod fixedDayPeriod(Timestamp ts) => ts.fixedDayPeriod;

    /// Returns the flexible day period of [ts]. If the given locale doesn't support flexible day periods, then the
    /// fixed day period is returned.
    DayPeriod? dayPeriod(Timestamp ts, [Locale? locale]) => ts.flexibleDayPeriod(locale);

    @override bool operator ==(covariant Calendar other) => name == other.name;
    @override int get hashCode => name.hashCode;
}