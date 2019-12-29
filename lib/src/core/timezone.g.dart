// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timezone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeZone _$TimeZoneFromJson(Map<String, dynamic> json) {
  return TimeZone(
    name: json['name'] as String,
    possibleOffsets:
        (json['offsets'] as List)?.map((e) => (e as num)?.toDouble())?.toList(),
    possibleAbbrs: (json['abbrs'] as List)?.map((e) => e as String)?.toList(),
    history: TimeZone._historyFromJson(json['info']),
  );
}

Map<String, dynamic> _$TimeZoneToJson(TimeZone instance) => <String, dynamic>{
      'name': instance.name,
      'offsets': instance.possibleOffsets,
      'abbrs': instance.possibleAbbrs,
      'info': instance.history,
    };

TimeZoneHistory _$TimeZoneHistoryFromJson(Map<String, dynamic> json) {
  return TimeZoneHistory(
    index: json['index'] as int,
    until: TimeZoneHistory._untilFromJson(json['until'] as int),
  );
}

Map<String, dynamic> _$TimeZoneHistoryToJson(TimeZoneHistory instance) =>
    <String, dynamic>{
      'index': instance.index,
      'until': instance.until,
    };
