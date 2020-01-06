import '../../core/timestamp.dart' show Timestamp;
import '../../units/unit.dart' show CyclicYear;
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

StatefulToken<Timestamp> m = M.clone();
StatefulToken<Timestamp> mm = MM.clone();
StatefulToken<Timestamp> mmm = StatefulToken((ts, c, l) => c.month(ts).toAbbrStandalone(l));
StatefulToken<Timestamp> mmmm = StatefulToken((ts, c, l) => c.month(ts).toWideStandalone(l));
StatefulToken<Timestamp> mmmmm = StatefulToken((ts, c, l) => c.month(ts).toNarrowStandalone(l));

