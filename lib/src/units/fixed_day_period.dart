import '../../clockwork.dart';

enum FixedDayPeriod {
    AM,
    PM
}

extension FixedDayPeriodExtension on FixedDayPeriod {
    String? _map(DayPeriods dp, [bool alt = false]) {
        switch (this) {
            case FixedDayPeriod.AM:
                return alt ? dp.amAlt : dp.am;
            case FixedDayPeriod.PM:
                return alt ? dp.pmAlt : dp.pm;
            default:
                return null;
        }
    }

    /// Returns the locale-sensitive abbreviated name of the day period.
    String toAbbr([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.abbreviated) as String;
    /// Returns the locale-sensitive narrow name of the day period.
    String toNarrow([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.narrow) as String;
    /// Returns the locale-sensitive wide name of the day period.
    String toWide([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.wide) as String;
    /// Returns the standalone locale-sensitive abbreviated name of the day period.
    String toAbbrStandalone([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.abbreviated) as String;
    /// Returns the standalone locale-sensitive narrow name of the day period.
    String toNarrowStandalone([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.narrow) as String;
    /// Returns the standalone locale-sensitive wide name of the day period.
    String toWideStandalone([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.wide) as String;

    /// Returns the alternative locale-sensitive abbreviated name of the day period.
    String? toAbbrAlt([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.abbreviated, true);
    /// Returns the alternative locale-sensitive narrow name of the day period.
    String? toNarrowAlt([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.narrow, true);
    /// Returns the alternative locale-sensitive wide name of the day period.
    String? toWideAlt([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.wide, true);
    /// Returns the alternative standalone locale-sensitive abbreviated name of the day period.
    String? toAbbrStandaloneAlt([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.abbreviated, true);
    /// Returns the alternative standalone locale-sensitive narrow name of the day period.
    String? toNarrowStandaloneAlt([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.narrow, true);
    /// Returns the alternative standalone locale-sensitive wide name of the day period.
    String? toWideStandaloneAlt([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.wide, true);
}