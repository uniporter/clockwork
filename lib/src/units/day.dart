import '../utils/system_util.dart';
import 'hour.dart';
import 'unit.dart';

abstract class Day extends Unit {
    @override final Range<num> range;
    Day(int value, this.range): super(value);

    static const hoursPer = 24;
    static const minutesPer = hoursPer * Hour.minutesPer;
    static const secondsPer = hoursPer * Hour.secondsPer;
    static const millisecondsPer = hoursPer * Hour.millisecondsPer;
    static const microsecondsPer = hoursPer * Hour.microsecondsPer;

    @override Day operator +(dynamic other) => (super + other) as Day;
    @override Day operator -(dynamic other) => (super - other) as Day;
}