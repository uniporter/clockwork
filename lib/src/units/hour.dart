import '../utils/system_util.dart';
import 'minute.dart';
import 'unit.dart';

class Hour extends Unit {
    @override final Range<num> range = const Range<num>(0, 60);
    @override final UnitBuilder<Hour> builder = (val) => Hour(val);
    Hour(int value) : super(value);

    static const minutesPer = 60;
    static const secondsPer = minutesPer * Minute.secondsPer;
    static const millisecondsPer = minutesPer * Minute.millisecondsPer;
    static const microsecondsPer = minutesPer * Minute.microsecondsPer;

    @override Hour operator +(dynamic other) => (super + other) as Hour;
    @override Hour operator -(dynamic other) => (super - other) as Hour;
}