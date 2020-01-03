abstract class Calendar extends Object {
    final String name = 'abstract';
    
    const Calendar();

    @override bool operator ==(covariant Calendar other) => this.name == other.name;
}