import 'dart:math';

import '../../core/timestamp.dart' show Timestamp;
import '../../units/unit.dart';
import 'format_token.dart' show StatefulToken;
import 'utility.tokens.dart';

final StatefulToken<Timestamp> G = StatefulToken((ts, c, l) => c.era(ts).toAbbr(l), 'G');
final StatefulToken<Timestamp> GG = G.clone('GG');
final StatefulToken<Timestamp> GGG = G.clone('GGG');
final StatefulToken<Timestamp> GGGG = StatefulToken((ts, c, l) => c.era(ts).toName(l), 'GGGG');
final StatefulToken<Timestamp> GGGGG = StatefulToken((ts, c, l) => c.era(ts).toNarrow(l), 'GGGGG');

final StatefulToken<Timestamp> y = StatefulToken((ts, c, _) => c.yearOfEra(ts).toString(), 'y');
final StatefulToken<Timestamp> yy = StatefulToken((ts, c, _) => (c.yearOfEra(ts)() % 100).toString().padLeft(2, '0'), 'yy');
StatefulToken<Timestamp> yPlus(int len) => y.withMinLength(len, true, 'yPlus');

final StatefulToken<Timestamp> Y = StatefulToken((ts, c, _) => c.weekYear(ts).toString(), 'Y');
final StatefulToken<Timestamp> YY = StatefulToken((ts, c, _) => (c.weekYear(ts)() % 100).toString().padLeft(2, '0'), 'YY');
StatefulToken<Timestamp> YPlus(int len) => Y.withMinLength(len, true, 'YPlus');

final StatefulToken<Timestamp> u = StatefulToken((ts, c, _) => c.year(ts).toString(), 'u');
StatefulToken<Timestamp> uPlus(int len) => u.withMinLength(len, true, 'uPlus');

final StatefulToken<Timestamp> U = StatefulToken((ts, c, l) {
    final cyclicYear = c.cyclicYear(ts);
    if (cyclicYear is CyclicYear) return cyclicYear.toAbbr(l);
    else return y(ts, c, l);
}, 'U');
final StatefulToken<Timestamp> UU = U.clone('UU');
final StatefulToken<Timestamp> UUU = U.clone('UUU');
final StatefulToken<Timestamp> UUUU = StatefulToken((ts, c, l) {
    final cyclicYear = c.cyclicYear(ts);
    if (cyclicYear is CyclicYear) return cyclicYear.toWide(l);
    else return y(ts, c, l);
}, 'UUUU');
final StatefulToken<Timestamp> UUUUU = StatefulToken((ts, c, l) {
    final cyclicYear = c.cyclicYear(ts);
    if (cyclicYear is CyclicYear) return cyclicYear.toNarrow(l);
    else return y(ts, c, l);
}, 'UUUUU');

final StatefulToken<Timestamp> r = StatefulToken((ts, c, _) => c.relativeGregorianYear(ts).toString(), 'r');
StatefulToken<Timestamp> rPlus(int len) => r.withMinLength(len, true, 'rPlus');

final StatefulToken<Timestamp> Q = StatefulToken((ts, c, _) => c.quarter(ts).toString(), 'Q');
final StatefulToken<Timestamp> QQ = Q.withMinLength(2, true, 'QQ');
final StatefulToken<Timestamp> QQQ = StatefulToken((ts, c, l) => c.quarter(ts).toAbbr(l), 'QQQ');
final StatefulToken<Timestamp> QQQQ = StatefulToken((ts, c, l) => c.quarter(ts).toWide(l), 'QQQQ');
final StatefulToken<Timestamp> QQQQQ = StatefulToken((ts, c, l) => c.quarter(ts).toNarrow(l), 'QQQQQ');

final StatefulToken<Timestamp> q = Q.clone('q');
final StatefulToken<Timestamp> qq = QQ.clone('qq');
final StatefulToken<Timestamp> qqq = StatefulToken((ts, c, l) => c.quarter(ts).toAbbrStandalone(l), 'qqq');
final StatefulToken<Timestamp> qqqq = StatefulToken((ts, c, l) => c.quarter(ts).toWideStandalone(l), 'qqqq');
final StatefulToken<Timestamp> qqqqq = StatefulToken((ts, c, l) => c.quarter(ts).toNarrowStandalone(l), 'qqqqq');

final StatefulToken<Timestamp> M = StatefulToken((ts, c, _) => c.month(ts).toString(), 'M');
final StatefulToken<Timestamp> MM = M.withMinLength(2, true, 'MM');
final StatefulToken<Timestamp> MMM = StatefulToken((ts, c, l) => c.month(ts).toAbbr(l), 'MMM');
final StatefulToken<Timestamp> MMMM = StatefulToken((ts, c, l) => c.month(ts).toWide(l), 'MMMM');
final StatefulToken<Timestamp> MMMMM = StatefulToken((ts, c, l) => c.month(ts).toNarrow(l), 'MMMMM');

final StatefulToken<Timestamp> L = M.clone('L');
final StatefulToken<Timestamp> LL = MM.clone('LL');
final StatefulToken<Timestamp> LLL = StatefulToken((ts, c, l) => c.month(ts).toAbbrStandalone(l), 'LLL');
final StatefulToken<Timestamp> LLLL = StatefulToken((ts, c, l) => c.month(ts).toWideStandalone(l), 'LLLL');
final StatefulToken<Timestamp> LLLLL = StatefulToken((ts, c, l) => c.month(ts).toNarrowStandalone(l), 'LLLLL');

final StatefulToken<Timestamp> w = StatefulToken((ts, c, l) => c.weekOfYear(ts, l).toString(), 'w');
final StatefulToken<Timestamp> ww = w.withMinLength(2, true, 'ww');
final StatefulToken<Timestamp> W = StatefulToken((ts, c, l) => c.weekOfMonth(ts, l).toString(), 'W');

final StatefulToken<Timestamp> d = StatefulToken((ts, c, _) => c.day(ts).toString(), 'd');
final StatefulToken<Timestamp> dd = d.withMinLength(2, true, 'dd');
final StatefulToken<Timestamp> D = StatefulToken((ts, c, _) => c.dayOfYear(ts).toString(), 'D');
final StatefulToken<Timestamp> DD = D.withMinLength(2, true, 'DD');
final StatefulToken<Timestamp> DDD = D.withMinLength(3, true, 'DDD');

// TODO final StatefulToken<Timestamp> F
// TODO final StatefulToken<Timestamp> g

final StatefulToken<Timestamp> E = StatefulToken((ts, c, l) => c.weekday(ts).toAbbr(l), 'E');
final StatefulToken<Timestamp> EE = E.clone('EE');
final StatefulToken<Timestamp> EEE = EE.clone('EEE');
final StatefulToken<Timestamp> EEEE = StatefulToken((ts, c, l) => c.weekday(ts).toWide(l), 'EEEE');
final StatefulToken<Timestamp> EEEEE = StatefulToken((ts, c, l) => c.weekday(ts).toNarrow(l), 'EEEEE');
final StatefulToken<Timestamp> EEEEEE = StatefulToken((ts, c, l) => c.weekday(ts).toShort(l), 'EEEEEE');

final StatefulToken<Timestamp> e = StatefulToken((ts, c, l) => c.weekday(ts).toString(), 'e');
final StatefulToken<Timestamp> ee = e.withMinLength(2, true, 'ee');
final StatefulToken<Timestamp> eee = EEE.clone('eee');
final StatefulToken<Timestamp> eeee = EEEE.clone('eeee');
final StatefulToken<Timestamp> eeeee = EEEEE.clone('eeeee');
final StatefulToken<Timestamp> eeeeee = EEEEEE.clone('eeeeee');

final StatefulToken<Timestamp> c = e.clone('c');
final StatefulToken<Timestamp> cc = e.clone('cc');
final StatefulToken<Timestamp> ccc = StatefulToken((ts, c, l) => c.weekday(ts).toAbbrStandalone(l), 'ccc');
final StatefulToken<Timestamp> cccc = StatefulToken((ts, c, l) => c.weekday(ts).toWideStandalone(l), 'cccc');
final StatefulToken<Timestamp> ccccc = StatefulToken((ts, c, l) => c.weekday(ts).toNarrowStandalone(l), 'ccccc');
final StatefulToken<Timestamp> cccccc = StatefulToken((ts, c, l) => c.weekday(ts).toShortStandalone(l), 'cccccc');

final StatefulToken<Timestamp> a = StatefulToken((ts, c, l) => c.fixedDayPeriod(ts).toAbbr(l), 'a');
final StatefulToken<Timestamp> aa = a.clone('aa');
final StatefulToken<Timestamp> aaa = a.clone('aaa');
final StatefulToken<Timestamp> aaaa = StatefulToken((ts, c, l) => c.fixedDayPeriod(ts).toWide(l), 'aaaa');
final StatefulToken<Timestamp> aaaaa = StatefulToken((ts, c, l) => c.fixedDayPeriod(ts).toNarrow(l), 'aaaaa');

final StatefulToken<Timestamp> b = StatefulToken((ts, c, l) {
    final dp = c.dayPeriod(ts, l);
    if (dp == DayPeriod.Noon || dp == DayPeriod.Midnight) return dp?.toAbbr(l);
    else return c.fixedDayPeriod(ts).toAbbr(l);
}, 'b');
final StatefulToken<Timestamp> bb = b.clone('bb');
final StatefulToken<Timestamp> bbb = b.clone('bbb');
final StatefulToken<Timestamp> bbbb = StatefulToken((ts, c, l) {
    final dp = c.dayPeriod(ts, l);
    if (dp == DayPeriod.Noon || dp == DayPeriod.Midnight) return dp?.toWide(l);
    else return c.fixedDayPeriod(ts).toWide(l);
}, 'bbbb');
final StatefulToken<Timestamp> bbbbb = StatefulToken((ts, c, l) {
    final dp = c.dayPeriod(ts, l);
    if (dp == DayPeriod.Noon || dp == DayPeriod.Midnight) return dp?.toNarrow(l);
    else return c.fixedDayPeriod(ts).toNarrow(l);
}, 'bbbbb');

final StatefulToken<Timestamp> B = StatefulToken((ts, c, l) {
    return c.dayPeriod(ts, l)?.toAbbr(l);
}, 'B');
final StatefulToken<Timestamp> BB = B.clone('BB');
final StatefulToken<Timestamp> BBB = B.clone('BBB');
final StatefulToken<Timestamp> BBBB = StatefulToken((ts, c, l) {
    return c.dayPeriod(ts, l)?.toWide(l);
}, 'BBBB');
final StatefulToken<Timestamp> BBBBB = StatefulToken((ts, c, l) {
    return c.dayPeriod(ts, l)?.toNarrow(l);
}, 'BBBBB');

final StatefulToken<Timestamp> H = StatefulToken((ts, __, _) => ts.hour.toString(), 'H');
final StatefulToken<Timestamp> HH = H.withMinLength(2, true, 'HH');
final StatefulToken<Timestamp> K = StatefulToken((ts, __, _) => (ts.hour() % 12).toString(), 'K');
final StatefulToken<Timestamp> KK = K.withMinLength(2, true, 'KK');

// TODO final StatefulToken<Timestamp> h
// TODO final StatefulToken<Timestamp> hh
// TODO final StatefulToken<Timestamp> k
// TODO final StatefulToken<Timestamp> kk

final StatefulToken<Timestamp> m = StatefulToken((ts, __, _) => ts.minute.toString(), 'm');
final StatefulToken<Timestamp> mm = m.withMinLength(2, true, 'mm');
final StatefulToken<Timestamp> s = StatefulToken((ts, __, _) => ts.second.toString(), 's');
final StatefulToken<Timestamp> ss = s.withMinLength(2, true, 'ss');

StatefulToken<Timestamp> SPlus(int len) => StatefulToken((ts, _, __) {
    final microseconds = Millisecond.microsecondsPer * ts.millisecond() + ts.microsecond();
    return (microseconds / pow(10, len - 6)).truncate().toString();
}, 'SPlus');

// TODO final StatefulToken<Timestamp> A

final StatefulToken<Timestamp> Z = xxxx.clone('Z');
final StatefulToken<Timestamp> ZZ = xxxx.clone('ZZ');
final StatefulToken<Timestamp> ZZZ = xxxx.clone('ZZZ');
// final StatefulToken<Timestamp> ZZZZ = OOOO.clone('ZZZZ');
final StatefulToken<Timestamp> ZZZZZ = XXXXX.clone('ZZZZZ');

final StatefulToken<Timestamp> X = x.conditional(string('Z'), (str) => str == '+00');
final StatefulToken<Timestamp> XX = xx.conditional(string('Z'), (str) => str == '+0000');
final StatefulToken<Timestamp> XXX = xxx.conditional(string('Z'), (str) => str == '+00:00');
final StatefulToken<Timestamp> XXXX = xxxx.conditional(string('Z'), (str) => str == '+0000');
final StatefulToken<Timestamp> XXXXX = xxxxx.conditional(string('Z'), (str) => str == '+00:00');

final StatefulToken<Timestamp> x = StatefulToken((ts, _, __) {
    final offset = ts.timezone.offset(ts.instant.microsecondsSinceEpoch());
    final sb = StringBuffer()
        ..write(offset.sign >= 0 ? '+' : '-')
        ..write(offset.hour.toString().padLeft(2, '0'))
        ..write(offset.minute == 0 ? '' : offset.minute.toString().padLeft(2, '0'));
    return sb.toString();
});

final StatefulToken<Timestamp> xx = StatefulToken((ts, _, __) {
    final offset = ts.timezone.offset(ts.instant.microsecondsSinceEpoch());
    final sb = StringBuffer()
        ..write(offset.sign >= 0 ? '+' : '-')
        ..write(offset.hour.toString().padLeft(2, '0'))
        ..write(offset.minute.toString().padLeft(2, '0'));
    return sb.toString();
});

final StatefulToken<Timestamp> xxx = StatefulToken((ts, _, __) {
    final offset = ts.timezone.offset(ts.instant.microsecondsSinceEpoch());
    final sb = StringBuffer()
        ..write(offset.sign >= 0 ? '+' : '-')
        ..write(offset.hour.toString().padLeft(2, '0'))
        ..write(':')
        ..write(offset.minute.toString().padLeft(2, '0'));
    return sb.toString();
});

final StatefulToken<Timestamp> xxxx = StatefulToken((ts, _, __) {
    final offset = ts.timezone.offset(ts.instant.microsecondsSinceEpoch());
    final sb = StringBuffer()
        ..write(offset.sign >= 0 ? '+' : '-')
        ..write(offset.hour.toString().padLeft(2, '0'))
        ..write(offset.minute.toString().padLeft(2, '0'))
        ..write(offset.second == 0 ? '' : offset.second.toString().padLeft(2, '0'));
    return sb.toString();
});

final StatefulToken<Timestamp> xxxxx = StatefulToken((ts, _, __) {
    final offset = ts.timezone.offset(ts.instant.microsecondsSinceEpoch());
    final sb = StringBuffer()
        ..write(offset.sign >= 0 ? '+' : '-')
        ..write(offset.hour.toString().padLeft(2, '0'))
        ..write(':')
        ..write(offset.minute.toString().padLeft(2, '0'))
        ..write(offset.second == 0 ? '' : offset.second.toString().padLeft(2, '0').padLeft(3, ':'));
    return sb.toString();
});