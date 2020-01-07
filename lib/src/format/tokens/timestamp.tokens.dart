import 'dart:math';

import '../../core/timestamp.dart' show Timestamp;
import '../../units/unit.dart';
import 'format_token.dart' show StatefulToken;

StatefulToken<Timestamp> G = StatefulToken((ts, c, l) => c.era(ts).toAbbr(l));
StatefulToken<Timestamp> GG = G.clone();
StatefulToken<Timestamp> GGG = G.clone();
StatefulToken<Timestamp> GGGG = StatefulToken((ts, c, l) => c.era(ts).toName(l));
StatefulToken<Timestamp> GGGGG = StatefulToken((ts, c, l) => c.era(ts).toNarrow(l));

StatefulToken<Timestamp> y = StatefulToken((ts, c, _) => c.yearOfEra(ts).toString());
StatefulToken<Timestamp> yy = StatefulToken((ts, c, _) => (c.yearOfEra(ts)() % 100).toString().padLeft(2, '0'));
StatefulToken<Timestamp> yPlus(int len) => y.withMinLength(len, true);

StatefulToken<Timestamp> Y = StatefulToken((ts, c, _) => c.weekYear(ts).toString());
StatefulToken<Timestamp> YY = StatefulToken((ts, c, _) => (c.weekYear(ts)() % 100).toString().padLeft(2, '0'));
StatefulToken<Timestamp> YPlus(int len) => Y.withMinLength(len, true);

StatefulToken<Timestamp> u = StatefulToken((ts, c, _) => c.year(ts).toString());
StatefulToken<Timestamp> uPlus(int len) => u.withMinLength(len, true);

StatefulToken<Timestamp> U = StatefulToken((ts, c, _) {
    final cyclicYear = c.cyclicYear(ts);
    if (cyclicYear is CyclicYear) return cyclicYear.toAbbr();
    else return y(ts, c, _);
});
StatefulToken<Timestamp> UU = U.clone();
StatefulToken<Timestamp> UUU = U.clone();
StatefulToken<Timestamp> UUUU = StatefulToken((ts, c, _) {
    final cyclicYear = c.cyclicYear(ts);
    if (cyclicYear is CyclicYear) return cyclicYear.toWide();
    else return y(ts, c, _);
});
StatefulToken<Timestamp> UUUUU = StatefulToken((ts, c, _) {
    final cyclicYear = c.cyclicYear(ts);
    if (cyclicYear is CyclicYear) return cyclicYear.toNarrow();
    else return y(ts, c, _);
});

StatefulToken<Timestamp> r = StatefulToken((ts, c, _) => c.relativeGregorianYear(ts).toString());
StatefulToken<Timestamp> rPlus(int len) => r.withMinLength(len, true);

StatefulToken<Timestamp> Q = StatefulToken((ts, c, _) => c.quarter(ts).toString());
StatefulToken<Timestamp> QQ = Q.withMinLength(2, true);
StatefulToken<Timestamp> QQQ = StatefulToken((ts, c, l) => c.quarter(ts).toAbbr(l));
StatefulToken<Timestamp> QQQQ = StatefulToken((ts, c, l) => c.quarter(ts).toWide(l));
StatefulToken<Timestamp> QQQQQ = StatefulToken((ts, c, l) => c.quarter(ts).toNarrow(l));

StatefulToken<Timestamp> q = Q.clone();
StatefulToken<Timestamp> qq = QQ.clone();
StatefulToken<Timestamp> qqq = StatefulToken((ts, c, l) => c.quarter(ts).toAbbrStandalone(l));
StatefulToken<Timestamp> qqqq = StatefulToken((ts, c, l) => c.quarter(ts).toWideStandalone(l));
StatefulToken<Timestamp> qqqqq = StatefulToken((ts, c, l) => c.quarter(ts).toNarrowStandalone(l));

StatefulToken<Timestamp> M = StatefulToken((ts, c, _) => c.month(ts).toString());
StatefulToken<Timestamp> MM = M.withMinLength(2, true);
StatefulToken<Timestamp> MMM = StatefulToken((ts, c, l) => c.month(ts).toAbbr(l));
StatefulToken<Timestamp> MMMM = StatefulToken((ts, c, l) => c.month(ts).toWide(l));
StatefulToken<Timestamp> MMMMM = StatefulToken((ts, c, l) => c.month(ts).toNarrow(l));

StatefulToken<Timestamp> L = M.clone();
StatefulToken<Timestamp> LL = MM.clone();
StatefulToken<Timestamp> LLL = StatefulToken((ts, c, l) => c.month(ts).toAbbrStandalone(l));
StatefulToken<Timestamp> LLLL = StatefulToken((ts, c, l) => c.month(ts).toWideStandalone(l));
StatefulToken<Timestamp> LLLLL = StatefulToken((ts, c, l) => c.month(ts).toNarrowStandalone(l));

StatefulToken<Timestamp> w = StatefulToken((ts, c, l) => c.weekOfYear(ts, l).toString());
StatefulToken<Timestamp> ww = w.withMinLength(2, true);
StatefulToken<Timestamp> W = StatefulToken((ts, c, l) => c.weekOfMonth(ts, l).toString());

StatefulToken<Timestamp> d = StatefulToken((ts, c, _) => c.day(ts).toString());
StatefulToken<Timestamp> dd = d.withMinLength(2, true);
StatefulToken<Timestamp> D = StatefulToken((ts, c, _) => c.dayOfYear(ts).toString());
StatefulToken<Timestamp> DD = D.withMinLength(2, true);
StatefulToken<Timestamp> DDD = D.withMinLength(3, true);

// TODO StatefulToken<Timestamp> F
// TODO StatefulToken<Timestamp> g

StatefulToken<Timestamp> E = StatefulToken((ts, c, l) => c.weekday(ts, l).toAbbr());
StatefulToken<Timestamp> EE = E.clone();
StatefulToken<Timestamp> EEE = EE.clone();
StatefulToken<Timestamp> EEEE = StatefulToken((ts, c, l) => c.weekday(ts, l).toWide());
StatefulToken<Timestamp> EEEEE = StatefulToken((ts, c, l) => c.weekday(ts, l).toNarrow());
StatefulToken<Timestamp> EEEEEE = StatefulToken((ts, c, l) => c.weekday(ts, l).toShort());

StatefulToken<Timestamp> e = StatefulToken((ts, c, l) => c.weekday(ts, l).toString());
StatefulToken<Timestamp> ee = e.withMinLength(2, true);
StatefulToken<Timestamp> eee = EEE.clone();
StatefulToken<Timestamp> eeee = EEEE.clone();
StatefulToken<Timestamp> eeeee = EEEEE.clone();
StatefulToken<Timestamp> eeeeee = EEEEEE.clone();

StatefulToken<Timestamp> c = e.clone();
StatefulToken<Timestamp> cc = e.clone();
StatefulToken<Timestamp> ccc = StatefulToken((ts, c, l) => c.weekday(ts, l).toAbbrStandalone());
StatefulToken<Timestamp> cccc = StatefulToken((ts, c, l) => c.weekday(ts, l).toWideStandalone());
StatefulToken<Timestamp> ccccc = StatefulToken((ts, c, l) => c.weekday(ts, l).toNarrowStandalone());
StatefulToken<Timestamp> cccccc = StatefulToken((ts, c, l) => c.weekday(ts, l).toShortStandalone());

StatefulToken<Timestamp> a = StatefulToken((ts, c, l) => c.fixedDayPeriod(ts).toAbbr(l));
StatefulToken<Timestamp> aa = a.clone();
StatefulToken<Timestamp> aaa = a.clone();
StatefulToken<Timestamp> aaaa = StatefulToken((ts, c, l) => c.fixedDayPeriod(ts).toWide(l));
StatefulToken<Timestamp> aaaaa = StatefulToken((ts, c, l) => c.fixedDayPeriod(ts).toNarrow(l));

StatefulToken<Timestamp> b = StatefulToken((ts, c, l) {
    final dp = c.dayPeriod(ts, l);
    if (dp == DayPeriod.Noon || dp == DayPeriod.Midnight) return (dp as DayPeriod).toAbbr();
    else return c.fixedDayPeriod(ts).toAbbr();
});
StatefulToken<Timestamp> bb = b.clone();
StatefulToken<Timestamp> bbb = b.clone();
StatefulToken<Timestamp> bbbb = StatefulToken((ts, c, l) {
    final dp = c.dayPeriod(ts, l);
    if (dp == DayPeriod.Noon || dp == DayPeriod.Midnight) return (dp as DayPeriod).toWide();
    else return c.fixedDayPeriod(ts).toWide();
});
StatefulToken<Timestamp> bbbbb = StatefulToken((ts, c, l) {
    final dp = c.dayPeriod(ts, l);
    if (dp == DayPeriod.Noon || dp == DayPeriod.Midnight) return (dp as DayPeriod).toNarrow();
    else return c.fixedDayPeriod(ts).toNarrow();
});

StatefulToken<Timestamp> B = StatefulToken((ts, c, l) {
    final dp = c.dayPeriod(ts, l);
    return dp != null ? dp.toAbbr() : c.fixedDayPeriod(ts).toAbbr();
});
StatefulToken<Timestamp> BB = B.clone();
StatefulToken<Timestamp> BBB = B.clone();
StatefulToken<Timestamp> BBBB = StatefulToken((ts, c, l) {
    final dp = c.dayPeriod(ts, l);
    return dp != null ? dp.toWide() : c.fixedDayPeriod(ts).toWide();
});
StatefulToken<Timestamp> BBBBB = StatefulToken((ts, c, l) {
    final dp = c.dayPeriod(ts, l);
    return dp != null ? dp.toNarrow() : c.fixedDayPeriod(ts).toNarrow();
});

StatefulToken<Timestamp> H = StatefulToken((ts, __, _) => ts.hour.toString());
StatefulToken<Timestamp> HH = H.withMinLength(2, true);
StatefulToken<Timestamp> K = StatefulToken((ts, __, _) => (ts.hour() % 12).toString());
StatefulToken<Timestamp> KK = K.withMinLength(2, true);

// TODO StatefulToken<Timestamp> h
// TODO StatefulToken<Timestamp> hh
// TODO StatefulToken<Timestamp> k
// TODO StatefulToken<Timestamp> kk

StatefulToken<Timestamp> m = StatefulToken((ts, __, _) => ts.minute.toString());
StatefulToken<Timestamp> mm = m.withMinLength(2, true);
StatefulToken<Timestamp> s = StatefulToken((ts, __, _) => ts.second.toString());
StatefulToken<Timestamp> ss = s.withMinLength(2, true);

StatefulToken<Timestamp> SPlus(int len) => StatefulToken((ts, _, __) {
    final microseconds = Millisecond.microsecondsPer * ts.millisecond() + ts.microsecond();
    return (microseconds / pow(10, len - 6)).truncate().toString();
});

// TODO StatefulToken<Timestamp> A