// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Locale _$LocaleFromJson(Map<String, dynamic> json) {
  return Locale(
    GregorianCalendarData.fromJson(
        json['gregorianCalendar'] as Map<String, dynamic>),
    Locale._dayPeriodsRuleFromJson(
        json['dayPeriodsRule'] as Map<String, Map<String, String>>),
  );
}

Map<String, dynamic> _$LocaleToJson(Locale instance) {
  final val = <String, dynamic>{
    'gregorianCalendar': instance.gregorianCalendar.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'dayPeriodsRule', Locale._dayPeriodsRuleToJson(instance.dayPeriodsRule));
  return val;
}

DayPeriodsRule _$DayPeriodsRuleFromJson(Map<String, dynamic> json) {
  return DayPeriodsRule(
    DayPeriodsRule._rangeFromJson(json['midnight'] as Map<String, dynamic>),
    DayPeriodsRule._rangeFromJson(json['noon'] as Map<String, dynamic>),
    DayPeriodsRule._rangeFromJson(json['morning1'] as Map<String, dynamic>),
    DayPeriodsRule._rangeFromJson(json['morning2'] as Map<String, dynamic>),
    DayPeriodsRule._rangeFromJson(json['afternoon1'] as Map<String, dynamic>),
    DayPeriodsRule._rangeFromJson(json['evening1'] as Map<String, dynamic>),
    DayPeriodsRule._rangeFromJson(json['night1'] as Map<String, dynamic>),
    DayPeriodsRule._rangeFromJson(json['afternoon2'] as Map<String, dynamic>),
    DayPeriodsRule._rangeFromJson(json['night2'] as Map<String, dynamic>),
    DayPeriodsRule._rangeFromJson(json['evening2'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DayPeriodsRuleToJson(DayPeriodsRule instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('midnight', DayPeriodsRule._rangeToJson(instance.midnight));
  writeNotNull('noon', DayPeriodsRule._rangeToJson(instance.noon));
  writeNotNull('morning1', DayPeriodsRule._rangeToJson(instance.morning1));
  writeNotNull('morning2', DayPeriodsRule._rangeToJson(instance.morning2));
  writeNotNull('afternoon1', DayPeriodsRule._rangeToJson(instance.afternoon1));
  writeNotNull('evening1', DayPeriodsRule._rangeToJson(instance.evening1));
  writeNotNull('night1', DayPeriodsRule._rangeToJson(instance.night1));
  writeNotNull('afternoon2', DayPeriodsRule._rangeToJson(instance.afternoon2));
  writeNotNull('night2', DayPeriodsRule._rangeToJson(instance.night2));
  writeNotNull('evening2', DayPeriodsRule._rangeToJson(instance.evening2));
  return val;
}

GregorianCalendarData _$GregorianCalendarDataFromJson(
    Map<String, dynamic> json) {
  return GregorianCalendarData(
    GeneralContext.fromJson(json['months'] as Map<String, dynamic>),
    GeneralContext.fromJson(json['weekdays'] as Map<String, dynamic>),
    GeneralContext.fromJson(json['quarters'] as Map<String, dynamic>),
    DayPeriodsContext.fromJson(json['dayPeriods'] as Map<String, dynamic>),
    ErasWidth.fromJson(json['eras'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GregorianCalendarDataToJson(
        GregorianCalendarData instance) =>
    <String, dynamic>{
      'months': instance.months.toJson(),
      'weekdays': instance.weekdays.toJson(),
      'quarters': instance.quarters.toJson(),
      'dayPeriods': instance.dayPeriods.toJson(),
      'eras': instance.eras.toJson(),
    };

GeneralContext _$GeneralContextFromJson(Map<String, dynamic> json) {
  return GeneralContext(
    PropertyLength.fromJson(json['format'] as Map<String, dynamic>),
    PropertyLength.fromJson(json['stand-alone'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GeneralContextToJson(GeneralContext instance) =>
    <String, dynamic>{
      'format': instance.format.toJson(),
      'stand-alone': instance.standalone.toJson(),
    };

DayPeriodsContext _$DayPeriodsContextFromJson(Map<String, dynamic> json) {
  return DayPeriodsContext(
    DayPeriodsWidth.fromJson(json['format'] as Map<String, dynamic>),
    DayPeriodsWidth.fromJson(json['stand-alone'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DayPeriodsContextToJson(DayPeriodsContext instance) =>
    <String, dynamic>{
      'format': instance.format.toJson(),
      'stand-alone': instance.standalone.toJson(),
    };

DayPeriodsWidth _$DayPeriodsWidthFromJson(Map<String, dynamic> json) {
  return DayPeriodsWidth(
    DayPeriods.fromJson(json['abbreviated'] as Map<String, dynamic>),
    DayPeriods.fromJson(json['narrow'] as Map<String, dynamic>),
    DayPeriods.fromJson(json['wide'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DayPeriodsWidthToJson(DayPeriodsWidth instance) =>
    <String, dynamic>{
      'abbreviated': instance.abbreviated.toJson(),
      'narrow': instance.narrow.toJson(),
      'wide': instance.wide.toJson(),
    };

DayPeriods _$DayPeriodsFromJson(Map<String, dynamic> json) {
  return DayPeriods(
    json['am'] as String,
    json['pm'] as String,
    json['midnight'] as String,
    json['noon'] as String,
    json['morning1'] as String,
    json['morning2'] as String,
    json['afternoon1'] as String,
    json['evening1'] as String,
    json['night1'] as String,
    json['afternoon2'] as String,
    json['am-alt-variant'] as String,
    json['pm-alt-variant'] as String,
    json['night2'] as String,
    json['evening2'] as String,
  );
}

Map<String, dynamic> _$DayPeriodsToJson(DayPeriods instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('midnight', instance.midnight);
  val['am'] = instance.am;
  writeNotNull('noon', instance.noon);
  val['pm'] = instance.pm;
  writeNotNull('morning1', instance.morning1);
  writeNotNull('morning2', instance.morning2);
  writeNotNull('afternoon1', instance.afternoon1);
  writeNotNull('evening1', instance.evening1);
  writeNotNull('night1', instance.night1);
  writeNotNull('afternoon2', instance.afternoon2);
  writeNotNull('am-alt-variant', instance.amAlt);
  writeNotNull('pm-alt-variant', instance.pmAlt);
  writeNotNull('night2', instance.night2);
  writeNotNull('evening2', instance.evening2);
  return val;
}

Eras _$ErasFromJson(Map<String, dynamic> json) {
  return Eras(
    json['0'] as String,
    json['1'] as String,
    json['0-alt-variant'] as String,
    json['1-alt-variant'] as String,
  );
}

Map<String, dynamic> _$ErasToJson(Eras instance) => <String, dynamic>{
      '0': instance.pre,
      '1': instance.post,
      '0-alt-variant': instance.preAlt,
      '1-alt-variant': instance.postAlt,
    };

ErasWidth _$ErasWidthFromJson(Map<String, dynamic> json) {
  return ErasWidth(
    Eras.fromJson(json['eraNames'] as Map<String, dynamic>),
    Eras.fromJson(json['eraAbbr'] as Map<String, dynamic>),
    Eras.fromJson(json['eraNarrow'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ErasWidthToJson(ErasWidth instance) => <String, dynamic>{
      'eraNames': instance.name.toJson(),
      'eraAbbr': instance.abbr.toJson(),
      'eraNarrow': instance.narrow.toJson(),
    };

PropertyLength _$PropertyLengthFromJson(Map<String, dynamic> json) {
  return PropertyLength(
    (json['abbreviated'] as List).map((e) => e as String).toList(),
    (json['narrow'] as List).map((e) => e as String).toList(),
    (json['wide'] as List).map((e) => e as String).toList(),
    (json['short'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$PropertyLengthToJson(PropertyLength instance) {
  final val = <String, dynamic>{
    'abbreviated': instance.abbreviated,
    'narrow': instance.narrow,
    'wide': instance.wide,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('short', instance.short);
  return val;
}
