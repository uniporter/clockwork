import '../../core/interval.dart';
import 'format_token.dart';

StatefulToken<Interval> plus = StatefulToken((i, _, __) => i.sign >= 0 ? '+' : '-');

StatefulToken<Interval> H = StatefulToken((i, __, _) => i.hour.toString(), 'H');
StatefulToken<Interval> HH = H.withMinLength(2, true, 'HH');

StatefulToken<Interval> m = StatefulToken((i, __, _) => i.minute.toString(), 'm');
StatefulToken<Interval> mm = m.withMinLength(2, true, 'mm');

StatefulToken<Interval> s = StatefulToken((i, __, _) => i.second.toString(), 's');
StatefulToken<Interval> ss = m.withMinLength(2, true, 'ss');