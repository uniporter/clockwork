import '../utils/system_util.dart';
import 'unit.dart';

class Millisecond extends Unit {
    @override final Range<num> range = const Range<num>(0, 1000);
    @override final Millisecond Function(int value) builder = (val) => Millisecond(val);
    Millisecond(int value) : super(value);

    static const int microsecondsPer = 1000;

    @override Millisecond operator +(dynamic other) => (super + other) as Millisecond;
    @override Millisecond operator -(dynamic other) => (super - other) as Millisecond;
}
