import 'locale.dart';

/// Locale for `en`. Default locale of the package.
final Locale en = Locale.fromJson(
{
  "gregorianCalendar": {
    "months": {
      "format": {
        "abbreviated": [
          "Jan",
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec"
        ],
        "narrow": [
          "J",
          "F",
          "M",
          "A",
          "M",
          "J",
          "J",
          "A",
          "S",
          "O",
          "N",
          "D"
        ],
        "wide": [
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
          "August",
          "September",
          "October",
          "November",
          "December"
        ]
      },
      "standalone": {
        "abbreviated": [
          "Jan",
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec"
        ],
        "narrow": [
          "J",
          "F",
          "M",
          "A",
          "M",
          "J",
          "J",
          "A",
          "S",
          "O",
          "N",
          "D"
        ],
        "wide": [
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
          "August",
          "September",
          "October",
          "November",
          "December"
        ]
      }
    },
    "weekdays": {
      "format": {
        "abbreviated": [
          "Sun",
          "Mon",
          "Tue",
          "Wed",
          "Thu",
          "Fri",
          "Sat"
        ],
        "narrow": [
          "S",
          "M",
          "T",
          "W",
          "T",
          "F",
          "S"
        ],
        "short": [
          "Su",
          "Mo",
          "Tu",
          "We",
          "Th",
          "Fr",
          "Sa"
        ],
        "wide": [
          "Sunday",
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday",
          "Friday",
          "Saturday"
        ]
      },
      "standalone": {
        "abbreviated": [
          "Sun",
          "Mon",
          "Tue",
          "Wed",
          "Thu",
          "Fri",
          "Sat"
        ],
        "narrow": [
          "S",
          "M",
          "T",
          "W",
          "T",
          "F",
          "S"
        ],
        "short": [
          "Su",
          "Mo",
          "Tu",
          "We",
          "Th",
          "Fr",
          "Sa"
        ],
        "wide": [
          "Sunday",
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday",
          "Friday",
          "Saturday"
        ]
      }
    },
    "quarters": {
      "format": {
        "abbreviated": [
          "Q1",
          "Q2",
          "Q3",
          "Q4"
        ],
        "narrow": [
          "1",
          "2",
          "3",
          "4"
        ],
        "wide": [
          "1st quarter",
          "2nd quarter",
          "3rd quarter",
          "4th quarter"
        ]
      },
      "standalone": {
        "abbreviated": [
          "Q1",
          "Q2",
          "Q3",
          "Q4"
        ],
        "narrow": [
          "1",
          "2",
          "3",
          "4"
        ],
        "wide": [
          "1st quarter",
          "2nd quarter",
          "3rd quarter",
          "4th quarter"
        ]
      }
    },
    "dayPeriods": {
      "format": {
        "abbreviated": {
          "midnight": "midnight",
          "am": "AM",
          "noon": "noon",
          "pm": "PM",
          "morning1": "in the morning",
          "afternoon1": "in the afternoon",
          "evening1": "in the evening",
          "night1": "at night",
          "amAlt": "am",
          "pmAlt": "pm"
        },
        "narrow": {
          "midnight": "mi",
          "am": "a",
          "noon": "n",
          "pm": "p",
          "morning1": "in the morning",
          "afternoon1": "in the afternoon",
          "evening1": "in the evening",
          "night1": "at night",
          "amAlt": "am",
          "pmAlt": "pm"
        },
        "wide": {
          "midnight": "midnight",
          "am": "AM",
          "noon": "noon",
          "pm": "PM",
          "morning1": "in the morning",
          "afternoon1": "in the afternoon",
          "evening1": "in the evening",
          "night1": "at night",
          "amAlt": "am",
          "pmAlt": "pm"
        }
      },
      "standalone": {
        "abbreviated": {
          "midnight": "midnight",
          "am": "AM",
          "noon": "noon",
          "pm": "PM",
          "morning1": "morning",
          "afternoon1": "afternoon",
          "evening1": "evening",
          "night1": "night",
          "amAlt": "am",
          "pmAlt": "pm"
        },
        "narrow": {
          "midnight": "midnight",
          "am": "AM",
          "noon": "noon",
          "pm": "PM",
          "morning1": "morning",
          "afternoon1": "afternoon",
          "evening1": "evening",
          "night1": "night",
          "amAlt": "am",
          "pmAlt": "pm"
        },
        "wide": {
          "midnight": "midnight",
          "am": "AM",
          "noon": "noon",
          "pm": "PM",
          "morning1": "morning",
          "afternoon1": "afternoon",
          "evening1": "evening",
          "night1": "night",
          "amAlt": "am",
          "pmAlt": "pm"
        }
      }
    },
    "eras": {
      "name": {
        "pre": "Before Christ",
        "preAlt": "Before Common Era",
        "post": "Anno Domini",
        "postAlt": "Common Era"
      },
      "abbr": {
        "pre": "BC",
        "preAlt": "BCE",
        "post": "AD",
        "postAlt": "CE"
      },
      "narrow": {
        "pre": "B",
        "preAlt": "BCE",
        "post": "A",
        "postAlt": "CE"
      }
    }
  },
  "dayPeriodsRule": {
    "afternoon1": {
      "_before": "18:00",
      "_from": "12:00"
    },
    "evening1": {
      "_before": "21:00",
      "_from": "18:00"
    },
    "midnight": {
      "_at": "00:00"
    },
    "morning1": {
      "_before": "12:00",
      "_from": "06:00"
    },
    "night1": {
      "_before": "06:00",
      "_from": "21:00"
    },
    "noon": {
      "_at": "12:00"
    }
  },
  "weekData": {
    "minDaysInWeek": 1,
    "firstDayOfWeek": 2
  },
  "format": {
    "date": {
      "full": "EEEE, MMMM d, y",
      "long": "MMMM d, y",
      "medium": "MMM d, y",
      "short": "M/d/yy"
    },
    "time": {
      "full": "h:mm:ss a zzzz",
      "long": "h:mm:ss a z",
      "medium": "h:mm:ss a",
      "short": "h:mm a"
    },
    "datetime": {
      "full": "h:mm:ss a zzzz 'at' EEEE, MMMM d, y",
      "long": "h:mm:ss a z 'at' MMMM d, y",
      "medium": "h:mm:ss a, MMM d, y",
      "short": "h:mm a, M/d/yy"
    },
    "builtIn": {
      "Bh": "h B",
      "Bhm": "h:mm B",
      "Bhms": "h:mm:ss B",
      "d": "d",
      "E": "ccc",
      "EBhm": "E h:mm B",
      "EBhms": "E h:mm:ss B",
      "Ed": "d E",
      "Ehm": "E h:mm a",
      "EHm": "E HH:mm",
      "Ehms": "E h:mm:ss a",
      "EHms": "E HH:mm:ss",
      "Gy": "y G",
      "GyMMM": "MMM y G",
      "GyMMMd": "MMM d, y G",
      "GyMMMEd": "E, MMM d, y G",
      "h": "h a",
      "H": "HH",
      "hm": "h:mm a",
      "Hm": "HH:mm",
      "hms": "h:mm:ss a",
      "Hms": "HH:mm:ss",
      "hmsv": "h:mm:ss a v",
      "Hmsv": "HH:mm:ss v",
      "hmv": "h:mm a v",
      "Hmv": "HH:mm v",
      "M": "L",
      "Md": "M/d",
      "MEd": "E, M/d",
      "MMM": "LLL",
      "MMMd": "MMM d",
      "MMMEd": "E, MMM d",
      "MMMMd": "MMMM d",
      "ms": "mm:ss",
      "y": "y",
      "yM": "M/y",
      "yMd": "M/d/y",
      "yMEd": "E, M/d/y",
      "yMMM": "MMM y",
      "yMMMd": "MMM d, y",
      "yMMMEd": "E, MMM d, y",
      "yMMMM": "MMMM y",
      "yQQQ": "QQQ y",
      "yQQQQ": "QQQQ y",
      "MMMMWCountOther": "'week' W 'of' MMMM",
      "MMMMWCountOne": "'week' W 'of' MMMM",
      "ywCountOther": "'week' w 'of' Y",
      "ywCountOne": "'week' w 'of' Y"
    },
    "timezone": {
      "gmt": "<GMT>+HH:mm",
      "gmtZero": "GMT",
      "region": "{0} Time",
      "regionDaylight": "{0} Daylight Time",
      "regionStandard": "{0} Standard Time"
    }
  }
});