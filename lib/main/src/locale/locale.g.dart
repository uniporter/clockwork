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
    PropertyLength.fromJson(json['standalone'] as Map<String, dynamic>),
  );
}

DayPeriodsContext _$DayPeriodsContextFromJson(Map<String, dynamic> json) {
  return DayPeriodsContext(
    DayPeriodsWidth.fromJson(json['format'] as Map<String, dynamic>),
    DayPeriodsWidth.fromJson(json['standalone'] as Map<String, dynamic>),
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
    json['amAlt'] as String,
    json['pmAlt'] as String,
    json['night2'] as String,
    json['evening2'] as String,
  );
}

Eras _$ErasFromJson(Map<String, dynamic> json) {
  return Eras(
    json['pre'] as String,
    json['post'] as String,
    json['preAlt'] as String,
    json['postAlt'] as String,
  );
}

ErasWidth _$ErasWidthFromJson(Map<String, dynamic> json) {
  return ErasWidth(
    Eras.fromJson(json['name'] as Map<String, dynamic>),
    Eras.fromJson(json['abbr'] as Map<String, dynamic>),
    Eras.fromJson(json['narrow'] as Map<String, dynamic>),
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
    FormatLength.fromJson(json['date'] as Map<String, dynamic>),
    FormatLength.fromJson(json['time'] as Map<String, dynamic>),
    FormatLength.fromJson(json['datetime'] as Map<String, dynamic>),
    BuiltInTimestampFormats.fromJson(json['builtIn'] as Map<String, dynamic>),
    TimezoneFormat.fromJson(json['timezone'] as Map<String, dynamic>),
  );
}

TimezoneFormat _$TimezoneFormatFromJson(Map<String, dynamic> json) {
  return TimezoneFormat(
    json['gmt'] as String,
    json['gmtZero'] as String,
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
    json['GyM'] as String,
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
    json['MMMMWCountOne'] as String,
    json['MMMMWCountTwo'] as String,
    json['MMMMWCountFew'] as String,
    json['MMMMWCountOther'] as String,
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
    json['ywCountOne'] as String,
    json['ywCountTwo'] as String,
    json['ywCountFew'] as String,
    json['ywCountOther'] as String,
    json['GyMMMMd'] as String,
    json['MMMMEd'] as String,
    json['MMMMWCountMany'] as String,
    json['mmss'] as String,
    json['yMMMMd'] as String,
    json['ywCountMany'] as String,
    json['MMdd'] as String,
    json['yMM'] as String,
    json['HHmmZ'] as String,
    json['yMMMMEEEEd'] as String,
    json['MMd'] as String,
    json['yMMdd'] as String,
    json['GyMMMM'] as String,
    json['GyMMMMEd'] as String,
    json['yMMMMEd'] as String,
    json['MMMMWCountZero'] as String,
    json['ywCountZero'] as String,
    json['hmsvvvv'] as String,
    json['Hmsvvvv'] as String,
    json['yMMMEEEEd'] as String,
    json['EEEEd'] as String,
    json['GyMMMEEEEd'] as String,
    json['HHmmss'] as String,
    json['MEEEEd'] as String,
    json['MMMEEEEd'] as String,
    json['yMEEEEd'] as String,
    json['MMMdd'] as String,
    json['MMMMdd'] as String,
    json['MdAlt'] as String,
    json['MEdAlt'] as String,
    json['MMddAlt'] as String,
    json['yMAlt'] as String,
    json['yMdAlt'] as String,
    json['yMEdAlt'] as String,
    json['Mdd'] as String,
    json['MMMM'] as String,
    json['yMMMMccccd'] as String,
    json['yQ'] as String,
    json['HHmm'] as String,
    json['MMMMEEEEd'] as String,
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
