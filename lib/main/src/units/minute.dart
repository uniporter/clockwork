import '../utils/system_util.dart';
import 'second.dart';
import 'unit.dart';

class Minute extends Unit {
    @override final Range<num> range = const Range<num>(0, 60);
    @override final Minute Function(int val) builder = (val) => Minute(val);
    Minute(int value, [num len = double.infinity]) : super(value, len);

    static const secondsPer = 60;
    static const millisecondsPer = secondsPer * Second.millisecondsPer;
    static const microsecondsPer = secondsPer * Second.microsecondsPer;

    @override Minute operator +(int other) => (super + other) as Minute;
    @override Minute operator -(int other) => (super - other) as Minute;
}