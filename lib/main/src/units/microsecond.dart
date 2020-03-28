import '../utils/system_util.dart';
import 'unit.dart';

class Microsecond extends Unit {
    @override final Range<num> range = const Range<num>(0, 1000);
    @override final UnitBuilder<Microsecond> builder = (val) => Microsecond(val);
    Microsecond(int value, [num len = double.infinity]) : super(value, len);

    @override Microsecond operator +(int other) => (super + other) as Microsecond;
    @override Microsecond operator -(int other) => (super - other) as Microsecond;
}