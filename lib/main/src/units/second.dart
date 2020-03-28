import '../utils/system_util.dart';
import 'millisecond.dart';
import 'unit.dart';

class Second extends Unit {
    @override final Range<num> range = const Range<num>(0, 60);
    @override Second Function(int val) builder = (val) => Second(val);
    Second(int value, [num len = double.infinity]) : super(value, len);

    static const millisecondsPer = 1000;
    static const microsecondsPer = millisecondsPer * Millisecond.microsecondsPer;

    @override Second operator +(int other) => (super + other) as Second;
    @override Second operator -(int other) => (super - other) as Second;
}