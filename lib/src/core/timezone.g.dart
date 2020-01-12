// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timezone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeZone _$TimeZoneFromJson(Map<String, dynamic> json) {
  return TimeZone(
    json['name'] as String,
    (json['abbrs'] as List).map((e) => e as String).toList(),
    (json['offsets'] as List).map((e) => (e as num).toDouble()).toList(),
    TimeZone._historyFromJson(json['info'] as List),
  );
}

TimeZoneHistory _$TimeZoneHistoryFromJson(Map<String, dynamic> json) {
  return TimeZoneHistory(
    json['index'] as int,
    TimeZoneHistory._untilFromJson(json['until'] as int),
  );
}
