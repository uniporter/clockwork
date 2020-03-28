import '../../../main/clockwork.dart';

/// Era as defined in the Gregorian Calendar. There is a total of 2 eras, [BC] and [AD], which correspond to years
/// `[-∞, 0]` and `[1, ∞]`, respectively.
class GregorianEra extends Era {
    @override final UnitBuilder<GregorianEra> builder = (value) => GregorianEra(value);

    GregorianEra(int value): super(value, const Range(0, 1, false), 2);

    static final AD = GregorianEra(1);
    static final BC = GregorianEra(0);

    @override String toName([Locale? locale]) => this != AD ? nonNullLocale(locale).gregorianCalendar.eras.name.pre : nonNullLocale(locale).gregorianCalendar.eras.name.post;
    @override String toAbbr([Locale? locale]) => this != AD ? nonNullLocale(locale).gregorianCalendar.eras.abbr.pre : nonNullLocale(locale).gregorianCalendar.eras.abbr.post;
    @override String toNarrow([Locale? locale]) => this != AD ? nonNullLocale(locale).gregorianCalendar.eras.narrow.pre : nonNullLocale(locale).gregorianCalendar.eras.narrow.post;
    @override String toNameAlt([Locale? locale]) => this != AD ? nonNullLocale(locale).gregorianCalendar.eras.name.preAlt : nonNullLocale(locale).gregorianCalendar.eras.name.postAlt;
    @override String toAbbrAlt([Locale? locale]) => this != AD ? nonNullLocale(locale).gregorianCalendar.eras.abbr.preAlt : nonNullLocale(locale).gregorianCalendar.eras.abbr.postAlt;
    @override String toNarrowAlt([Locale? locale]) => this != AD ? nonNullLocale(locale).gregorianCalendar.eras.narrow.preAlt : nonNullLocale(locale).gregorianCalendar.eras.narrow.postAlt;
}
