import '../utils/system_util.dart';
import 'unit.dart';

class Millisecond extends Unit {
    @override final Range<num> range = const Range<num>(0, 1000);
    @override final UnitBuilder<Millisecond> builder = (val) => Millisecond(val);
    Millisecond(int value, [num len = double.infinity]) : super(value, len);

    static const int microsecondsPer = 1000;

    @override Millisecond operator +(int other) => (super + other) as Millisecond;
    @override Millisecond operator -(int other) => (super - other) as Millisecond;
}
