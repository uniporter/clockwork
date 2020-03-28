import '../calendar/calendar.dart';
import '../core/timestamp.dart';
import '../locale/locale.dart';
import '../utils/exception.dart';
import 'formattable.dart';
import 'parser.dart';
import 'tokens/format_token.dart';

/// Describes a [Format] for a particular [Formattable] object.
class Format<F extends Formattable> {
    final List<StatefulToken<F>> tokens;

    const Format(this.tokens);

    /// Returns a [Format] based on [pattern] and the selected [parser]. If no [Parser] is provided, the [DefaultParser] is used.
    factory Format.parse(String? pattern, [Parser? parser]) {
        if (pattern == null) throw InvalidArgumentException("pattern", "pattern shouldn't be null");
        return parser?.parse<F>(pattern) ?? DefaultParser().parse<F>(pattern);
    }

    /// Returns a [Format] by concatenating the [Format]s in [it].
    Format.concat(Iterable<Format<F>> it) : tokens = [for (var format in it) ...format.tokens];

    /// Format [f] with optionally provided [locale] and [calendar]. If not provided we use the default data, i.e. [currLocale] and [currCalendar].
    String format(F f, [Locale? locale, Calendar? calendar]) {
        /// We purify all tokens before using them to format [f].
        final pureTokens = tokens.map((token) => (F f) => token(f, nonNullCalendar(calendar), nonNullLocale(locale)));
        return pureTokens.map((token) => (token as PureToken<F>)(f)).join();
    }
}

/// Namespace for default [Format]s for [Timestamp].
abstract class TimestampFormats {
    static Format<Timestamp> DateFull([Locale? locale]) => Format.parse(nonNullLocale(locale).format.date.full);
    static Format<Timestamp> DateMedium([Locale? locale]) => Format.parse(nonNullLocale(locale).format.date.medium);
    static Format<Timestamp> DateLong([Locale? locale]) => Format.parse(nonNullLocale(locale).format.date.long);
    static Format<Timestamp> DateShort([Locale? locale]) => Format.parse(nonNullLocale(locale).format.date.short);
    static Format<Timestamp> TimeFull([Locale? locale]) => Format.parse(nonNullLocale(locale).format.time.full);
    static Format<Timestamp> TimeMedium([Locale? locale]) => Format.parse(nonNullLocale(locale).format.time.medium);
    static Format<Timestamp> TimeLong([Locale? locale]) => Format.parse(nonNullLocale(locale).format.time.long);
    static Format<Timestamp> TimeShort([Locale? locale]) => Format.parse(nonNullLocale(locale).format.time.short);
    static Format<Timestamp> DateTimeFull([Locale? locale]) => Format.parse(nonNullLocale(locale).format.datetime.full);
    static Format<Timestamp> DateTimeMedium([Locale? locale]) => Format.parse(nonNullLocale(locale).format.datetime.medium);
    static Format<Timestamp> DateTimeLong([Locale? locale]) => Format.parse(nonNullLocale(locale).format.datetime.long);
    static Format<Timestamp> DateTimeShort([Locale? locale]) => Format.parse(nonNullLocale(locale).format.datetime.short);

    static Format<Timestamp> Bh([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.Bh);
    static Format<Timestamp> Bhm([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.Bhm);
    static Format<Timestamp> Bhms([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.Bhms);
    static Format<Timestamp> d([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.d);
    static Format<Timestamp> E([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.E);
    static Format<Timestamp> EBhm([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.EBhm);
    static Format<Timestamp> EBhms([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.EBhms);
    static Format<Timestamp> Ed([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.Ed);
    static Format<Timestamp> Ehm([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.Ehm);
    static Format<Timestamp> EHm([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.EHm);
    static Format<Timestamp> Ehms([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.Ehms);
    static Format<Timestamp> EHms([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.EHms);
    static Format<Timestamp> Gy([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.Gy);
    static Format<Timestamp> GyM([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.GyM);
    static Format<Timestamp> GyMMM([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.GyMMM);
    static Format<Timestamp> GyMMMd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.GyMMMd);
    static Format<Timestamp> GyMMMEd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.GyMMMEd);
    static Format<Timestamp> h([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.h);
    static Format<Timestamp> H([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.H);
    static Format<Timestamp> hm([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.hm);
    static Format<Timestamp> Hm([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.Hm);
    static Format<Timestamp> hms([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.hms);
    static Format<Timestamp> Hms([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.Hms);
    static Format<Timestamp> hmsv([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.hmsv);
    static Format<Timestamp> Hmsv([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.Hmsv);
    static Format<Timestamp> hmv([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.hmv);
    static Format<Timestamp> Hmv([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.Hmv);
    static Format<Timestamp> M([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.M);
    static Format<Timestamp> Md([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.Md);
    static Format<Timestamp> MEd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MEd);
    static Format<Timestamp> MMM([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMM);
    static Format<Timestamp> MMMd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMMd);
    static Format<Timestamp> MMMEd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMMEd);
    static Format<Timestamp> MMMMd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMMMd);
    static Format<Timestamp> MMMMWCountOne([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMMMWCountOne);
    static Format<Timestamp> MMMMWCountTwo([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMMMWCountTwo);
    static Format<Timestamp> MMMMWCountFew([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMMMWCountFew);
    static Format<Timestamp> MMMMWCountOther([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMMMWCountOther);
    static Format<Timestamp> ms([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.ms);
    static Format<Timestamp> y([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.y);
    static Format<Timestamp> yM([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yM);
    static Format<Timestamp> yMd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMd);
    static Format<Timestamp> yMEd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMEd);
    static Format<Timestamp> yMMM([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMMM);
    static Format<Timestamp> yMMMd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMMMd);
    static Format<Timestamp> yMMMEd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMMMEd);
    static Format<Timestamp> yMMMM([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMMMM);
    static Format<Timestamp> yQQQ([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yQQQ);
    static Format<Timestamp> yQQQQ([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yQQQQ);
    static Format<Timestamp> ywCountOne([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.ywCountOne);
    static Format<Timestamp> ywCountTwo([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.ywCountTwo);
    static Format<Timestamp> ywCountFew([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.ywCountFew);
    static Format<Timestamp> ywCountOther([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.ywCountOther);
    static Format<Timestamp> GyMMMMd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.GyMMMMd);
    static Format<Timestamp> MMMMEd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMMMEd);
    static Format<Timestamp> MMMMWCountMany([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMMMWCountMany);
    static Format<Timestamp> mmss([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.mmss);
    static Format<Timestamp> yMMMMd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMMMMd);
    static Format<Timestamp> ywCountMany([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.ywCountMany);
    static Format<Timestamp> MMdd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMdd);
    static Format<Timestamp> yMM([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMM);
    static Format<Timestamp> HHmmZ([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.HHmmZ);
    static Format<Timestamp> yMMMMEEEEd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMMMMEEEEd);
    static Format<Timestamp> MMd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMd);
    static Format<Timestamp> yMMdd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMMdd);
    static Format<Timestamp> GyMMMM([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.GyMMMM);
    static Format<Timestamp> GyMMMMEd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.GyMMMMEd);
    static Format<Timestamp> yMMMMEd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMMMMEd);
    static Format<Timestamp> MMMMWCountZero([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMMMWCountZero);
    static Format<Timestamp> ywCountZero([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.ywCountZero);
    static Format<Timestamp> hmsvvvv([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.hmsvvvv);
    static Format<Timestamp> Hmsvvvv([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.Hmsvvvv);
    static Format<Timestamp> yMMMEEEEd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMMMEEEEd);
    static Format<Timestamp> EEEEd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.EEEEd);
    static Format<Timestamp> GyMMMEEEEd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.GyMMMEEEEd);
    static Format<Timestamp> HHmmss([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.HHmmss);
    static Format<Timestamp> MEEEEd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MEEEEd);
    static Format<Timestamp> MMMEEEEd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMMEEEEd);
    static Format<Timestamp> yMEEEEd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMEEEEd);
    static Format<Timestamp> MMMdd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMMdd);
    static Format<Timestamp> MMMMdd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMMMdd);
    static Format<Timestamp> MdAlt([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MdAlt);
    static Format<Timestamp> MEdAlt([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MEdAlt);
    static Format<Timestamp> MMddAlt([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMddAlt);
    static Format<Timestamp> yMAlt([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMAlt);
    static Format<Timestamp> yMdAlt([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMdAlt);
    static Format<Timestamp> yMEdAlt([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMEdAlt);
    static Format<Timestamp> Mdd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.Mdd);
    static Format<Timestamp> MMMM([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMMM);
    static Format<Timestamp> yMMMMccccd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yMMMMccccd);
    static Format<Timestamp> yQ([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.yQ);
    static Format<Timestamp> HHmm([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.HHmm);
    static Format<Timestamp> MMMMEEEEd([Locale? locale]) => Format.parse(nonNullLocale(locale).format.builtIn.MMMMEEEEd);
}