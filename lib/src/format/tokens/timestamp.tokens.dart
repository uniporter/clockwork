import 'dart:math';

import 'package:clockwork/src/format/tokens/utility.tokens.dart';
import 'package:clockwork/src/core/timestamp.dart';
import 'package:clockwork/src/units/conversion.dart';
import 'package:clockwork/src/units/month.dart';
import 'package:clockwork/src/units/weekday.dart';
import 'package:clockwork/src/units/era.dart';
import 'package:clockwork/src/format/tokens/format_token.dart';
import 'package:clockwork/src/format/format.dart';
import 'package:clockwork/src/core/interval.dart';

/// Identified by `M`. Displays the month of the timestamp as Arabic numbers.
/// Example: January: `1`, December: `12`.
String M(Timestamp ts) => ts.month.index.toString();

/// Identified by `MM`. Displays the month of the timestamp as Arabic numbers padded to length 2.
/// Example: January: `01`, December: `12`.
String MM(Timestamp ts) => pad(M, 2)(ts);

/// Identified by `MMM`. Displays the abbreviated name of the timestamp's month in Upper Camel.
/// Example: January: `Jan`, December: `Dec`.
String MMM(Timestamp ts) => ts.month.toAbbr();

/// Identified by `MMMM`. Displays the name of the timestamp's month in Upper Camel.
/// Example: January: `January`, December: `December`.
String MMMM(Timestamp ts) => ts.month.toUpperCamel();

/// Identified by `d`. Displays the day number.
/// Example: 1: `1`, 23: `23`.
String d(Timestamp ts) => ts.day.toString();

/// Identified by `dd`. Displays the day number padded to length 2.
/// Example: 1: `01`, 23: `23`.
String dd(Timestamp ts) => pad(d, 2)(ts);

/// Identified by `ddd`. Displays the day-of-week name in abbreviated form.
/// Example: Saturday: `Sat`.
String ddd(Timestamp ts) => ts.weekdayISO.toAbbr();

/// Identified by `dddd`. Displays the day-of-week name.
/// Example: Saturday: `Saturday`.
String dddd(Timestamp ts) => pad(ddd, 3)(ts);

/// Identified by `yy`. Displays the last two digits of the year of era number.
/// Example: 1999: `99`.
String yy(Timestamp ts) {
    final output = ts.year.toString();
    return output.length <= 2 ? output.padLeft(2, '0') : output.substring(output.length - 2);
}

/// Identified by `yyyy`. Displays the last four digits of the year of era number.
/// Example: 1999: `1999`, 20085: `0085`.
String yyyy(Timestamp ts) {
    final output = ts.year.toString();
    return output.length <= 4 ? output.padLeft(4, '0') : output.substring(output.length - 4);
}

/// Identified by `u`. Displays the year number at one digit preceded by `-` if the year is negative.
String u(Timestamp ts) => ts.year >= 0 ? (ts.year % 10).toString() : "-${ts.year % 10}";

/// Identified by `uu`. Displays the year number at two digits preceded by `-` if the year is negative.
String uu(Timestamp ts) => ts.year >= 0 ? (ts.year % 100).toString().padLeft(2, '0') : "-${(ts.year % 100).toString().padLeft(2, '0')}";

/// Identified by `uuu`. Displays the year number at three digits preceded by `-` if the year is negative.
String uuu(Timestamp ts) => ts.year >= 0 ? (ts.year % 1000).toString().padLeft(3, '0') : "-${(ts.year % 1000).toString().padLeft(3, '0')}";

/// Identified by `uuuu`. Displays the year number at four digits preceded by `-` if the year is negative.
String uuuu(Timestamp ts) => ts.year >= 0 ? (ts.year % 10000).toString().padLeft(4, '0') : "-${(ts.year % 10000).toString().padLeft(4, '0')}";

/// Identified by `g`. Displays the name of the era.
String g(Timestamp ts) => ts.era.toName();

/// Identified by `gg`. Displays the name of the era. Alias for [g].
FormatToken<Timestamp> gg = alias(g);

/// Identified by `t`. Returns the abbreviated AM/PM designator.
String t(Timestamp ts) => ts.isPM ? 'P' : 'A';

/// Identified by `tt`. Returns the full AM/PM designator.
String tt(Timestamp ts) => ts.isPM ? 'PM' : 'AM';

/// Identified by `H`. Returns the hour number with max value of 23.
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
FormatToken<Timestamp> fracSecConstLength(int len) => (ts) {
    final remainder = ts.millisecond * microsecondsPerMillisecond + ts.microsecond;
    final output = len <= 6 ? remainder ~/ pow(10, (6 - len)) : remainder;
    return output.toString().padRight(len, '0');
};

/// Returns a token taht displays fractional seconds to the highest precision at most [len]-digit.
FormatToken<Timestamp> fracSecMinLength(int len) => (ts) {
    final remainder = ts.millisecond * microsecondsPerMillisecond + ts.microsecond;
    return (remainder ~/ pow(10, 6 - len)).toString();
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

/// Identified by `o<tzPattern>`. Returns the timezone of [ts] formatted by [tzPattern].
FormatToken<Timestamp> o(String tzPattern) {
    return (ts) => Format<Interval>.parse(tzPattern).format(ts.timezone.offset(ts.instant.microSecondsSinceEpoch()));
}