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
        json['dayPeriodsRules'] as Map<String, Map<String, String>>),
    WeekData.fromJson(json['weekData'] as Map<String, dynamic>),
    Format.fromJson(json['format'] as Map<String, dynamic>),
  );
}

WeekData _$WeekDataFromJson(Map<String, dynamic> json) {
  return WeekData(
    json['firstDayOfWeek'] as int,
    json['minDaysInWeek'] as int,
  );
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

GeneralContext _$GeneralContextFromJson(Map<String, dynamic> json) {
  return GeneralContext(
    PropertyLength.fromJson(json['format'] as Map<String, dynamic>),
    PropertyLength.fromJson(json['stand-alone'] as Map<String, dynamic>),
  );
}

DayPeriodsContext _$DayPeriodsContextFromJson(Map<String, dynamic> json) {
  return DayPeriodsContext(
    DayPeriodsWidth.fromJson(json['format'] as Map<String, dynamic>),
    DayPeriodsWidth.fromJson(json['stand-alone'] as Map<String, dynamic>),
  );
}

DayPeriodsWidth _$DayPeriodsWidthFromJson(Map<String, dynamic> json) {
  return DayPeriodsWidth(
    DayPeriods.fromJson(json['abbreviated'] as Map<String, dynamic>),
    DayPeriods.fromJson(json['narrow'] as Map<String, dynamic>),
    DayPeriods.fromJson(json['wide'] as Map<String, dynamic>),
  );
}

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

Eras _$ErasFromJson(Map<String, dynamic> json) {
  return Eras(
    json['0'] as String,
    json['1'] as String,
    json['0-alt-variant'] as String,
    json['1-alt-variant'] as String,
  );
}

ErasWidth _$ErasWidthFromJson(Map<String, dynamic> json) {
  return ErasWidth(
    Eras.fromJson(json['eraNames'] as Map<String, dynamic>),
    Eras.fromJson(json['eraAbbr'] as Map<String, dynamic>),
    Eras.fromJson(json['eraNarrow'] as Map<String, dynamic>),
  );
}

PropertyLength _$PropertyLengthFromJson(Map<String, dynamic> json) {
  return PropertyLength(
    (json['abbreviated'] as List).map((e) => e as String).toList(),
    (json['narrow'] as List).map((e) => e as String).toList(),
    (json['wide'] as List).map((e) => e as String).toList(),
    (json['short'] as List)?.map((e) => e as String)?.toList(),
  );
}

Format _$FormatFromJson(Map<String, dynamic> json) {
  return Format(
    FormatLength.fromJson(json['dateFormats'] as Map<String, dynamic>),
    FormatLength.fromJson(json['timeFormats'] as Map<String, dynamic>),
    FormatLength.fromJson(json['dateTimeFormats'] as Map<String, dynamic>),
    BuiltInTimestampFormats.fromJson(json[''] as Map<String, dynamic>),
  );
}

BuiltInTimestampFormats _$BuiltInTimestampFormatsFromJson(
    Map<String, dynamic> json) {
  return BuiltInTimestampFormats(
    json['Bh'] as String,
    json['Bhm'] as String,
    json['Bhms'] as String,
    json['d'] as String,
    json['E'] as String,
    json['EBhm'] as String,
    json['EBhms'] as String,
    json['Ed'] as String,
    json['Ehm'] as String,
    json['EHm'] as String,
    json['Ehms'] as String,
    json['EHms'] as String,
    json['Gy'] as String,
    json['GyMMM'] as String,
    json['GyMMMd'] as String,
    json['GyMMMEd'] as String,
    json['h'] as String,
    json['H'] as String,
    json['hm'] as String,
    json['Hm'] as String,
    json['hms'] as String,
    json['Hms'] as String,
    json['hmsv'] as String,
    json['Hmsv'] as String,
    json['hmv'] as String,
    json['Hmv'] as String,
    json['M'] as String,
    json['Md'] as String,
    json['MEd'] as String,
    json['MMM'] as String,
    json['MMMd'] as String,
    json['MMMEd'] as String,
    json['MMMMd'] as String,
    json['MMMMW-count-one'] as String,
    json['MMMMW-count-other'] as String,
    json['ms'] as String,
    json['y'] as String,
    json['yM'] as String,
    json['yMd'] as String,
    json['yMEd'] as String,
    json['yMMM'] as String,
    json['yMMMd'] as String,
    json['yMMMEd'] as String,
    json['yMMMM'] as String,
    json['yQQQ'] as String,
    json['yQQQQ'] as String,
    json['yw-count-one'] as String,
    json['yw-count-other'] as String,
  );
}

FormatLength _$FormatLengthFromJson(Map<String, dynamic> json) {
  return FormatLength(
    json['full'] as String,
    json['long'] as String,
    json['medium'] as String,
    json['short'] as String,
  );
}
