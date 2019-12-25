
import 'dart:convert';
import 'dart:io';
import 'dart:collection';

import 'package:datex/src/utils/exception.dart';
import 'package:datex/src/utils/system_util.dart';
import 'package:datex/src/utils/units.dart';
import 'package:json_annotation/json_annotation.dart';

part 'timezone.g.dart';

TimeZone _local;

/// Set local location.
void setLocalLocation(String location) {
    _local = TimeZone.parse(location);
}

abstract class TimeZoneData {
    static const TIME_ZONE_DATA = 'TimeZone Data';
    static UnmodifiableMapView<String, TimeZone> data;

    /// All methods/classes annotated with `@NeedsTimeZoneData` can only be used when this bool is true. Otherwise a
    /// `DataNotLoadedException` will be thrown.
    static bool timeZoneDataLoaded = false;

    /// Load the timezone data from disc into memory. This is a very computationally expensive function.
    static Future<bool> initialize(String path, {String local: 'Etc/UTC'}) async {
        if (path == null) return error(InvalidArgumentException('path'));
        assert(!timeZoneDataLoaded);    // We don't want the package to load for multiple times.

        final io = File(path);
        final dataStr = await io.readAsString();
        final json = jsonDecode(dataStr);
        data = UnmodifiableMapView(SplayTreeMap.fromIterable(
            json.map((elem) => TimeZone._fromJson(elem)),
            key: (elem) => elem.name,
            value: (elem) => elem,
        ));

        timeZoneDataLoaded = true;
        _local = TimeZone.parse(local);
        return true;
    }

    /// Check if the timezone data has been loaded. Throws `DataNotLoadedException` if not.
    static bool checkIfLoaded() {
        if (!timeZoneDataLoaded) return error(DataNotLoadedException(TIME_ZONE_DATA));
        return true;
    }
}

/// Represents a geographical TimeZone region as defined by the `tz` database.
@JsonSerializable()
class TimeZone {
    final String name;
    /// List of possible offsets of the timezone in minutes. This list must align in index with [possibleAbbrs].
    @JsonKey(
        name: 'offsets',
    )
    final List<double> possibleOffsets;
    /// List of possible abbreviations of the different offsets of the timezone. This list must align in index with [possibleOffsets].
    @JsonKey(
        name: 'abbrs',
    )
    final List<String> possibleAbbrs;
    @JsonKey(
        name: 'info',
        fromJson: _historyFromJson,
    )
    final List<TimeZoneHistory> history;

    const TimeZone({
        this.name,
        this.possibleOffsets,
        this.possibleAbbrs,
        this.history,
    });

    factory TimeZone._fromJson(Map<String, dynamic> json) => _$TimeZoneFromJson(json);
    Map<String, dynamic> toJson() => _$TimeZoneToJson(this);

    /// Parse a timezone string. The string must be in the format of `Continent/Region`, i.e. `America/New_York`.
    factory TimeZone.parse(String name) {
        TimeZoneData.checkIfLoaded();
        final res = TimeZoneData.data[name];
        if (res == null) return error(InvalidArgumentException(name));

        return res;
    }

    /// Returns the canonical utc timezone.
    factory TimeZone.utc() {
        TimeZoneData.checkIfLoaded();
        return TimeZoneData.data['Etc/UTC'];
    }

    /// Returns the local timezone. If you did not provide the `local` parameter in `TimeZoneData.initialize()`, and you
    /// haven't called `setLocalLocation()`, then the local timezone will be defaulted to `Etc/UTC`.
    factory TimeZone.local() {
        TimeZoneData.checkIfLoaded();
        return _local;
    }

    /// Returns the offset of the timezone at [microsecondsSinceEpoch].
    ///
    /// The returned offset should be the difference in minutes between the timezoned timestamp and the utc timestamp. For instance, if at a given moment the
    /// UTC time is `08:00:00, Jan 1st, 2009` and the timezoned time is `08:30:00, Jan 1st, 2009`, then the function returns 30.
    double offset(int microsecondsSinceEpoch) {
        return -possibleOffsets[history.firstWhere((item) => item.until >= microsecondsSinceEpoch).index];
    }

    static List<TimeZoneHistory> _historyFromJson(List data) {
        return data.map<TimeZoneHistory>((datum) => TimeZoneHistory._fromJson(datum)).toList();
    }

    @override bool operator ==(covariant TimeZone other) => this.name == other.name;
}

/// Represents the specific offset/abbr information of the geographical timezone at a specific point in history.
@JsonSerializable()
class TimeZoneHistory {
    final int index;
    @JsonKey(
        includeIfNull: true,
        fromJson: _untilFromJson,
    )
    final num until;

    const TimeZoneHistory({
        this.index,
        this.until,
    }) : assert(index != null && until != null);

    static num _untilFromJson(int data) => data == null ? double.infinity : data * microsecondsPerMillisecond;

    factory TimeZoneHistory._fromJson(Map<String, dynamic> json) => _$TimeZoneHistoryFromJson(json);
    Map<String, dynamic> toJson() => _$TimeZoneHistoryToJson(this);
}