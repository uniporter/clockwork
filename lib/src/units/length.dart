enum Length {
    MICROSECOND, MILLISECOND, SECOND, MINUTE, HOUR, DAY, MONTH, YEAR
}

extension LengthExtension on Length {
    operator <(Length other) => this.index < other.index;
    operator <=(Length other) => this.index <= other.index;
    operator >(Length other) => this.index > other.index;
    operator >=(Length other) => this.index >= other.index;
}