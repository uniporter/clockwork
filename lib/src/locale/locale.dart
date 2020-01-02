import 'package:clockwork/src/locale/en.locale.dart';

Locale _locale = en;
/// Set the current [Locale].
set locale(Locale locale) {
    _locale = locale;
}
/// Retrieve the current [Locale].
Locale get locale => _locale;

abstract class LocaleData {
    static const LOCALE_DATA = "Locale Data";
    static final Map<String, dynamic> data = Map();

    static String _dataPath = "";

    static set setDataPath(String dataPath) {
        _dataPath = dataPath;
    }

    static load(String localeName) {

    }
}

class Locale {
    final GregorianCalendarData gregorianCalendar;

    const Locale({
        required this.gregorianCalendar,
    });

    factory Locale.fromJson(Map<String, dynamic> json) => Locale(
        gregorianCalendar: GregorianCalendarData.fromJson(json['gregorianCalendar']),
    );
}

class GregorianCalendarData {
    final PositionClassifier months;
    final PositionClassifier weekdays;
    final PositionClassifier quarters;
    final DayPeriodsPositionClassifier dayPeriods;
    final ErasPropertyLength eras;

    const GregorianCalendarData({
        required this.months,
        required this.weekdays,
        required this.quarters,
        required this.dayPeriods,
        required this.eras,
    });

    factory GregorianCalendarData.fromJson(Map<String, dynamic> json) => GregorianCalendarData(
        months: PositionClassifier.fromJson(json["months"]),
        weekdays: PositionClassifier.fromJson(json["weekdays"]),
        quarters: PositionClassifier.fromJson(json["quarters"]),
        dayPeriods: DayPeriodsPositionClassifier.fromJson(json["dayPeriods"]),
        eras: ErasPropertyLength.fromJson(json["eras"]),
    );

    Map<String, dynamic> toJson() => {
        "months": months.toJson(),
        "weekdays": weekdays.toJson(),
        "quarters": quarters.toJson(),
        "dayPeriods": dayPeriods.toJson(),
        "eras": eras.toJson(),
    };
}

class PositionClassifier {
    final PropertyLength format;
    final PropertyLength standalone;

    const PositionClassifier({
        required this.format,
        required this.standalone,
    });

    factory PositionClassifier.fromJson(Map<String, dynamic> json) => PositionClassifier(
        format: PropertyLength.fromJson(json["format"]),
        standalone: PropertyLength.fromJson(json["stand-alone"]),
    );

    Map<String, dynamic> toJson() => {
        "format": format.toJson(),
        "stand-alone": standalone.toJson(),
    };
}

class DayPeriodsPositionClassifier {
    final DayPeriodsPropertyLength format;
    final DayPeriodsPropertyLength standalone;

    const DayPeriodsPositionClassifier({
        required this.format,
        required this.standalone,
    });

    factory DayPeriodsPositionClassifier.fromJson(Map<String, dynamic> json) => DayPeriodsPositionClassifier(
        format: DayPeriodsPropertyLength.fromJson(json["format"]),
        standalone: DayPeriodsPropertyLength.fromJson(json["stand-alone"]),
    );

    Map<String, dynamic> toJson() => {
        "format": format.toJson(),
        "stand-alone": standalone.toJson(),
    };
}

class DayPeriodsPropertyLength {
    final DayPeriods abbreviated;
    final DayPeriods narrow;
    final DayPeriods wide;

    const DayPeriodsPropertyLength({
        required this.abbreviated,
        required this.narrow,
        required this.wide,
    });

    factory DayPeriodsPropertyLength.fromJson(Map<String, dynamic> json) => DayPeriodsPropertyLength(
        abbreviated: DayPeriods.fromJson(json["abbreviated"]),
        narrow: DayPeriods.fromJson(json["narrow"]),
        wide: DayPeriods.fromJson(json["wide"]),
    );

    Map<String, dynamic> toJson() => {
        "abbreviated": abbreviated.toJson(),
        "narrow": narrow.toJson(),
        "wide": wide.toJson(),
    };
}

class DayPeriods {
    final String? midnight;
    final String am;
    final String? noon;
    final String pm;
    final String? morning1;
    final String? morning2;
    final String? afternoon1;
    final String? evening1;
    final String? night1;
    final String? afternoon2;
    final String? amAlt;
    final String? pmAlt;
    final String? night2;
    final String? evening2;

    const DayPeriods({
        this.midnight,
        required this.am,
        this.noon,
        required this.pm,
        this.morning1,
        this.morning2,
        this.afternoon1,
        this.evening1,
        this.night1,
        this.afternoon2,
        this.amAlt,
        this.pmAlt,
        this.night2,
        this.evening2,
    });

    factory DayPeriods.fromJson(Map<String, dynamic> json) => DayPeriods(
        midnight: json["midnight"],
        am: json["am"],
        noon: json["noon"],
        pm: json["pm"],
        morning1: json["morning1"],
        morning2: json["morning2"],
        afternoon1: json["afternoon1"],
        evening1: json["evening1"],
        night1: json["night1"],
        afternoon2: json["afternoon2"],
        amAlt: json["am-alt-variant"],
        pmAlt: json["pm-alt-variant"],
        night2: json["night2"],
        evening2: json["evening2"],
    );

    Map<String, dynamic> toJson() => {
        "midnight": midnight,
        "am": am,
        "noon": noon,
        "pm": pm,
        "morning1": morning1,
        "morning2": morning2,
        "afternoon1": afternoon1,
        "evening1": evening1,
        "night1": night1,
        "afternoon2": afternoon2,
        "am-alt-variant": amAlt,
        "pm-alt-variant": pmAlt,
        "night2": night2,
        "evening2": evening2,
    };
}

class ErasPropertyLength {
    final Eras name;
    final Eras abbr;
    final Eras narrow;

    const ErasPropertyLength({
        required this.name,
        required this.abbr,
        required this.narrow,
    });

    factory ErasPropertyLength.fromJson(Map<String, dynamic> json) => ErasPropertyLength(
        name: Eras.fromJson(json["eraNames"]),
        abbr: Eras.fromJson(json["eraAbbr"]),
        narrow: Eras.fromJson(json["eraNarrow"]),
    );

    Map<String, dynamic> toJson() => {
        "eraNames": name.toJson(),
        "eraAbbr": abbr.toJson(),
        "eraNarrow": narrow.toJson(),
    };
}

class Eras {
    final String pre;
    final String post;
    final String preAlt;
    final String postAlt;

    const Eras({
        required this.pre,
        required this.post,
        required this.preAlt,
        required this.postAlt,
    });

    factory Eras.fromJson(Map<String, dynamic> json) => Eras(
        pre: json["0"],
        post: json["1"],
        preAlt: json["0-alt-variant"],
        postAlt: json["1-alt-variant"],
    );

    Map<String, dynamic> toJson() => {
        "0": pre,
        "1": post,
        "0-alt-variant": preAlt,
        "1-alt-variant": postAlt,
    };
}

class PropertyLength {
    final List<String> abbreviated;
    final List<String> narrow;
    final List<String> wide;
    final List<String>? short;

    const PropertyLength({
        required this.abbreviated,
        required this.narrow,
        required this.wide,
        this.short,
    });

    factory PropertyLength.fromJson(Map<String, dynamic> json) => PropertyLength(
        abbreviated: List<String>.from(json["abbreviated"], growable: false),
        narrow: List<String>.from(json["narrow"], growable: false),
        wide: List<String>.from(json["wide"], growable: false),
        short: json["short"] == null ? null : List<String>.from(json["short"], growable: false),
    );

    Map<String, dynamic> toJson() => {
        "abbreviated": List<dynamic>.from(abbreviated.map((x) => x), growable: false),
        "narrow": List<dynamic>.from(narrow.map((x) => x), growable: false),
        "wide": List<dynamic>.from(wide.map((x) => x), growable: false),
        "short": short == null ? null : List<dynamic>.from(short?.map((x) => x), growable: false),
    };
}