import '../locale/locale.dart';

enum DayPeriod {
    Midnight,
    Noon,
    Morning1,
    Morning2,
    Afternoon1,
    Evening1,
    Night1,
    Afternoon2,
    Night2,
    Evening2,
    AM,
    PM,
}

extension DayPeriodExtension on DayPeriod {
    String? _map(DayPeriods dp) {
        switch (this) {
            case DayPeriod.AM: return dp.am;
            case DayPeriod.PM: return dp.pm;
            case DayPeriod.Midnight: return dp.midnight;
            case DayPeriod.Noon: return dp.noon;
            case DayPeriod.Morning1: return dp.morning1;
            case DayPeriod.Morning2: return dp.morning2;
            case DayPeriod.Afternoon1: return dp.afternoon1;
            case DayPeriod.Evening1: return dp.evening1;
            case DayPeriod.Night1: return dp.night1;
            case DayPeriod.Afternoon2: return dp.afternoon2;
            case DayPeriod.Night2: return dp.night2;
            case DayPeriod.Evening2: return dp.evening2;
            default: return null;
        }
    }

    /// Returns the locale-sensitive abbreviated name of the day period.
    String? toAbbr([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.abbreviated);
    /// Returns the locale-sensitive narrow name of the day period.
    String? toNarrow([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.narrow) as String;
    /// Returns the locale-sensitive wide name of the day period.
    String? toWide([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.format.wide);
    /// Returns the standalone locale-sensitive abbreviated name of the day period.
    String? toAbbrStandalone([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.abbreviated);
    /// Returns the standalone locale-sensitive narrow name of the day period.
    String? toNarrowStandalone([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.narrow);
    /// Returns the standalone locale-sensitive wide name of the day period.
    String? toWideStandalone([Locale? locale]) => _map(nonNullLocale(locale).gregorianCalendar.dayPeriods.standalone.wide);
}