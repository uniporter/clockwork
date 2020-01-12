import 'package:json_annotation/json_annotation.dart';

import '../units/unit.dart';
import '../utils/exception.dart';
import '../utils/system_util.dart';
import 'en.locale.dart';

part 'locale.g.dart';

Locale _currLocale = en;
/// Set the current [Locale].
set currLocale(Locale locale) {
    _currLocale = locale;
}
/// Retrieve the current [Locale].4
Locale get currLocale => _currLocale;

/// Transforms a possibly-null [locale] into a non-null [Locale]. If [locale] is null, then we return the [currLocale].
Locale nonNullLocale(Locale? locale) => locale ?? currLocale;

@JsonSerializable()
class Locale {
    @JsonKey(nullable: false)
    final GregorianCalendarData gregorianCalendar;
    /// A map of the flexible day periods and the range of time they cover.
    @JsonKey(toJson: _dayPeriodsRuleToJson, fromJson: _dayPeriodsRuleFromJson, name: 'dayPeriodsRules')
    final Map<Range<int>, DayPeriod> dayPeriodsRule;
    @JsonKey(nullable: false)
    final WeekData weekData;
    @JsonKey(nullable: false)
    final Format format;

    const Locale(this.gregorianCalendar, this.dayPeriodsRule, this.weekData, this.format);

    factory Locale.fromJson(Map<String, dynamic> json) => _$LocaleFromJson(json);

    static Map<Range<int>, DayPeriod> _dayPeriodsRuleFromJson(Map<String, Map<String, String>> json) {
        int _parseRangeValue(String val) {
            final components = val.split(':');
            final hours = int.parse(components.first);
            final minutes = int.parse(components[1]);

            return hours * 60 + minutes;
        }

        return Map.fromEntries(json.entries.expand<MapEntry<Range<int>, DayPeriod>>((entry) {
            var key = entry.key;
            final val = entry.value;
            if (val.containsKey('_at')) {
                final at = _parseRangeValue(val['_at']);
                final period = DayPeriod.values.firstWhere((val) => val.toString().split('.').last.toLowerCase() == key);
                return [MapEntry(Range(at, at, false), period)];
            } else if (val.containsKey('_before') && val.containsKey('_from')) {
                key = key == 'am-alt-variant' ? 'amAlt' : key == 'pm-alt-variant' ? 'pmAlt' : key;
                final from = _parseRangeValue(val['_from']);
                final before = _parseRangeValue(val['_before']);
                final period = DayPeriod.values.firstWhere((val) => val.toString().split('.').last.toLowerCase() == key);
                if (from < before) {
                    // The range doesn't cover midnight.
                    return [MapEntry(Range(from, before), period)];
                } else {
                    // The range covers midnight, so we have to break it in two.
                    return [
                        MapEntry(Range(from, 1440), period),
                        MapEntry(Range(0, before), period),
                    ];
                }
            } else {
                throw GeneralException("Invalid locale data: locale data contain invalid day period rules information and might have been corrupted.");
            }
        }));
    }

    static Map<String, dynamic> _dayPeriodsRuleToJson(Map<Range<int>, DayPeriod> rule) {
        /// TODO This is not behaving as expected. Tweak soon.
        return rule.map((range, period) {
            final periodNameLiteral = period.toString().split('.').last;
            final periodName = periodNameLiteral == 'amAlt' ? 'am-alt-variant' : periodNameLiteral == 'pmAlt' ? 'pm-alt-variant' : periodNameLiteral;
            final rangeDescription = (range.floor == range.ceiling)
                ? {"at": "${range.floor ~/ 60}:${range.floor % 60}"}
                : {"before": "${range.ceiling ~/ 60}:${range.ceiling % 60}", "from": "${range.floor ~/ 60}:${range.floor % 60}"};

            return MapEntry(periodName, rangeDescription);
        });
    }
}

@JsonSerializable()
class WeekData {
    @JsonKey(nullable: false)
    final int firstDayOfWeek;
    @JsonKey(nullable: false)
    final int minDaysInWeek;

    const WeekData(this.firstDayOfWeek, this.minDaysInWeek);

    factory WeekData.fromJson(Map<String, dynamic> json) => _$WeekDataFromJson(json);

}

@JsonSerializable()
class GregorianCalendarData {
    @JsonKey(nullable: false)
    final GeneralContext months;
    @JsonKey(nullable: false)
    final GeneralContext weekdays;
    @JsonKey(nullable: false)
    final GeneralContext quarters;
    @JsonKey(nullable: false)
    final DayPeriodsContext dayPeriods;
    @JsonKey(nullable: false)
    final ErasWidth eras;

    const GregorianCalendarData(this.months, this.weekdays, this.quarters, this.dayPeriods, this.eras);

    factory GregorianCalendarData.fromJson(Map<String, dynamic> json) => _$GregorianCalendarDataFromJson(json);

}

@JsonSerializable()
class GeneralContext {
    @JsonKey(nullable: false)
    final PropertyLength format;
    @JsonKey(name: 'stand-alone', nullable: false)
    final PropertyLength standalone;

    const GeneralContext(this.format, this.standalone);

    factory GeneralContext.fromJson(Map<String, dynamic> json) => _$GeneralContextFromJson(json);

}

@JsonSerializable()
class DayPeriodsContext {
    @JsonKey(nullable: false)
    final DayPeriodsWidth format;
    @JsonKey(name: 'stand-alone', nullable: false)
    final DayPeriodsWidth standalone;

    const DayPeriodsContext(this.format, this.standalone);

    factory DayPeriodsContext.fromJson(Map<String, dynamic> json) => _$DayPeriodsContextFromJson(json);

}

@JsonSerializable()
class DayPeriodsWidth {
    @JsonKey(nullable: false)
    final DayPeriods abbreviated;
    @JsonKey(nullable: false)
    final DayPeriods narrow;
    @JsonKey(nullable: false)
    final DayPeriods wide;

    const DayPeriodsWidth(this.abbreviated, this.narrow, this.wide);

    factory DayPeriodsWidth.fromJson(Map<String, dynamic> json) => _$DayPeriodsWidthFromJson(json);

}

@JsonSerializable()
class DayPeriods {
    final String? midnight;
    @JsonKey(nullable: false)
    final String am;
    final String? noon;
    @JsonKey(nullable: false)
    final String pm;
    final String? morning1;
    final String? morning2;
    final String? afternoon1;
    final String? evening1;
    final String? night1;
    final String? afternoon2;
    @JsonKey(name: 'am-alt-variant')
    final String? amAlt;
    @JsonKey(name: 'pm-alt-variant')
    final String? pmAlt;
    final String? night2;
    final String? evening2;

    const DayPeriods(this.am, this.pm, [this.midnight, this.noon, this.morning1, this.morning2, this.afternoon1, this.evening1, this.night1, this.afternoon2, this.amAlt, this.pmAlt, this.night2, this.evening2]);

    factory DayPeriods.fromJson(Map<String, dynamic> json) => _$DayPeriodsFromJson(json);

}

@JsonSerializable()
class Eras {
    @JsonKey(name: '0', nullable: false)
    final String pre;
    @JsonKey(name: '1', nullable: false)
    final String post;
    @JsonKey(name: '0-alt-variant', nullable: false)
    final String preAlt;
    @JsonKey(name: '1-alt-variant', nullable: false)
    final String postAlt;

    const Eras(this.pre, this.post, this.preAlt, this.postAlt);

    factory Eras.fromJson(Map<String, dynamic> json) => _$ErasFromJson(json);

}

@JsonSerializable()
class ErasWidth {
    @JsonKey(name: 'eraNames', nullable: false)
    final Eras name;
    @JsonKey(name: 'eraAbbr', nullable: false)
    final Eras abbr;
    @JsonKey(name: 'eraNarrow', nullable: false)
    final Eras narrow;

    const ErasWidth(this.name, this.abbr, this.narrow);

    factory ErasWidth.fromJson(Map<String, dynamic> json) => _$ErasWidthFromJson(json);

}

@JsonSerializable()
class PropertyLength {
    @JsonKey(nullable: false)
    final List<String> abbreviated;
    @JsonKey(nullable: false)
    final List<String> narrow;
    @JsonKey(nullable: false)
    final List<String> wide;
    final List<String>? short;

    const PropertyLength(this.abbreviated, this.narrow, this.wide, [this.short]);

    factory PropertyLength.fromJson(Map<String, dynamic> json) => _$PropertyLengthFromJson(json);

}

@JsonSerializable()
class Format {
    @JsonKey(nullable: false, name: "dateFormats")
    final FormatLength date;
    @JsonKey(nullable: false, name: "timeFormats")
    final FormatLength time;
    @JsonKey(nullable: false, name: "dateTimeFormats")
    final FormatLength datetime;
    @JsonKey(nullable: false, name: "")
    final BuiltInTimestampFormats builtIn;

    const Format(this.date, this.time, this.datetime, this.builtIn);

    factory Format.fromJson(Map<String, dynamic> json) => _$FormatFromJson(json);

}

@JsonSerializable()
class BuiltInTimestampFormats {
    @JsonKey(nullable: false)
    final String Bh;
    @JsonKey(nullable: false)
    final String Bhm;
    @JsonKey(nullable: false)
    final String Bhms;
    @JsonKey(nullable: false)
    final String d;
    @JsonKey(nullable: false)
    final String E;
    @JsonKey(nullable: false)
    final String EBhm;
    @JsonKey(nullable: false)
    final String EBhms;
    @JsonKey(nullable: false)
    final String Ed;
    @JsonKey(nullable: false)
    final String Ehm;
    @JsonKey(nullable: false)
    final String EHm;
    @JsonKey(nullable: false)
    final String Ehms;
    @JsonKey(nullable: false)
    final String EHms;
    @JsonKey(nullable: false)
    final String Gy;
    @JsonKey(nullable: false)
    final String GyMMM;
    @JsonKey(nullable: false)
    final String GyMMMd;
    @JsonKey(nullable: false)
    final String GyMMMEd;
    @JsonKey(nullable: false)
    final String h;
    @JsonKey(nullable: false)
    final String H;
    @JsonKey(nullable: false)
    final String hm;
    @JsonKey(nullable: false)
    final String Hm;
    @JsonKey(nullable: false)
    final String hms;
    @JsonKey(nullable: false)
    final String Hms;
    @JsonKey(nullable: false)
    final String hmsv;
    @JsonKey(nullable: false)
    final String Hmsv;
    @JsonKey(nullable: false)
    final String hmv;
    @JsonKey(nullable: false)
    final String Hmv;
    @JsonKey(nullable: false)
    final String M;
    @JsonKey(nullable: false)
    final String Md;
    @JsonKey(nullable: false)
    final String MEd;
    @JsonKey(nullable: false)
    final String MMM;
    @JsonKey(nullable: false)
    final String MMMd;
    @JsonKey(nullable: false)
    final String MMMEd;
    @JsonKey(nullable: false)
    final String MMMMd;
    @JsonKey(nullable: false, name: 'MMMMW-count-one')
    final String MMMMW;
    @JsonKey(nullable: false, name: 'MMMMW-count-other')
    final String MMMMWAlt;
    @JsonKey(nullable: false)
    final String ms;
    @JsonKey(nullable: false)
    final String y;
    @JsonKey(nullable: false)
    final String yM;
    @JsonKey(nullable: false)
    final String yMd;
    @JsonKey(nullable: false)
    final String yMEd;
    @JsonKey(nullable: false)
    final String yMMM;
    @JsonKey(nullable: false)
    final String yMMMd;
    @JsonKey(nullable: false)
    final String yMMMEd;
    @JsonKey(nullable: false)
    final String yMMMM;
    @JsonKey(nullable: false)
    final String yQQQ;
    @JsonKey(nullable: false)
    final String yQQQQ;
    @JsonKey(nullable: false, name: 'yw-count-one')
    final String yw;
    @JsonKey(nullable: false, name: 'yw-count-other')
    final String ywAlt;

    const BuiltInTimestampFormats(this.Bh, this.Bhm, this.Bhms, this.d, this.E, this.EBhm, this.EBhms, this.Ed, this.Ehm, this.EHm, this.Ehms, this.EHms, this.Gy, this.GyMMM, this.GyMMMd, this.GyMMMEd, this.h, this.H, this.hm, this.Hm, this.hms, this.Hms, this.hmsv, this.Hmsv, this.hmv, this.Hmv, this.M, this.Md, this.MEd, this.MMM, this.MMMd, this.MMMEd, this.MMMMd, this.MMMMW, this.MMMMWAlt, this.ms, this.y, this.yM, this.yMd, this.yMEd, this.yMMM, this.yMMMd, this.yMMMEd, this.yMMMM, this.yQQQ, this.yQQQQ, this.yw, this.ywAlt);

    factory BuiltInTimestampFormats.fromJson(Map<String, dynamic> json) => _$BuiltInTimestampFormatsFromJson(json);

}

@JsonSerializable()
class FormatLength {
    @JsonKey(nullable: false)
    final String full;
    @JsonKey(nullable: false)
    final String long;
    @JsonKey(nullable: false)
    final String medium;
    @JsonKey(nullable: false)
    final String short;

    const FormatLength(this.full, this.long, this.medium, this.short);

    factory FormatLength.fromJson(Map<String, dynamic> json) => _$FormatLengthFromJson(json);

}