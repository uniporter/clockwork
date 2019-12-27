import 'dart:math';

import 'package:datex/src/timestamp.dart';
import 'package:datex/src/units/conversion.dart';
import 'package:datex/src/units/month.dart';
import 'package:datex/src/units/weekday.dart';

typedef FormatToken = String Function(Timestamp ts);

/// Returns a new token that pads the original token [t] to length [len] with `0`.
FormatToken pad(FormatToken t, int len) => (ts) => t(ts).padLeft(len, '0');

/// Returns a new token that adds the ordinal numeral postfix to the output of [t].
FormatToken ordinal(FormatToken t) => (ts) {
    final output = t(ts);
    final cardinal = int.parse(output);
    final lastTwoDigits = cardinal % 100;
    final lastDigit = lastTwoDigits % 10;

    final suffixGuess = lastDigit == 1 ? 'st'
        : lastDigit == 2 ? 'nd'
        : lastDigit == 3 ? 'rd'
        : 'th';

    return output + (lastTwoDigits >= 11 && lastTwoDigits <= 13 ? 'th' : suffixGuess);
};

/// Returns a token that placeholds for nothing but spaces of size [len].
FormatToken space(int len) => (ts) => ''.padLeft(len, ' ');

/// Returns a token that placeholds for [str].
FormatToken string(String str) => (ts) => str;

/// Identified by `M`. Displays the month of the timestamp as Arabic numbers.
/// Example: January: `1`, December: `12`.
String M(Timestamp ts) => ts.month.index.toString();

/// Identified by `Mo`. Displays the month of the timestamp as Arabic numbers in ordinal numeral form.
/// Example: January: `1st`, December: `12th`.
String Mo(Timestamp ts) => ordinal(M)(ts);

/// Identified by `MM`. Displays the month of the timestamp as Arabic numbers padded to length 2.
/// Example: January: `01`, December: `12`.
String MM(Timestamp ts) => pad(M, 2)(ts);

/// Identified by `MMM`. Displays the first three letters of the name of the timestamp's month in Upper Camel.
/// Example: January: `Jan`, December: `Dec`.
String MMM(Timestamp ts) => ts.month.toAbbr();

/// Identified by `MMMM`. Displays the name of the timestamp's month in Upper Camel.
/// Example: January: `January`, December: `December`.
String MMMM(Timestamp ts) => ts.month.toUpperCamel();

/// Identified by `Q`. Displays the quarter number.
/// Example: Spring: `1`.
String Q(Timestamp ts) => ts.quarter.toString();

/// Identified by `Qo`. Displays the quarter number in ordinal numeral.
/// Example: Spring: `1st`.
String Qo(Timestamp ts) => ordinal(Q)(ts);

/// Identified by `D`. Displays the day number.
/// Example: 1: `1`, 23: `23`.
String D(Timestamp ts) => ts.day.toString();

/// Identified by `Do`. Displays the day number in ordinal numeral.
/// Example: 1: `1st`, 23: `23rd`.
String Do(Timestamp ts) => ordinal(D)(ts);

/// Identified by `DD`. Displays the day number padded to length 2.
/// Example: 1: `01`, 23: `23`.
String DD(Timestamp ts) => pad(D, 2)(ts);

/// Identified by `DDD`. Displays the day of year.
/// Example: February 1: `32`.
String DDD(Timestamp ts) => ts.dayOfYear.toString();

/// Identified by `DDD`. Displays the day of year in ordinal numeral.
/// Example: February 1: `32nd`.
String DDDo(Timestamp ts) => ordinal(DDD)(ts);

/// Identified by `DDD`. Displays the day of year padded to length 3.
/// Example: February 1: `032`.
String DDDD(Timestamp ts) => pad(DDD, 3)(ts);

/// Identified by `d`. Displays the weekday number according to the US convention.
/// Example: Sunday: `0`, Thursday: `5`.
String d(Timestamp ts) => ts.weekday.index.toString();

/// Identified by `do`. Displays the weekday number according to the US convention in ordinal numeral.
/// Example: Sunday: `0th`, Thursday: `5th`.
String do_(Timestamp ts) => ordinal(d)(ts);

/// Identified by `dd`. Displays the weekday name according to the US convention in two-lettered abbreviation.
/// Example: Sunday: `Su`, Thursday: `Th`.
String dd(Timestamp ts) => ts.weekday.toShortAbbr();

/// Identified by `ddd`. Displays the weekday name according to the US convention in three-lettered abbreviation.
/// Example: Sunday: `Sun`, Thursday: `Thu`.
String ddd(Timestamp ts) => ts.weekday.toAbbr();

/// Identified by `dddd`. Displays the weekday name according to the US convention.
/// Example: Sunday: `Sunday`, Thursday: `Thursday`.
String dddd(Timestamp ts) => ts.weekday.toUpperCamel();

/// Identified by `e`. Displays the weekday number according to the set locale convention.
/// TODO: Implement.
String e(Timestamp ts) => '';

/// Identified by `E`. Displays the weekday number according to ISO8601 convention.
/// Example: Sunday: `7`, Monday: `1`.
String E(Timestamp ts) => ts.weekdayISO.index.toString();

/// Identified by `w`. Displays the week number according to the US convention.
/// TODO: Implement.
String w(Timestamp ts) => '';

/// Identified by `wo`. Displays the week number according to the US convention in ordinal numeral.
String wo(Timestamp ts) => ordinal(w)(ts);

/// Identified by `ww`. Displays the week number according to the US convention padded to length 2.
String ww(Timestamp ts) => pad(w, 2)(ts);

/// Identified by `W`. Displays the week number according to ISO8601 convention.
/// Example: Jan 2, 2020: `1`.
String W(Timestamp ts) => ts.weekOfYearISO.toString();

/// Identified by `Wo`. Displays the week number according to the ISO8601 convention in ordinal numeral.
/// Example: Jan 2, 2020: `1st`.
String Wo(Timestamp ts) => ordinal(W)(ts);

/// Identified by `WW`. Displays the week number according to the ISO8601 convention padded to length 2.
/// Example: Jan 2, 2020: `01`.
String WW(Timestamp ts) => pad(W, 2)(ts);

/// Identified by `Y`. Displays the last two digits of the year number.
/// Example: 1999: `99`.
String YY(Timestamp ts) {
    final output = ts.year.toString();
    return output.length <= 2 ? output.padLeft(2, '0') : output.substring(output.length - 2);
}

/// Identified by `YY`. Displays the last four digits of the year number.
/// Example: 1999: `1999`, 20085: `0085`.
String YYYY(Timestamp ts) {
    final output = ts.year.toString();
    return output.length <= 4 ? output.padLeft(4, '0') : output.substring(output.length - 4);
}

/// Identified by `Y`. Displays the full year number. For years < 0, a negative sign `-` is attached. For year >= 10000,
/// a positive sign `+` is attached.
/// Example: 1999: `1999`, 5: `5`, -5: `-5`, 10094: `+10094`.
String Y(Timestamp ts) => ts.year >= 10000 ? "+${ts.year}" : ts.year.toString;

/// Identified by `gg`. Returns the last two digits of the week year number according to US convention.
/// TODO: implement.
String gg(Timestamp ts) => '';

/// Identified by `gggg`. Returns the last four digits of the week year number according to US convention.
/// TODO: implement.
String gggg(Timestamp ts) => '';

/// Identified by `GG`. Returns the last two digits of the week year number according to the ISO8601 convention.
String GG(Timestamp ts) {
    final output = ts.weekYearISO.toString();
    return output.length <= 2 ? output.padLeft(2, '0') : output.substring(output.length - 2);
}

/// Identified by `GGGG`. Returns the last four digits of the week year number according to the ISO8601 convention.
String GGGG(Timestamp ts) {
    final output = ts.weekYearISO.toString();
    return output.length <= 4 ? output.padLeft(4, '0') : output.substring(output.length - 4);
}

/// Identified by `A`. Returns `AM` if `ts.hour < 12` and `PM` if `ts.hour >= 12`.
String A(Timestamp ts) => ts.isPM ? 'PM' : 'AM';

/// Identified by `a`. Returns `am` if `ts.hour < 12` and `pm` if `ts.hour >= 12`.
String a(Timestamp ts) => ts.isPM ? 'pm' : 'am';

/// Identified by `H`. Returns the hour number with max value of 23..
/// Example: 03:00: `3`.
String H(Timestamp ts) => ts.hour.toString();

/// Identified by `HH`. Returns the hour number with max value of 23 padded to length 2.
/// Example: 03:00: `03`.
String HH(Timestamp ts) => pad(H, 2)(ts);

/// Identified by `h`. Returns the hour number with max value of 12 and assuming that the hour starts at 1.
/// Example: 01:15: `1`, 12:15: `12`, 16:15: `4`.
///
/// NOTE: Current implementation displays time between 0:00 to 0:59 as 12:00 to 12:59. This is likely bad and
/// we expect this to change.
String h(Timestamp ts) => ts.hour % 12 != 0 ? (ts.hour % 12).toString() : "12";

/// Identified by `hh`. Returns the hour number padded to length 2 with max value of 12 and assuming that the hour starts at 1.
/// Example: 01:15: `01`, 12:15: `12`, 16:15: `04`.
///
/// NOTE: Current implementation displays time between 0:00 to 0:59 as 12:00 to 12:59. This is likely bad and
/// we expect this to change.
String hh(Timestamp ts) => pad(h, 2)(ts);

/// Identified by `k`. Returns the hour number with range [1, 24].
/// Example: 00:15: `24`, 13:15: `13`.
String k(Timestamp ts) => ts.hour == 0 ? "24" : ts.hour.toString();

/// Identified by `kk`. Returns the hour number padded to length 2 with range [1, 24].
/// Example: 00:15: `24`, 13:15: `13`.
String kk(Timestamp ts) => pad(k, 2)(ts);

/// Identified by `m`. Returns the minute number with range [0, 59].
/// Example: 00:25: `25`, 13:07: `7`.
String m(Timestamp ts) => ts.minute.toString();

/// Identified by `mm`. Returns the minute number with range [0, 59] padded to length 2.
/// Example: 00:25: `25`, 13:07: `07`.
String mm(Timestamp ts) => pad(m, 2)(ts);

/// Identified by `s`. Returns the second number with range [0, 59].
/// Example: 00:25:25: `25`, 13:07:07: `7`.
String s(Timestamp ts) => ts.second.toString();

/// Identified by `ss`. Returns the second number with range [0, 59] padded to length 2.
/// Example: 00:25:25: `25`, 13:07:07: `07`.
String ss(Timestamp ts) => pad(s, 2)(ts);

/// Returns a token that displays [len]-digit fractional seconds.
FormatToken fracSec(int len) => (ts) {
    final remainder = ts.millisecond * microsecondsPerMillisecond + ts.microsecond;
    final output = len <= 6 ? remainder ~/ pow(10, (6 - len)) : remainder;
    return output.toString().padRight(len, '0');
};

/// Identified by `zz`. Returns the timezone abbreviation. Note: if the 3/4-lettered abbreviations aren't available for the particular
/// timezone, then the timezone offset will be displayed instead.
String zz(Timestamp ts) => ts.timezone.possibleAbbrs[ts.timezone.history.firstWhere((item) => item.until >= ts.instant.microSecondsSinceEpoch()).index];

/// Identified by `z`. Returns the timezone abbreviation. Note: if the 3/4-lettered abbreviations aren't available for the particular
/// timezone, then the timezone offset will be displayed instead.
String z(Timestamp ts) => zz(ts);

/// Identified by `Z`. Returns the timezone offset with the hour and minute part separated by `:`.
String Z(Timestamp ts) {
    final offset = ts.timezone.possibleOffsets[ts.timezone.history.firstWhere((item) => item.until >= ts.instant.microSecondsSinceEpoch()).index];
    final sign = offset.sign;
    final hourPart = (offset ~/ 60).abs();
    final minutePart = (offset % 60).truncate().abs();

    return "${sign >= 0 ? "+" : "-"}${hourPart.toString().padLeft(2, '0')}:${minutePart.toString().padLeft(2, '0')}}";
}

/// Identified by `ZZ`. Returns the timezone offset.
String ZZ(Timestamp ts) {
    final offset = ts.timezone.possibleOffsets[ts.timezone.history.firstWhere((item) => item.until >= ts.instant.microSecondsSinceEpoch()).index];
    final sign = offset.sign;
    final hourPart = (offset ~/ 60).abs();
    final minutePart = (offset % 60).truncate().abs();

    return "${sign >= 0 ? "+" : "-"}${hourPart.toString().padLeft(2, '0')}${minutePart.toString().padLeft(2, '0')}}";
}

/// Identified by `X`. Returns the Unix timestamp in seconds.
String X(Timestamp ts) => (ts.instant.microSecondsSinceEpoch() ~/ pow(10, 6)).toString();

/// Identified by `x`. Returns the Unix timestamp in milliseconds.
String x(Timestamp ts) => (ts.instant.microSecondsSinceEpoch() ~/ pow(10, 3)).toString();