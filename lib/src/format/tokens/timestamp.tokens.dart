import 'dart:math';

import '../../core/timestamp.dart' show Timestamp;
import '../../units/unit.dart';
import 'format_token.dart' show StatefulToken;
import 'utility.tokens.dart';

StatefulToken<Timestamp> G = StatefulToken((ts, c, l) => c.era(ts).toAbbr(l), 'G');
StatefulToken<Timestamp> GG = G.clone('GG');
StatefulToken<Timestamp> GGG = G.clone('GGG');
StatefulToken<Timestamp> GGGG = StatefulToken((ts, c, l) => c.era(ts).toName(l), 'GGGG');
StatefulToken<Timestamp> GGGGG = StatefulToken((ts, c, l) => c.era(ts).toNarrow(l), 'GGGGG');

StatefulToken<Timestamp> y = StatefulToken((ts, c, _) => c.yearOfEra(ts).toString(), 'y');
StatefulToken<Timestamp> yy = StatefulToken((ts, c, _) => (c.yearOfEra(ts)() % 100).toString().padLeft(2, '0'), 'yy');
StatefulToken<Timestamp> yPlus(int len) => y.withMinLength(len, true, 'yPlus');

StatefulToken<Timestamp> Y = StatefulToken((ts, c, _) => c.weekYear(ts).toString(), 'Y');
StatefulToken<Timestamp> YY = StatefulToken((ts, c, _) => (c.weekYear(ts)() % 100).toString().padLeft(2, '0'), 'YY');
StatefulToken<Timestamp> YPlus(int len) => Y.withMinLength(len, true, 'YPlus');

StatefulToken<Timestamp> u = StatefulToken((ts, c, _) => c.year(ts).toString(), 'u');
StatefulToken<Timestamp> uPlus(int len) => u.withMinLength(len, true, 'uPlus');

StatefulToken<Timestamp> U = StatefulToken((ts, c, _) {
    final cyclicYear = c.cyclicYear(ts);
    if (cyclicYear is CyclicYear) return cyclicYear.toAbbr();
    else return y(ts, c, _);
}, 'U');
StatefulToken<Timestamp> UU = U.clone('UU');
StatefulToken<Timestamp> UUU = U.clone('UUU');
StatefulToken<Timestamp> UUUU = StatefulToken((ts, c, _) {
    final cyclicYear = c.cyclicYear(ts);
    if (cyclicYear is CyclicYear) return cyclicYear.toWide();
    else return y(ts, c, _);
}, 'UUUU');
StatefulToken<Timestamp> UUUUU = StatefulToken((ts, c, _) {
    final cyclicYear = c.cyclicYear(ts);
    if (cyclicYear is CyclicYear) return cyclicYear.toNarrow();
    else return y(ts, c, _);
}, 'UUUUU');

StatefulToken<Timestamp> r = StatefulToken((ts, c, _) => c.relativeGregorianYear(ts).toString(), 'r');
StatefulToken<Timestamp> rPlus(int len) => r.withMinLength(len, true, 'rPlus');

StatefulToken<Timestamp> Q = StatefulToken((ts, c, _) => c.quarter(ts).toString(), 'Q');
StatefulToken<Timestamp> QQ = Q.withMinLength(2, true, 'QQ');
StatefulToken<Timestamp> QQQ = StatefulToken((ts, c, l) => c.quarter(ts).toAbbr(l), 'QQQ');
StatefulToken<Timestamp> QQQQ = StatefulToken((ts, c, l) => c.quarter(ts).toWide(l), 'QQQQ');
StatefulToken<Timestamp> QQQQQ = StatefulToken((ts, c, l) => c.quarter(ts).toNarrow(l), 'QQQQQ');

StatefulToken<Timestamp> q = Q.clone('q');
StatefulToken<Timestamp> qq = QQ.clone('qq');
StatefulToken<Timestamp> qqq = StatefulToken((ts, c, l) => c.quarter(ts).toAbbrStandalone(l), 'qqq');
StatefulToken<Timestamp> qqqq = StatefulToken((ts, c, l) => c.quarter(ts).toWideStandalone(l), 'qqqq');
StatefulToken<Timestamp> qqqqq = StatefulToken((ts, c, l) => c.quarter(ts).toNarrowStandalone(l), 'qqqqq');

StatefulToken<Timestamp> M = StatefulToken((ts, c, _) => c.month(ts).toString(), 'M');
StatefulToken<Timestamp> MM = M.withMinLength(2, true, 'MM');
StatefulToken<Timestamp> MMM = StatefulToken((ts, c, l) => c.month(ts).toAbbr(l), 'MMM');
StatefulToken<Timestamp> MMMM = StatefulToken((ts, c, l) => c.month(ts).toWide(l), 'MMMM');
StatefulToken<Timestamp> MMMMM = StatefulToken((ts, c, l) => c.month(ts).toNarrow(l), 'MMMMM');

StatefulToken<Timestamp> L = M.clone('L');
StatefulToken<Timestamp> LL = MM.clone('LL');
StatefulToken<Timestamp> LLL = StatefulToken((ts, c, l) => c.month(ts).toAbbrStandalone(l), 'LLL');
StatefulToken<Timestamp> LLLL = StatefulToken((ts, c, l) => c.month(ts).toWideStandalone(l), 'LLLL');
StatefulToken<Timestamp> LLLLL = StatefulToken((ts, c, l) => c.month(ts).toNarrowStandalone(l), 'LLLLL');

StatefulToken<Timestamp> w = StatefulToken((ts, c, l) => c.weekOfYear(ts, l).toString(), 'w');
StatefulToken<Timestamp> ww = w.withMinLength(2, true, 'ww');
StatefulToken<Timestamp> W = StatefulToken((ts, c, l) => c.weekOfMonth(ts, l).toString(), 'W');

StatefulToken<Timestamp> d = StatefulToken((ts, c, _) => c.day(ts).toString(), 'd');
StatefulToken<Timestamp> dd = d.withMinLength(2, true, 'dd');
StatefulToken<Timestamp> D = StatefulToken((ts, c, _) => c.dayOfYear(ts).toString(), 'D');
StatefulToken<Timestamp> DD = D.withMinLength(2, true, 'DD');
StatefulToken<Timestamp> DDD = D.withMinLength(3, true, 'DDD');

// TODO StatefulToken<Timestamp> F
// TODO StatefulToken<Timestamp> g

StatefulToken<Timestamp> E = StatefulToken((ts, c, l) => c.weekday(ts).toAbbr(), 'E');
StatefulToken<Timestamp> EE = E.clone('EE');
StatefulToken<Timestamp> EEE = EE.clone('EEE');
StatefulToken<Timestamp> EEEE = StatefulToken((ts, c, l) => c.weekday(ts).toWide(), 'EEEE');
StatefulToken<Timestamp> EEEEE = StatefulToken((ts, c, l) => c.weekday(ts).toNarrow(), 'EEEEE');
StatefulToken<Timestamp> EEEEEE = StatefulToken((ts, c, l) => c.weekday(ts).toShort(), 'EEEEEE');

StatefulToken<Timestamp> e = StatefulToken((ts, c, l) => c.weekday(ts).toString(), 'e');
StatefulToken<Timestamp> ee = e.withMinLength(2, true, 'ee');
StatefulToken<Timestamp> eee = EEE.clone('eee');
StatefulToken<Timestamp> eeee = EEEE.clone('eeee');
StatefulToken<Timestamp> eeeee = EEEEE.clone('eeeee');
StatefulToken<Timestamp> eeeeee = EEEEEE.clone('eeeeee');

StatefulToken<Timestamp> c = e.clone('c');
StatefulToken<Timestamp> cc = e.clone('cc');
StatefulToken<Timestamp> ccc = StatefulToken((ts, c, l) => c.weekday(ts).toAbbrStandalone(), 'ccc');
StatefulToken<Timestamp> cccc = StatefulToken((ts, c, l) => c.weekday(ts).toWideStandalone(), 'cccc');
StatefulToken<Timestamp> ccccc = StatefulToken((ts, c, l) => c.weekday(ts).toNarrowStandalone(), 'ccccc');
StatefulToken<Timestamp> cccccc = StatefulToken((ts, c, l) => c.weekday(ts).toShortStandalone(), 'cccccc');

StatefulToken<Timestamp> a = StatefulToken((ts, c, l) => c.fixedDayPeriod(ts).toAbbr(l), 'a');
StatefulToken<Timestamp> aa = a.clone('aa');
StatefulToken<Timestamp> aaa = a.clone('aaa');
StatefulToken<Timestamp> aaaa = StatefulToken((ts, c, l) => c.fixedDayPeriod(ts).toWide(l), 'aaaa');
StatefulToken<Timestamp> aaaaa = StatefulToken((ts, c, l) => c.fixedDayPeriod(ts).toNarrow(l), 'aaaaa');

StatefulToken<Timestamp> b = StatefulToken((ts, c, l) {
    final dp = c.dayPeriod(ts, l);
    if (dp == DayPeriod.Noon || dp == DayPeriod.Midnight) return dp.toAbbr();
    else return c.fixedDayPeriod(ts).toAbbr();
}, 'b');
StatefulToken<Timestamp> bb = b.clone('bb');
StatefulToken<Timestamp> bbb = b.clone('bbb');
StatefulToken<Timestamp> bbbb = StatefulToken((ts, c, l) {
    final dp = c.dayPeriod(ts, l);
    if (dp == DayPeriod.Noon || dp == DayPeriod.Midnight) return dp.toWide();
    else return c.fixedDayPeriod(ts).toWide();
}, 'bbbb');
StatefulToken<Timestamp> bbbbb = StatefulToken((ts, c, l) {
    final dp = c.dayPeriod(ts, l);
    if (dp == DayPeriod.Noon || dp == DayPeriod.Midnight) return dp.toNarrow();
    else return c.fixedDayPeriod(ts).toNarrow();
}, 'bbbbb');

StatefulToken<Timestamp> B = StatefulToken((ts, c, l) {
    final dp = c.dayPeriod(ts, l);
    return dp != null ? dp.toAbbr() : c.fixedDayPeriod(ts).toAbbr();
}, 'B');
StatefulToken<Timestamp> BB = B.clone('BB');
StatefulToken<Timestamp> BBB = B.clone('BBB');
StatefulToken<Timestamp> BBBB = StatefulToken((ts, c, l) {
    final dp = c.dayPeriod(ts, l);
    return dp != null ? dp.toWide() : c.fixedDayPeriod(ts).toWide();
}, 'BBBB');
StatefulToken<Timestamp> BBBBB = StatefulToken((ts, c, l) {
    final dp = c.dayPeriod(ts, l);
    return dp != null ? dp.toNarrow() : c.fixedDayPeriod(ts).toNarrow();
}, 'BBBBB');

StatefulToken<Timestamp> H = StatefulToken((ts, __, _) => ts.hour.toString(), 'H');
StatefulToken<Timestamp> HH = H.withMinLength(2, true, 'HH');
StatefulToken<Timestamp> K = StatefulToken((ts, __, _) => (ts.hour() % 12).toString(), 'K');
StatefulToken<Timestamp> KK = K.withMinLength(2, true, 'KK');

// TODO StatefulToken<Timestamp> h
// TODO StatefulToken<Timestamp> hh
// TODO StatefulToken<Timestamp> k
// TODO StatefulToken<Timestamp> kk

StatefulToken<Timestamp> m = StatefulToken((ts, __, _) => ts.minute.toString(), 'm');
StatefulToken<Timestamp> mm = m.withMinLength(2, true, 'mm');
StatefulToken<Timestamp> s = StatefulToken((ts, __, _) => ts.second.toString(), 's');
StatefulToken<Timestamp> ss = s.withMinLength(2, true, 'ss');

StatefulToken<Timestamp> SPlus(int len) => StatefulToken((ts, _, __) {
    final microseconds = Millisecond.microsecondsPer * ts.millisecond() + ts.microsecond();
    return (microseconds / pow(10, len - 6)).truncate().toString();
}, 'SPlus');

// TODO StatefulToken<Timestamp> A

StatefulToken<Timestamp> Z = xxxx.clone('Z');
StatefulToken<Timestamp> ZZ = xxxx.clone('ZZ');
StatefulToken<Timestamp> ZZZ = xxxx.clone('ZZZ');
StatefulToken<Timestamp> ZZZZ = OOOO.clone('ZZZZ');
StatefulToken<Timestamp> ZZZZZ = XXXXX.clone('ZZZZZ');


StatefulToken<Timestamp> OOOO = StatefulToken((ts, _, l) => l.format.timezone.gmt(XXXXX(ts, _, l) as String));

StatefulToken<Timestamp> X = x.conditional(string('Z'), (str) => str == '+00');
StatefulToken<Timestamp> XX = xx.conditional(string('Z'), (str) => str == '+0000');
StatefulToken<Timestamp> XXX = xxx.conditional(string('Z'), (str) => str == '+00:00');
StatefulToken<Timestamp> XXXX = xxxx.conditional(string('Z'), (str) => str == '+0000');
StatefulToken<Timestamp> XXXXX = xxxxx.conditional(string('Z'), (str) => str == '+00:00');

StatefulToken<Timestamp> x = StatefulToken((ts, _, __) {
    final offset = ts.timezone.offset(ts.instant.microsecondsSinceEpoch());
    final sb = StringBuffer()
        ..write(offset.sign >= 0 ? '+' : '-')
        ..write(offset.hour.toString().padLeft(2, '0'))
        ..write(offset.minute == 0 ? '' : offset.minute.toString().padLeft(2, '0'));
    return sb.toString();
});

StatefulToken<Timestamp> xx = StatefulToken((ts, _, __) {
    final offset = ts.timezone.offset(ts.instant.microsecondsSinceEpoch());
    final sb = StringBuffer()
        ..write(offset.sign >= 0 ? '+' : '-')
        ..write(offset.hour.toString().padLeft(2, '0'))
        ..write(offset.minute.toString().padLeft(2, '0'));
    return sb.toString();
});

StatefulToken<Timestamp> xxx = StatefulToken((ts, _, __) {
    final offset = ts.timezone.offset(ts.instant.microsecondsSinceEpoch());
    final sb = StringBuffer()
        ..write(offset.sign >= 0 ? '+' : '-')
        ..write(offset.hour.toString().padLeft(2, '0'))
        ..write(':')
        ..write(offset.minute.toString().padLeft(2, '0'));
    return sb.toString();
});

StatefulToken<Timestamp> xxxx = StatefulToken((ts, _, __) {
    final offset = ts.timezone.offset(ts.instant.microsecondsSinceEpoch());
    final sb = StringBuffer()
        ..write(offset.sign >= 0 ? '+' : '-')
        ..write(offset.hour.toString().padLeft(2, '0'))
        ..write(offset.minute.toString().padLeft(2, '0'))
        ..write(offset.second == 0 ? '' : offset.second.toString().padLeft(2, '0'));
    return sb.toString();
});

StatefulToken<Timestamp> xxxxx = StatefulToken((ts, _, __) {
    final offset = ts.timezone.offset(ts.instant.microsecondsSinceEpoch());
    final sb = StringBuffer()
        ..write(offset.sign >= 0 ? '+' : '-')
        ..write(offset.hour.toString().padLeft(2, '0'))
        ..write(':')
        ..write(offset.minute.toString().padLeft(2, '0'))
        ..write(offset.second == 0 ? '' : offset.second.toString().padLeft(2, '0').padLeft(3, ':'));
    return sb.toString();
});
