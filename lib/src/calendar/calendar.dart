import 'package:clockwork_gregorian_calendar/clockwork_gregorian_calendar.dart';

import '../core/timestamp.dart';
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

    /// Returns the year of the era.
    Year yearOfEra(Timestamp ts);

    /// Returns the year.
    Year year(Timestamp ts);

    /// Returns the week year of [ts] with respect to this [Calendar]. If the calendar doesn't support week years,
    /// do not override this method: the default implementation returns the gregorian week year.
    Year weekYear(Timestamp ts) => ts.weekyear;

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

    /// Returns the day of [ts].
    Day day(Timestamp ts) => ts.day;

    /// Returns the month of [ts].
    Month month(Timestamp ts) => ts.month;

    /// Returns the fixed day period (AM/PM) of [ts].
    FixedDayPeriod fixedDayPeriod(Timestamp ts) => ts.fixedDayPeriod;

    /// Returns the day period of [ts].
    DayPeriod dayPeriod(Timestamp ts) => ts.dayPeriod;

    @override bool operator ==(covariant Calendar other) => name == other.name;
    @override int get hashCode => name.hashCode;
}