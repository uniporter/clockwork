import '../utils/system_util.dart';
import 'unit.dart';

abstract class Week extends Unit {
    @override final Range<num> range;

    Week(int value, this.range): super(value);

    @override Week operator +(dynamic other) => (super + other) as Week;
    @override Week operator -(dynamic other) => (super - other) as Week;
}