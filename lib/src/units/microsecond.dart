import '../utils/system_util.dart';
import 'unit.dart';

class Microsecond extends Unit {
    @override final Range<num> range = const Range<num>(0, 1000);
    @override final UnitBuilder<Microsecond> builder = (val) => Microsecond(val);
    Microsecond(int value) : super(value);

    @override Microsecond operator +(dynamic other) => (super + other) as Microsecond;
    @override Microsecond operator -(dynamic other) => (super - other) as Microsecond;
}