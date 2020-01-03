// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timezone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeZone _$TimeZoneFromJson(Map<String, dynamic> json) {
  return TimeZone(
    name: json['name'],
    possibleOffsets: json['offsets'],
    possibleAbbrs: json['abbrs'],
    history: TimeZone._historyFromJson(json['info'] as List),
  );
}

Map<String, dynamic> _$TimeZoneToJson(TimeZone instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('offsets', instance.possibleOffsets);
  writeNotNull('abbrs', instance.possibleAbbrs);
  writeNotNull('info', instance.history?.map((e) => e?.toJson())?.toList());
  return val;
}

TimeZoneHistory _$TimeZoneHistoryFromJson(Map<String, dynamic> json) {
  return TimeZoneHistory(
    index: json['index'],
    until: TimeZoneHistory._untilFromJson(json['until'] as int),
  );
}

Map<String, dynamic> _$TimeZoneHistoryToJson(TimeZoneHistory instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('index', instance.index);
  val['until'] = instance.until;
  return val;
}
