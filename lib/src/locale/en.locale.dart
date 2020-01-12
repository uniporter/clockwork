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
        "stand-alone": {
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
        "stand-alone": {
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
        "stand-alone": {
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
            "am-alt-variant": "am",
            "noon": "noon",
            "pm": "PM",
            "pm-alt-variant": "pm",
            "morning1": "in the morning",
            "afternoon1": "in the afternoon",
            "evening1": "in the evening",
            "night1": "at night"
          },
          "narrow": {
            "midnight": "mi",
            "am": "a",
            "am-alt-variant": "am",
            "noon": "n",
            "pm": "p",
            "pm-alt-variant": "pm",
            "morning1": "in the morning",
            "afternoon1": "in the afternoon",
            "evening1": "in the evening",
            "night1": "at night"
          },
          "wide": {
            "midnight": "midnight",
            "am": "AM",
            "am-alt-variant": "am",
            "noon": "noon",
            "pm": "PM",
            "pm-alt-variant": "pm",
            "morning1": "in the morning",
            "afternoon1": "in the afternoon",
            "evening1": "in the evening",
            "night1": "at night"
          }
        },
        "stand-alone": {
          "abbreviated": {
            "midnight": "midnight",
            "am": "AM",
            "am-alt-variant": "am",
            "noon": "noon",
            "pm": "PM",
            "pm-alt-variant": "pm",
            "morning1": "morning",
            "afternoon1": "afternoon",
            "evening1": "evening",
            "night1": "night"
          },
          "narrow": {
            "midnight": "midnight",
            "am": "AM",
            "am-alt-variant": "am",
            "noon": "noon",
            "pm": "PM",
            "pm-alt-variant": "pm",
            "morning1": "morning",
            "afternoon1": "afternoon",
            "evening1": "evening",
            "night1": "night"
          },
          "wide": {
            "midnight": "midnight",
            "am": "AM",
            "am-alt-variant": "am",
            "noon": "noon",
            "pm": "PM",
            "pm-alt-variant": "pm",
            "morning1": "morning",
            "afternoon1": "afternoon",
            "evening1": "evening",
            "night1": "night"
          }
        }
      },
      "eras": {
        "eraNames": {
          "0": "Before Christ",
          "0-alt-variant": "Before Common Era",
          "1": "Anno Domini",
          "1-alt-variant": "Common Era"
        },
        "eraAbbr": {
          "0": "BC",
          "0-alt-variant": "BCE",
          "1": "AD",
          "1-alt-variant": "CE"
        },
        "eraNarrow": {
          "0": "B",
          "0-alt-variant": "BCE",
          "1": "A",
          "1-alt-variant": "CE"
        }
      }
    },
    "dayPeriodsRules": {
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
    }
  });