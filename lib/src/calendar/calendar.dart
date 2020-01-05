import 'package:clockwork/src/calendar/gregorian.dart';
import 'package:clockwork/src/core/timestamp.dart';

Calendar _currCalendar = GregorianCalendar();
/// Set the default [Calendar].
set currCalendar(Calendar currCalendar) {
    _currCalendar = currCalendar;
}
/// Retrieve the default [Calendar].
get currCalendar => _currCalendar;

Calendar nonNullCalendar(Calendar? calendar) => calendar ?? currCalendar;

abstract class Calendar extends Object {
    final String name = 'abstract';

    const Calendar();

    /// Returns the week year of [ts] with respect to this [Calendar]. If the calendar doesn't support week years,
    /// the Gregorian week year is returned.
    int weekyear(Timestamp ts);

    @override bool operator ==(covariant Calendar other) => this.name == other.name;
}