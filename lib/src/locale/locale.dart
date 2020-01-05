import 'package:clockwork_gregorian_calendar/clockwork_gregorian_calendar.dart' as Gregorian;
import 'package:clockwork/src/locale/en.locale.dart';
import 'package:clockwork/src/utils/exception.dart';
import 'package:clockwork/src/utils/system_util.dart';
import 'package:json_annotation/json_annotation.dart';

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
    @JsonKey(nullable: false)
    final GregorianCalendarData gregorianCalendar;
    @JsonKey(nullable: false, toJson: _dayPeriodsRuleToJson, fromJson: _dayPeriodsRuleFromJson)
    final Map<Gregorian.DayPeriod, Range<int>> dayPeriodsRule;

    const Locale(this.gregorianCalendar, this.dayPeriodsRule);

    factory Locale.fromJson(Map<String, dynamic> json) => _$LocaleFromJson(json);
    Map<String, dynamic> toJson() => _$LocaleToJson(this);

    static Map<Gregorian.DayPeriod, Range<int>> _dayPeriodsRuleFromJson(Map<String, Map<String, String>> json) {
        int _parseRangeValue(String val) {
            final components = val.split(':');
            final hours = int.parse(components.first);
            final minutes = int.parse(components[1]);

            return hours * 60 + minutes;
        }

        return json.map((key, val) {
            if (val.containsKey('at')) {
                final at = _parseRangeValue(val['_at']);
                final period = Gregorian.DayPeriod.values.firstWhere((val) => val.toString().split('.').last == key);
                return MapEntry(period, Range(at, at, false));
            } else if (val.containsKey('before') && val.containsKey('after')) {
                key = key == 'am-alt-variant' ? 'amAlt' : key == 'pm-alt-variant' ? 'pmAlt' : key;
                final from = _parseRangeValue(val['_from']);
                final before = _parseRangeValue(val['_before']);
                final period = Gregorian.DayPeriod.values.firstWhere((val) => val.toString().split('.').last == key);
                return MapEntry(period, Range(from, before));
            } else {
                throw GeneralException("Invalid locale data: locale data contain invalid day period rules information and might have been corrupted.");
            }
        });
    }

    static Map<String, dynamic> _dayPeriodsRuleToJson(Map<Gregorian.DayPeriod, Range<int>> rule) {
        return rule.map((period, range) {
            final periodNameLiteral = period.toString().split('.').last;
            final periodName = periodNameLiteral == 'amAlt' ? 'am-alt-variant' : periodNameLiteral == 'pmAlt' ? 'pm-alt-variant' : periodNameLiteral;
            final rangeDescription = (range.floor == range.ceiling)
                ? {"at": "${range.floor ~/ 60}:${range.floor % 60}"}
                : {"before": "${range.ceiling ~/ 60}:${range.ceiling % 60}", "from": "${range.floor ~/ 60}:${range.floor % 60}"};

            return MapEntry(periodName, rangeDescription);
        });
    }
}

abstract class _InvariantDayPeriodsRule {
    final Range<int> am = const Range(0, 720);
    final Range<int> pm = const Range(720, 1440);

    const _InvariantDayPeriodsRule();
}

@JsonSerializable()
class DayPeriodsRule extends _InvariantDayPeriodsRule {
    @JsonKey(fromJson: _rangeFromJson, toJson: _rangeToJson)
    final Range<int>? midnight;
    @JsonKey(fromJson: _rangeFromJson, toJson: _rangeToJson)
    final Range<int>? noon;
    @JsonKey(fromJson: _rangeFromJson, toJson: _rangeToJson)
    final Range<int>? morning1;
    @JsonKey(fromJson: _rangeFromJson, toJson: _rangeToJson)
    final Range<int>? morning2;
    @JsonKey(fromJson: _rangeFromJson, toJson: _rangeToJson)
    final Range<int>? afternoon1;
    @JsonKey(fromJson: _rangeFromJson, toJson: _rangeToJson)
    final Range<int>? evening1;
    @JsonKey(fromJson: _rangeFromJson, toJson: _rangeToJson)
    final Range<int>? night1;
    @JsonKey(fromJson: _rangeFromJson, toJson: _rangeToJson)
    final Range<int>? afternoon2;
    @JsonKey(fromJson: _rangeFromJson, toJson: _rangeToJson)
    final Range<int>? night2;
    @JsonKey(fromJson: _rangeFromJson, toJson: _rangeToJson)
    final Range<int>? evening2;

    const DayPeriodsRule([this.midnight, this.noon, this.morning1, this.morning2, this.afternoon1, this.evening1, this.night1, this.afternoon2, this.night2, this.evening2]);

    factory DayPeriodsRule.fromJson(Map<String, dynamic> json) => _$DayPeriodsRuleFromJson(json);
    Map<String, dynamic> toJson() => _$DayPeriodsRuleToJson(this);

    static Range<int> _rangeFromJson(Map<String, dynamic> json) {
        int _parseRangeValue(String val) {
            final components = val.split(':');
            final hours = int.parse(components.first);
            final minutes = int.parse(components[1]);

            return hours * 60 + minutes;
        }

        if (json.containsKey('at')) {
            final val = _parseRangeValue(json['at']);
            return Range<int>(val, val, false);
        } else if (json.containsKey('before') && json.containsKey('after')) {
            return Range<int>(_parseRangeValue(json['from']), _parseRangeValue(json['before']));
        } else {
            throw GeneralException("Invalid locale data: locale data contain invalid day period rules information and might have been corrupted.");
        }
    }

    static Map<String, String>? _rangeToJson(Range<int>? range) {
        if (range == null) return null;
        return (range.floor == range.ceiling)
            ? {"at": "${range.floor ~/ 60}:${range.floor % 60}"}
            : {"before": "${range.ceiling ~/ 60}:${range.ceiling % 60}", "from": "${range.floor ~/ 60}:${range.floor % 60}"};
    }
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
    Map<String, dynamic> toJson() => _$GregorianCalendarDataToJson(this);
}

@JsonSerializable()
class GeneralContext {
    @JsonKey(nullable: false)
    final PropertyLength format;
    @JsonKey(name: 'stand-alone', nullable: false)
    final PropertyLength standalone;

    const GeneralContext(this.format, this.standalone);

    factory GeneralContext.fromJson(Map<String, dynamic> json) => _$GeneralContextFromJson(json);
    Map<String, dynamic> toJson() => _$GeneralContextToJson(this);
}

@JsonSerializable()
class DayPeriodsContext {
    @JsonKey(nullable: false)
    final DayPeriodsWidth format;
    @JsonKey(name: 'stand-alone', nullable: false)
    final DayPeriodsWidth standalone;

    const DayPeriodsContext(this.format, this.standalone);

    factory DayPeriodsContext.fromJson(Map<String, dynamic> json) => _$DayPeriodsContextFromJson(json);
    Map<String, dynamic> toJson() => _$DayPeriodsContextToJson(this);
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
    Map<String, dynamic> toJson() => _$DayPeriodsWidthToJson(this);
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
    Map<String, dynamic> toJson() => _$DayPeriodsToJson(this);
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
    Map<String, dynamic> toJson() => _$ErasToJson(this);
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
    Map<String, dynamic> toJson() => _$ErasWidthToJson(this);
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
    Map<String, dynamic> toJson() => _$PropertyLengthToJson(this);
}