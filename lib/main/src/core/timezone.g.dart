// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timezone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeZone _$TimeZoneFromJson(Map<String, dynamic> json) {
  return TimeZone(
    json['name'] as String,
    (json['possibleAbbrs'] as List).map((e) => e as String).toList(),
    (json['possibleOffsets'] as List)
        .map((e) => (e as num).toDouble())
        .toList(),
    TimeZone._historyFromJson(json['history'] as List),
  );
}

TimeZoneHistory _$TimeZoneHistoryFromJson(Map<String, dynamic> json) {
  return TimeZoneHistory(
    json['index'] as int,
    TimeZoneHistory._untilFromJson(json['until'] as int),
    json['dst'] as bool,
  );
}
