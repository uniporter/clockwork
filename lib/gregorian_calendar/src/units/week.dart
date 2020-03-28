import '../../../main/clockwork.dart';

import 'units.dart';

class GregorianWeekOfYear extends Week {
    @override late final UnitBuilder<GregorianWeekOfYear> builder;

    GregorianWeekOfYear(int value, GregorianYear year): super(value, Range(1, GregorianYear.weeksPer(year)), GregorianYear.weeksPer(year)) {
        builder = (value) => GregorianWeekOfYear(value, year);
    }

    @override GregorianWeekOfYear operator +(int other) => (super + other) as GregorianWeekOfYear;
    @override GregorianWeekOfYear operator -(int other) => (super - other) as GregorianWeekOfYear;
}

class GregorianWeekOfMonth extends Week {
    @override late final UnitBuilder<GregorianWeekOfMonth> builder;

    GregorianWeekOfMonth(int value, GregorianMonth month, GregorianYear year): super(value, const Range(1, 6), 5) {
        builder = (value) => GregorianWeekOfMonth(value, month, year);
    }

    @override GregorianWeekOfMonth operator +(int other) => (super + other) as GregorianWeekOfMonth;
    @override GregorianWeekOfMonth operator -(int other) => (super - other) as GregorianWeekOfMonth;
}