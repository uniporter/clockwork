import '../utils/system_util.dart';
import 'unit.dart';

abstract class Week extends Unit {
    @override final Range<num> range;

    Week(int value, this.range, [num len = double.infinity]) : super(value, len);

    @override Week operator +(int other) => (super + other) as Week;
    @override Week operator -(int other) => (super - other) as Week;
}