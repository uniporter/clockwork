import '../../../main/clockwork.dart';

class GregorianYearOfEra extends Year {
    @override final UnitBuilder<GregorianYearOfEra> builder = (value) => GregorianYearOfEra(value);

    final range = Range(1, double.infinity);

    GregorianYearOfEra(int value): super(value);

    @override GregorianYearOfEra operator +(int other) => (super + other) as GregorianYearOfEra;
    @override GregorianYearOfEra operator -(int other) => (super - other) as GregorianYearOfEra;
}