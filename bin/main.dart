import 'package:datex/datex.dart';

main() async {
    await TimeZoneData.initialize('data/data_2019c.json', local: 'Asia/Hong_Kong');
    final a = Timestamp.explicit(TimeZone.local(), 2019, 12, 26, 14, 30);
    print(a.weekday);
}