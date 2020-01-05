import 'package:clockwork_gregorian_calendar/clockwork_gregorian_calendar.dart';

import 'package:clockwork/src/core/timestamp.dart';
import 'package:clockwork/src/format/tokens/format_token.dart';

StatefulToken<Timestamp, TokenMetadataWithLocale<Timestamp>> G = StatefulToken((ts, [meta]) => ts.era.toAbbr(meta == null ? null : meta.locale));
StatefulToken<Timestamp, TokenMetadataWithLocale<Timestamp>> GG = G.clone();
StatefulToken<Timestamp, TokenMetadataWithLocale<Timestamp>> GGG = G.clone();
StatefulToken<Timestamp, TokenMetadataWithLocale<Timestamp>> GGGG = StatefulToken((ts, [meta]) => ts.era.toName(meta == null ? null : meta.locale));
StatefulToken<Timestamp, TokenMetadataWithLocale<Timestamp>> GGGGG = StatefulToken((ts, [meta]) => ts.era.toNarrow(meta == null ? null : meta.locale));

StatefulToken<Timestamp, DummyTokenMetadata<Timestamp>> y = StatefulToken((ts, [_]) => ts.year.abs().toString());
StatefulToken<Timestamp, DummyTokenMetadata<Timestamp>> yy = StatefulToken((ts, [_]) => (ts.year % 100).abs().toString().padLeft(2, '0'));
StatefulToken<Timestamp, DummyTokenMetadata<Timestamp>> yPlus(int len) => y.withMinLength(len, true);

StatefulToken<Timestamp, TokenMetadataWithCalendar<Timestamp>> Y = StatefulToken((ts, [meta]) => meta == null ? null : meta.calendar.weekyear(ts).abs().toString());
StatefulToken<Timestamp, TokenMetadataWithCalendar<Timestamp>> YY = StatefulToken((ts, [meta]) => (meta == null ? null : meta.calendar.weekyear(ts) % 100)?.abs().toString().padLeft(2, '0'));
StatefulToken<Timestamp, TokenMetadataWithCalendar<Timestamp>> YPlus(int len) => Y.withMinLength(len, true);

