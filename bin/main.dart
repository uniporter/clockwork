import 'package:datex/datex.dart';

main() async {
    await TimeZoneData.initialize('data/data_2019c.json', local: 'Asia/Hong_Kong');
    final a = Timestamp.explicit(TimeZone.local(), 1970, 1, 1, 14, 30);
    print(a.weekday);
}