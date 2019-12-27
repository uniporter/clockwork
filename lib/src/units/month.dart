import 'package:datex/src/utils/exception.dart';
import 'package:datex/src/utils/system_util.dart';

enum Month {
    skip,
    January,
    February,
    March,
    April,
    May,
    June,
    July,
    August,
    September,
    October,
    November,
    December,
}

extension MonthExtension on Month {
    bool operator <(Month other) => this.index < other.index;
    bool operator <=(Month other) => this.index <= other.index;
    bool operator >(Month other) => this.index > other.index;
    bool operator >=(Month other) => this.index >= other.index;

    Month operator +(Month other) {
        if (other == Month.skip) error(InvalidArgumentException('other'));
        final index = (this.index + other.index) % 12;
        return Month.values[index == Month.skip ? 1 : index];
    }

    Month operator -(Month other) {
        if (other == Month.skip) error(InvalidArgumentException('other'));
        final index = (this.index - other.index) % 12;
        return Month.values[index == Month.skip ? 12 : index];
    }

    /// Returns the month's name in Upper Camel.
    /// Example: January: `January`.
    String toUpperCamel() => this.toString().replaceFirst("${this.runtimeType}.", '');

    /// Returns the first three letters of the month's name in Upper Camel.
    /// Example: January: `Jan`.
    String toAbbr() => this.toUpperCamel().substring(0, 3);
}