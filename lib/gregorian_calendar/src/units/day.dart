import '../../../main/clockwork.dart';

import 'units.dart';

class GregorianDay extends Day {
    @override late final UnitBuilder<GregorianDay> builder;

    GregorianDay(int value, GregorianMonth month, GregorianYear year) : super(value, Range(1, GregorianMonth.daysPer(month, year), false), GregorianMonth.daysPer(month, year)) {
        builder = (value) => GregorianDay(value, month, year);
    }

    static const hoursPer = 60;
    static const minutesPer = hoursPer * Hour.minutesPer;
    static const secondsPer = hoursPer * Hour.secondsPer;
    static const millisecondsPer = hoursPer * Hour.millisecondsPer;
    static const microsecondsPer = hoursPer * Hour.microsecondsPer;

    @override GregorianDay operator +(int other) => (super + other) as GregorianDay;
    @override GregorianDay operator -(int other) => (super - other) as GregorianDay;
}

class GregorianDayOfYear extends Day {
    @override late final UnitBuilder<GregorianDayOfYear> builder;

    GregorianDayOfYear(int value, GregorianYear year): super(value, Range(1, GregorianYear.isLeapYear(year) ? 366 : 365), GregorianYear.isLeapYear(year) ? 366 : 365) {
        builder = (value) => GregorianDayOfYear(value, year);
    }

    @override GregorianDayOfYear operator +(int other) => (super + other) as GregorianDayOfYear;
    @override GregorianDayOfYear operator -(int other) => (super - other) as GregorianDayOfYear;
}