import 'package:datex/src/utils/exception.dart';
import 'package:datex/src/utils/system_util.dart';

enum Weekday {
    skip,
    Sunday,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
}

enum WeekdayISO {
    skip,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
    Sunday,
}

extension WeekdayExtension on Weekday {
    operator <(Weekday other) => this.index < other.index;
    operator <=(Weekday other) => this.index <= other.index;
    operator >(Weekday other) => this.index > other.index;
    operator >=(Weekday other) => this.index >= other.index;

    Weekday operator +(Weekday other) {
        if (other == Weekday.skip) error(InvalidArgumentException('other'));
        final index = (this.index + other.index) % 7;
        return Weekday.values[index == Weekday.skip ? 1 : index];
    }

    Weekday operator -(Weekday other) {
        if (other == Weekday.skip) error(InvalidArgumentException('other'));
        final index = (this.index - other.index) % 7;
        return Weekday.values[index == Weekday.skip ? 7 : index];
    }

    /// Returns the name of the weekday in Upper Camel.
    String toUpperCamel() => this.toString().replaceFirst("${this.runtimeType}:", '');
    /// Returns the two-lettered abbreviation of the weekday in Upper Camel.
    String toShortAbbr() => this.toUpperCamel().substring(0, 2);
    /// Returns the three-lettered abbreviation of the weekday in Upper Camel.
    String toAbbr() => this.toUpperCamel().substring(0, 3);
}

extension WeekdayISOExtension on WeekdayISO {
    operator <(WeekdayISO other) => this.index < other.index;
    operator <=(WeekdayISO other) => this.index <= other.index;
    operator >(WeekdayISO other) => this.index > other.index;
    operator >=(WeekdayISO other) => this.index >= other.index;

    WeekdayISO operator +(WeekdayISO other) {
        if (other == WeekdayISO.skip) error(InvalidArgumentException('other'));
        final index = (this.index + other.index) % 7;
        return WeekdayISO.values[index == WeekdayISO.skip ? 1 : index];
    }

    WeekdayISO operator -(WeekdayISO other) {
        if (other == WeekdayISO.skip) error(InvalidArgumentException('other'));
        final index = (this.index - other.index) % 7;
        return WeekdayISO.values[index == WeekdayISO.skip ? 7 : index];
    }

    /// Returns the name of the weekday in Upper Camel.
    String toUpperCamel() => this.toString().replaceFirst("${this.runtimeType}:", '');
    /// Returns the two-lettered abbreviation of the weekday in Upper Camel.
    String toShortAbbr() => this.toUpperCamel().substring(0, 2);
    /// Returns the three-lettered abbreviation of the weekday in Upper Camel.
    String toAbbr() => this.toUpperCamel().substring(0, 3);
}