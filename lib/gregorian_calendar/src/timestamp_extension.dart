import '../../main/clockwork.dart';
import 'calendar.dart';
import 'units/units.dart';
import 'utils.dart';

final Map<Timestamp, GregorianCalendarComponents> componentsCache = {};

extension GregorianCalendarExtension on Timestamp {
    void _cacheComponent() => componentsCache.containsKey(this) ? null : componentsCache[this] = GregorianCalendarComponents.fromTimestamp(this);

    GregorianCalendarComponents get _components {
        _cacheComponent();
        return componentsCache[this];
    }

    /// Returns the era.
    GregorianEra get era => year >= 1 ? GregorianEra.AD : GregorianEra.BC;
    /// Returns the year.
    GregorianYear get year => _components.year;
    /// Returns the year of era.
    GregorianYearOfEra get yearOfEra => year >= 1 ? GregorianYearOfEra(year()) : GregorianYearOfEra(year().abs() + 1);
    /// Returns the Month.
    GregorianMonth get month => _components.month;
    /// Returns the day.
    GregorianDay get day => _components.day;
    /// Returns the day of year.
    GregorianDayOfYear get dayOfYear => GregorianDayOfYear(IterableRange<GregorianMonth>(GregorianMonth.January, month, (month) => month + 1, true).fold<int>(0, (prev, curr) {
        return prev + GregorianMonth.daysPer(curr, year);
    }) + day(), year);

    /// Returns the weekday.
    GregorianWeekday get weekday {
        final sundayBasedWeekday = (daysSinceEpoch(year, month, day) - 2) % 7;
        return sundayBasedWeekday == 0 ? GregorianWeekday.Saturday : GregorianWeekday(sundayBasedWeekday);
    }

    /// Returns the quarter.
    GregorianQuarter get quarter => GregorianQuarter((month() - 1) ~/ 3 + 1);

    /// Returns the fixed day period (AM/PM).
    DayPeriod get fixedDayPeriod => hour < 12 ? DayPeriod.AM : DayPeriod.PM;

    /// Returns the day period. If the locale doesn't support flexible day period, we return null.
    DayPeriod? flexibleDayPeriod([Locale? locale]) {
        final minutesSinceMidnight = hour() * Hour.minutesPer + minute();
        try {
            final ruleMap = nonNullLocale(locale).dayPeriodsRule;
            return ruleMap[ruleMap.keys.firstWhere((range) => range.has(minutesSinceMidnight))];
        } on StateError {
            return null;
        }
    }

    /// Returns the week year.
    GregorianYear weekYear([Locale? locale]) {
        return (weekOfYear == 52 || weekOfYear == 53) && month == GregorianMonth.January ? year - 1
            : weekOfYear == 1 && month == GregorianMonth.December ? year + 1
            : year;
    }

    /// Returns the week of year.
    ///
    /// The calculation depends on the particular [locale] chosen, which has a [minDaysInWeek] and a [startOfWeek] element. A proper week in the locale
    /// starts on [startOfWeek].
    GregorianWeekOfYear weekOfYear([Locale? locale]) {
        /// The weekday of the first day of the year.
        final weekdayFirstDayOfYear = weekday - dayOfYear() + 1;
        /// How long is the incomplete week at the beginning of the year.
        final partialWeekLength = (weekdayFirstDayOfYear() - nonNullLocale(locale).weekData.firstDayOfWeek) % 7;
        /// Whether we should count the partial week as the first week of the year.
        final partialWeekCounted = partialWeekLength == 0 || partialWeekLength >= nonNullLocale(locale).weekData.minDaysInWeek;
        /// Candidate for the result, with the caveat that for days in the partial week at the beginning of the year, the variable yields 0.
        /// We adjust for it in the return statement.
        final weekOfYearCandidate = ((dayOfYear() - partialWeekLength) / 7).ceil() + (partialWeekCounted ? 1 : 0);
        return GregorianWeekOfYear(weekOfYearCandidate == 0 ? GregorianYear.weeksPer(year - 1) : weekOfYearCandidate, year);
    }

    /// Returns the week of month.
    GregorianWeekOfMonth weekOfMonth([Locale? locale]) {
        final weekdayFirstDayOfMonth = GregorianWeekday((weekday() - dayOfYear() + 1) % 7);
        final partialWeekLength = (weekdayFirstDayOfMonth() - nonNullLocale(locale).weekData.firstDayOfWeek) % 7;
        final partialWeekCounted = partialWeekLength == 0 || partialWeekLength >= nonNullLocale(locale).weekData.minDaysInWeek;
        final weekOfMonthCandidate = ((day() - partialWeekLength) / 7).ceil() + (partialWeekCounted ? 1 : 0);
        final prevMonth = month == GregorianMonth.January ? GregorianMonth.December : month - 1;
        final yearOfPrevMonth = month == GregorianMonth.January ? year - 1 : year;
        return GregorianWeekOfMonth(weekOfMonthCandidate == 0 ? GregorianMonth.weeksPer(prevMonth, yearOfPrevMonth) : weekOfMonthCandidate, month, year);
    }

    /// Return a [Timestamp] at the start of [unit].
    Timestamp startOf(Length unit) {
        return GregorianCalendar().fromComponents(
            timezone,
            unit >= Length.YEAR ? GregorianYear(0) : year,
            unit >= Length.MONTH ? GregorianMonth.January : month,
            unit >= Length.DAY ? GregorianDay(1, unit >= Length.MONTH ? GregorianMonth.January : month, unit >= Length.YEAR ? GregorianYear(0) : year) : day,
            unit >= Length.HOUR ? Hour(0) : hour,
            unit >= Length.MINUTE ? Minute(0) : minute,
            unit >= Length.SECOND ? Second(0) : second,
            unit >= Length.MILLISECOND ? Millisecond(0) : millisecond,
            unit >= Length.MICROSECOND ? Microsecond(0) : microsecond,
        );
    }

    /// Return a [Timestamp] at the end of [unit]. TODO: Implement
    Timestamp endOf(Length unit) {
        return GregorianCalendar().fromComponents(
            timezone,
            unit >= Length.YEAR ? GregorianYear(0) : year,
            unit >= Length.MONTH ? GregorianMonth.January : month,
            unit >= Length.DAY ? GregorianDay(1, unit >= Length.MONTH ? GregorianMonth.January : month, unit >= Length.YEAR ? GregorianYear(0) : year) : day,
            unit >= Length.HOUR ? Hour(0) : hour,
            unit >= Length.MINUTE ? Minute(0) : minute,
            unit >= Length.SECOND ? Second(0) : second,
            unit >= Length.MILLISECOND ? Millisecond(0) : millisecond,
            unit >= Length.MICROSECOND ? Microsecond(0) : microsecond,
        );
    }
}

/// A struct that holds the components specific to Gregorian calendars: [year], [month], and [day].
class GregorianCalendarComponents {
    final GregorianYear year;
    final GregorianMonth month;
    final GregorianDay day;

    const GregorianCalendarComponents({
        required this.year,
        required this.month,
        required this.day,
    });

    /// Create a [GregorianCalendarComponents] from a given [Timestamp]. This is the recommended way to initialize a [GregorianCalendarComponents].
    factory GregorianCalendarComponents.fromTimestamp(Timestamp ts) {
        /// This is the timezoned microsecond timestamp of [ts]. For instance, if a region has offset +01:00, the utc microsecondsSinceEpoch is `500`,
        /// then this variable is `500 + 1 * microsecondsPerHour`.
        final microsecondsSinceEpoch = ts.instant.microsecondsSinceEpoch() + ts.timezone.offset(ts.instant.microsecondsSinceEpoch()).asMicroseconds();
        final microsecondsSinceInternalEpoch = microsecondsSinceEpoch + -(ts.timezone.possibleOffsets[ts.timezone.history.firstWhere((his) => his.until >= microsecondsSinceEpoch).index] * Minute.microsecondsPer).truncate();
        final daysSinceEpoch = microsecondsSinceInternalEpoch ~/ Day.microsecondsPer;

        /// Turns epoch to `Mar 1st, 0000`.
        final daysSinceInternalEpoch = daysSinceEpoch + 719468;
        final era = (daysSinceInternalEpoch >= 0 ? daysSinceInternalEpoch : daysSinceInternalEpoch - 146096) ~/ 146097;
        final dayOfEra = daysSinceInternalEpoch - era * 146097;
        final yearOfEra = (dayOfEra - dayOfEra ~/ 1460 + dayOfEra ~/ 36524 - dayOfEra ~/ 146096) ~/ 365;

        final dayOfYear = dayOfEra - (365 * yearOfEra + yearOfEra ~/ 4 - yearOfEra ~/ 100);
        final internalMonth = (5 * dayOfYear + 2) ~/ 153;
        final finalMonth  = internalMonth + (internalMonth < 10 ? 3 : -9);
        final finalDay = dayOfYear - (153 * internalMonth + 2) ~/ 5 + 1;
        final finalYear = (yearOfEra + era * 400) + (finalMonth <= 2 ? 1 : 0);

        return GregorianCalendarComponents(
            year: GregorianYear(finalYear),
            month: GregorianMonth(finalMonth),
            day: GregorianDay(finalDay, GregorianMonth(finalMonth), GregorianYear(finalYear)),
        );
    }
}
