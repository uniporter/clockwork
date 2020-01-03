import os
import json

defaultDayPeriodsRule = {
    "am": {
        "_from": "00:00",
        "_before": "12:00"
    },
    "pm": {
        "_from": "12:00",
        "_before": "24:00",
    },
}

# Load the day periods rule and makes sure that each locale has a corresponding entry.
def loadDayPeriodsRule(localeNameList: list) -> dict:
    with open("raw/dayPeriods.json") as fp:
        dayPeriods: dict = json.load(fp)["supplemental"]["dayPeriodRuleSet"]
        for locale in localeNameList:
            if locale not in dayPeriods and len([key for key in dayPeriods.keys() if locale.startswith(key)]) == 0:
                dayPeriods[locale] = {}
    return dayPeriods

# Get the list of names of locales.
def localeNameList() -> list:
    return os.listdir('raw/dates/')

# Where the data is collected before being serialized to JSON.
data = []
localeNames = localeNameList()
dayPeriodsRule = loadDayPeriodsRule(localeNames)

for dir in os.listdir('raw/dates/'):
    if dir == 'en':
        continue
    with open(f"raw/dates/{dir}/ca-gregorian.json") as fp:
        parsed = json.load(fp)["main"][dir]["dates"]["calendars"]["gregorian"]
        data.append({
            "gregorianCalendar": {
                "months": {k:{a:list(b.values()) for (a, b) in v.items()} for (k, v) in parsed["months"].items()},
                "weekdays": {k:{a:list(b.values()) for (a, b) in v.items()} for (k, v) in parsed["days"].items()},
                "quarters": {k:{a:list(b.values()) for (a, b) in v.items()} for (k, v) in parsed["quarters"].items()},
                "dayPeriods": parsed["dayPeriods"],
                "eras": parsed["eras"]
            },
            "dayPeriodsRules": {
                **dayPeriodsRule[next(key for key in dayPeriodsRule.keys() if dir.startswith(key))],
                **defaultDayPeriodsRule,
            },
        })

with open('res.json', "x") as fp:
    json.dump(data, fp, indent=2)