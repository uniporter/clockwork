
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import '../units/unit.dart';
import '../utils/exception.dart';
import 'interval.dart';

part 'timezone.g.dart';

late TimeZone _localLocation;

TimeZone get localLocation => _localLocation;
/// Set local location.
set localLocation(TimeZone location) {
    _localLocation = location;
}

abstract class TimeZoneData {
    static const TIME_ZONE_DATA = 'TimeZone Data';
    static late UnmodifiableMapView<String, TimeZone> data;

    /// All methods/classes annotated with `@NeedsTimeZoneData` can only be used when this bool is true. Otherwise a
    /// `DataNotLoadedException` will be thrown.
    static bool timeZoneDataLoaded = false;

    /// Load the timezone data from disc into memory. This is a very computationally expensive function.
    static Future<bool> initialize(String path, {String local: 'Etc/UTC'}) async {
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
        localLocation = TimeZone.parse(local);
        return true;
    }

    /// Check if the timezone data has been loaded. Throws `DataNotLoadedException` if not.
    static bool checkIfLoaded() {
        if (!timeZoneDataLoaded) throw DataNotLoadedException(TIME_ZONE_DATA);
        return true;
    }
}

/// Represents a geographical TimeZone region as defined by the `tz` database.
@JsonSerializable()
class TimeZone {
    final String name;
    /// List of possible offsets of the timezone in minutes. This list must align in index with [possibleAbbrs].
    final List<double> possibleOffsets;
    /// List of possible abbreviations of the different offsets of the timezone. This list must align in index with [possibleOffsets].
    final List<String> possibleAbbrs;
    @JsonKey(fromJson: _historyFromJson)
    final List<TimeZoneHistory> history;

    const TimeZone(this.name, this.possibleAbbrs, this.possibleOffsets, this.history);

    factory TimeZone._fromJson(Map<String, dynamic> json) => _$TimeZoneFromJson(json);

    /// Parse a timezone string. The string must be in the format of `Continent/Region`, i.e. `America/New_York`.
    factory TimeZone.parse(String name) {
        TimeZoneData.checkIfLoaded();
        if (!TimeZoneData.data.containsKey(name)) {
            throw InvalidArgumentException(name);
        }
        return TimeZoneData.data[name];
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
        return localLocation;
    }

    /// Returns the offset of the timezone at [microsecondsSinceEpoch].
    ///
    /// The returned offset should be the difference in minutes between the timezoned timestamp and the utc timestamp. For instance, if at a given moment the
    /// UTC time is `08:00:00, Jan 1st, 2009` and the timezoned time is `08:30:00, Jan 1st, 2009`, then the function returns 30.
    Interval offset(int microsecondsSinceEpoch) => Interval(minutes: -possibleOffsets[history.firstWhere((item) => item.until >= microsecondsSinceEpoch).index]);

    /// Returns the timezone abbreviation at [microsecondsSinceEpoch].
    String abbr(int microsecondsSinceEpoch) => possibleAbbrs[history.firstWhere((item) => item.until >= microsecondsSinceEpoch).index];

    /// Returns whether the timezone is in Daylight Saving Time at [microsecondsSinceEpoch].
    bool isDst(int microsecondsSinceEpoch) => history.firstWhere((item) => item.until >= microsecondsSinceEpoch).dst;

    static List<TimeZoneHistory> _historyFromJson(List data) {
        return data.map<TimeZoneHistory>((datum) => TimeZoneHistory._fromJson(datum)).toList();
    }

    @override bool operator ==(covariant TimeZone other) => name == other.name;
    @override int get hashCode => name.hashCode;
}

/// Represents the specific offset/abbr information of the geographical timezone at a specific point in history.
@JsonSerializable()
class TimeZoneHistory {
    final int index;
    @JsonKey(fromJson: _untilFromJson)
    final num until;
    final bool dst;

    const TimeZoneHistory(this.index, this.until, this.dst);

    static num _untilFromJson(int? data) => data == null ? double.infinity : data * Millisecond.microsecondsPer;

    factory TimeZoneHistory._fromJson(Map<String, dynamic> json) => _$TimeZoneHistoryFromJson(json);
}