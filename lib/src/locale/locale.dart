import '../core/interval.dart';
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
/// Retrieve the current [Locale].
Locale get currLocale => _currLocale;

/// Transforms a possibly-null [locale] into a non-null [Locale]. If [locale] is null, then we return the [currLocale].
Locale nonNullLocale(Locale? locale) => locale ?? currLocale;

@JsonSerializable()
class Locale {
    final GregorianCalendarData gregorianCalendar;
    /// A map of the flexible day periods and the range of time they cover.
    @JsonKey(fromJson: _dayPeriodsRuleFromJson)
    final Map<Range<int>, DayPeriod> dayPeriodsRule;
    final WeekData weekData;
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
            final key = entry.key;
            final val = entry.value;
            if (val.containsKey('_at')) {
                final at = _parseRangeValue(val['_at']);
                final period = DayPeriod.values.firstWhere((val) => val.toString().split('.').last.toLowerCase() == key);
                return [MapEntry(Range(at, at, false), period)];
            } else if (val.containsKey('_before') && val.containsKey('_from')) {
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
}

@JsonSerializable()
class WeekData {
    final int firstDayOfWeek;
    final int minDaysInWeek;

    const WeekData(this.firstDayOfWeek, this.minDaysInWeek);

    factory WeekData.fromJson(Map<String, dynamic> json) => _$WeekDataFromJson(json);
}

@JsonSerializable()
class GregorianCalendarData {
    final GeneralContext months;
    final GeneralContext weekdays;
    final GeneralContext quarters;
    final DayPeriodsContext dayPeriods;
    final ErasWidth eras;

    const GregorianCalendarData(this.months, this.weekdays, this.quarters, this.dayPeriods, this.eras);

    factory GregorianCalendarData.fromJson(Map<String, dynamic> json) => _$GregorianCalendarDataFromJson(json);
}

@JsonSerializable()
class GeneralContext {
    final PropertyLength format;
    final PropertyLength standalone;

    const GeneralContext(this.format, this.standalone);

    factory GeneralContext.fromJson(Map<String, dynamic> json) => _$GeneralContextFromJson(json);
}

@JsonSerializable()
class DayPeriodsContext {
    final DayPeriodsWidth format;
    final DayPeriodsWidth standalone;

    const DayPeriodsContext(this.format, this.standalone);

    factory DayPeriodsContext.fromJson(Map<String, dynamic> json) => _$DayPeriodsContextFromJson(json);
}

@JsonSerializable()
class DayPeriodsWidth {
    final DayPeriods abbreviated;
    final DayPeriods narrow;
    final DayPeriods wide;

    const DayPeriodsWidth(this.abbreviated, this.narrow, this.wide);

    factory DayPeriodsWidth.fromJson(Map<String, dynamic> json) => _$DayPeriodsWidthFromJson(json);
}

@JsonSerializable()
class DayPeriods {
    @JsonKey(nullable: true)
    final String? midnight;
    final String am;
    @JsonKey(nullable: true)
    final String? noon;
    final String pm;
    @JsonKey(nullable: true)
    final String? morning1;
    @JsonKey(nullable: true)
    final String? morning2;
    @JsonKey(nullable: true)
    final String? afternoon1;
    @JsonKey(nullable: true)
    final String? evening1;
    @JsonKey(nullable: true)
    final String? night1;
    @JsonKey(nullable: true)
    final String? afternoon2;
    @JsonKey(nullable: true)
    final String? amAlt;
    @JsonKey(nullable: true)
    final String? pmAlt;
    @JsonKey(nullable: true)
    final String? night2;
    @JsonKey(nullable: true)
    final String? evening2;

    const DayPeriods(this.am, this.pm, [this.midnight, this.noon, this.morning1, this.morning2, this.afternoon1, this.evening1, this.night1, this.afternoon2, this.amAlt, this.pmAlt, this.night2, this.evening2]);

    factory DayPeriods.fromJson(Map<String, dynamic> json) => _$DayPeriodsFromJson(json);
}

@JsonSerializable()
class Eras {
    final String pre;
    final String post;
    final String preAlt;
    final String postAlt;

    const Eras(this.pre, this.post, this.preAlt, this.postAlt);

    factory Eras.fromJson(Map<String, dynamic> json) => _$ErasFromJson(json);
}

@JsonSerializable()
class ErasWidth {
    final Eras name;
    final Eras abbr;
    final Eras narrow;

    const ErasWidth(this.name, this.abbr, this.narrow);

    factory ErasWidth.fromJson(Map<String, dynamic> json) => _$ErasWidthFromJson(json);
}

@JsonSerializable()
class PropertyLength {
    final List<String> abbreviated;
    final List<String> narrow;
    final List<String> wide;
    @JsonKey(nullable: true)
    final List<String>? short;

    const PropertyLength(this.abbreviated, this.narrow, this.wide, this.short);

    factory PropertyLength.fromJson(Map<String, dynamic> json) => _$PropertyLengthFromJson(json);
}

@JsonSerializable()
class Format {
    final FormatLength date;
    final FormatLength time;
    final FormatLength datetime;
    final BuiltInTimestampFormats builtIn;
    final TimezoneFormat timezone;

    const Format(this.date, this.time, this.datetime, this.builtIn, this.timezone);

    factory Format.fromJson(Map<String, dynamic> json) => _$FormatFromJson(json);
}

@JsonSerializable()
class TimezoneFormat {
    /// A function that takes in the hour, minute, and second component of the offset and returns the GMT pattern of the locale.
    /// If any of the parameters is null, 
    @JsonKey(fromJson: _patternFromJson)
    final String Function(int?, int?, int?) gmt;
    final String gmtZero;
    @JsonKey(fromJson: _patternFromJson)
    final String Function(String) region;
    @JsonKey(fromJson: _patternFromJson)
    final String Function(String) regionDaylight;
    @JsonKey(fromJson: _patternFromJson)
    final String Function(String) regionStandard;

    const TimezoneFormat(this.gmt, this.gmtZero, this.region, this.regionDaylight, this.regionStandard);

    factory TimezoneFormat.fromJson(Map<String, dynamic> json) => _$TimezoneFormatFromJson(json);

    /// Currently this must return dynamic. If we specify its return type the json_serializable package crashes.
    static dynamic _patternFromJson(String data) => (Interval i, bool isLong) {
        final hour = i.hour;
        final minute = i.minute;
        final second = i.second;

        
    }
}

@JsonSerializable()
class BuiltInTimestampFormats {
    final String Bh;
    final String Bhm;
    final String Bhms;
    final String d;
    final String E;
    final String EBhm;
    final String EBhms;
    final String Ed;
    final String Ehm;
    final String EHm;
    final String Ehms;
    final String EHms;
    final String Gy;
    @JsonKey(nullable: true)
    final String? GyM;
    final String GyMMM;
    final String GyMMMd;
    final String GyMMMEd;
    final String h;
    final String H;
    final String hm;
    final String Hm;
    final String hms;
    final String Hms;
    final String hmsv;
    final String Hmsv;
    final String hmv;
    final String Hmv;
    final String M;
    final String Md;
    final String MEd;
    final String MMM;
    final String MMMd;
    final String MMMEd;
    final String MMMMd;
    @JsonKey(nullable: true)
    final String? MMMMWCountOne;
    @JsonKey(nullable: true)
    final String? MMMMWCountTwo;
    @JsonKey(nullable: true)
    final String? MMMMWCountFew;
    final String MMMMWCountOther;
    final String ms;
    final String y;
    final String yM;
    final String yMd;
    final String yMEd;
    final String yMMM;
    final String yMMMd;
    final String yMMMEd;
    final String yMMMM;
    final String yQQQ;
    final String yQQQQ;
    @JsonKey(nullable: true)
    final String? ywCountOne;
    @JsonKey(nullable: true)
    final String? ywCountTwo;
    @JsonKey(nullable: true)
    final String? ywCountFew;
    final String ywCountOther;
    @JsonKey(nullable: true)
    final String? GyMMMMd;
    @JsonKey(nullable: true)
    final String? MMMMEd;
    @JsonKey(nullable: true)
    final String? MMMMWCountMany;
    @JsonKey(nullable: true)
    final String? mmss;
    @JsonKey(nullable: true)
    final String? yMMMMd;
    @JsonKey(nullable: true)
    final String? ywCountMany;
    @JsonKey(nullable: true)
    final String? MMdd;
    @JsonKey(nullable: true)
    final String? yMM;
    @JsonKey(nullable: true)
    final String? HHmmZ;
    @JsonKey(nullable: true)
    final String? yMMMMEEEEd;
    @JsonKey(nullable: true)
    final String? MMd;
    @JsonKey(nullable: true)
    final String? yMMdd;
    @JsonKey(nullable: true)
    final String? GyMMMM;
    @JsonKey(nullable: true)
    final String? GyMMMMEd;
    @JsonKey(nullable: true)
    final String? yMMMMEd;
    @JsonKey(nullable: true)
    final String? MMMMWCountZero;
    @JsonKey(nullable: true)
    final String? ywCountZero;
    @JsonKey(nullable: true)
    final String? hmsvvvv;
    @JsonKey(nullable: true)
    final String? Hmsvvvv;
    @JsonKey(nullable: true)
    final String? yMMMEEEEd;
    @JsonKey(nullable: true)
    final String? EEEEd;
    @JsonKey(nullable: true)
    final String? GyMMMEEEEd;
    @JsonKey(nullable: true)
    final String? HHmmss;
    @JsonKey(nullable: true)
    final String? MEEEEd;
    @JsonKey(nullable: true)
    final String? MMMEEEEd;
    @JsonKey(nullable: true)
    final String? yMEEEEd;
    @JsonKey(nullable: true)
    final String? MMMdd;
    @JsonKey(nullable: true)
    final String? MMMMdd;
    @JsonKey(nullable: true)
    final String? MdAlt;
    @JsonKey(nullable: true)
    final String? MEdAlt;
    @JsonKey(nullable: true)
    final String? MMddAlt;
    @JsonKey(nullable: true)
    final String? yMAlt;
    @JsonKey(nullable: true)
    final String? yMdAlt;
    @JsonKey(nullable: true)
    final String? yMEdAlt;
    @JsonKey(nullable: true)
    final String? Mdd;
    @JsonKey(nullable: true)
    final String? MMMM;
    @JsonKey(nullable: true)
    final String? yMMMMccccd;
    @JsonKey(nullable: true)
    final String? yQ;
    @JsonKey(nullable: true)
    final String? HHmm;
    @JsonKey(nullable: true)
    final String? MMMMEEEEd;

    const BuiltInTimestampFormats(this.Bh, this.Bhm, this.Bhms, this.d, this.E, this.EBhm, this.EBhms, this.Ed, this.Ehm, this.EHm, this.Ehms, this.EHms, this.Gy, this.GyM, this.GyMMM, this.GyMMMd, this.GyMMMEd, this.h, this.H, this.hm, this.Hm, this.hms, this.Hms, this.hmsv, this.Hmsv, this.hmv, this.Hmv, this.M, this.Md, this.MEd, this.MMM, this.MMMd, this.MMMEd, this.MMMMd, this.MMMMWCountOne, this.MMMMWCountTwo, this.MMMMWCountFew, this.MMMMWCountOther, this.ms, this.y, this.yM, this.yMd, this.yMEd, this.yMMM, this.yMMMd, this.yMMMEd, this.yMMMM, this.yQQQ, this.yQQQQ, this.ywCountOne, this.ywCountTwo, this.ywCountFew, this.ywCountOther, this.GyMMMMd, this.MMMMEd, this.MMMMWCountMany, this.mmss, this.yMMMMd, this.ywCountMany, this.MMdd, this.yMM, this.HHmmZ, this.yMMMMEEEEd, this.MMd, this.yMMdd, this.GyMMMM, this.GyMMMMEd, this.yMMMMEd, this.MMMMWCountZero, this.ywCountZero, this.hmsvvvv, this.Hmsvvvv, this.yMMMEEEEd, this.EEEEd, this.GyMMMEEEEd, this.HHmmss, this.MEEEEd, this.MMMEEEEd, this.yMEEEEd, this.MMMdd, this.MMMMdd, this.MdAlt, this.MEdAlt, this.MMddAlt, this.yMAlt, this.yMdAlt, this.yMEdAlt, this.Mdd, this.MMMM, this.yMMMMccccd, this.yQ, this.HHmm, this.MMMMEEEEd);

    factory BuiltInTimestampFormats.fromJson(Map<String, dynamic> json) => _$BuiltInTimestampFormatsFromJson(json);
}

@JsonSerializable()
class FormatLength {
    final String full;
    final String long;
    final String medium;
    final String short;

    const FormatLength(this.full, this.long, this.medium, this.short);

    factory FormatLength.fromJson(Map<String, dynamic> json) => _$FormatLengthFromJson(json);
}