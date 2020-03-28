import '../utils/system_util.dart';
import 'hour.dart';
import 'unit.dart';

abstract class Day extends Unit {
    @override final Range<num> range;
    Day(int value, this.range, [num len = double.infinity]): super(value, len);

    static const hoursPer = 24;
    static const minutesPer = hoursPer * Hour.minutesPer;
    static const secondsPer = hoursPer * Hour.secondsPer;
    static const millisecondsPer = hoursPer * Hour.millisecondsPer;
    static const microsecondsPer = hoursPer * Hour.microsecondsPer;

    @override Day operator +(int other) => (super + other) as Day;
    @override Day operator -(int other) => (super - other) as Day;
}