import os
import json
from typing import List, Dict

# Load the day periods rule and makes sure that each locale has a corresponding entry.
def loadDayPeriodsRule(localeNameList: List[str]) -> dict:
    with open("raw/dayPeriods.json") as fp:
        dayPeriods: dict = json.load(fp)["supplemental"]["dayPeriodRuleSet"]
        for locale in localeNameList:
            if locale not in dayPeriods and len([key for key in dayPeriods.keys() if locale.startswith(key)]) == 0:
                dayPeriods[locale] = {}
    return dayPeriods

# Load the week data rules and makes sure that each locale has a corresponding entry.
def loadWeekData(localeNameList: List[str]) -> Dict:
    weekdayToNumMap = {
        "sun": 1,
        "mon": 2,
        "tue": 3,
        "wed": 4,
        "thu": 5,
        "fri": 6,
        "sat": 7
    }

    with open("raw/weekData.json") as fp:
        weekData: Dict[str, dict] = json.load(fp)["supplemental"]["weekData"]
        res: dict = {}
        for locale in localeNameList:
            identifier = locale[-2:]
            res[locale] = {
                "minDaysInWeek": int(weekData['minDays'].get(identifier, weekData['minDays']['001'])),
                "firstDayOfWeek": weekdayToNumMap[weekData['firstDay'].get(identifier, weekData['firstDay']['001'])]
            }

    return res

# Get the list of names of locales.
def localeNameList() -> list:
    return os.listdir('raw/gregorian/')

# Where the data is collected before being serialized to JSON.
data = []
localeNames = localeNameList()
dayPeriodsRule = loadDayPeriodsRule(localeNames)
weekData = loadWeekData(localeNames)

for dir in os.listdir('raw/gregorian/'):
    if dir != 'en':
        continue
    with open(f"raw/gregorian/{dir}/ca-gregorian.json") as fp:
        parsed = json.load(fp)["main"][dir]["dates"]["calendars"]["gregorian"]
        data.append({
            "gregorianCalendar": {
                "months": {k:{a:list(b.values()) for (a, b) in v.items()} for (k, v) in parsed["months"].items()},
                "weekdays": {k:{a:list(b.values()) for (a, b) in v.items()} for (k, v) in parsed["days"].items()},
                "quarters": {k:{a:list(b.values()) for (a, b) in v.items()} for (k, v) in parsed["quarters"].items()},
                "dayPeriods": parsed["dayPeriods"],
                "eras": parsed["eras"]
            },
            "dayPeriodsRules": dayPeriodsRule[next(key for key in dayPeriodsRule.keys() if dir.startswith(key))],
            "weekData": weekData[dir]
        })

with open('res.json', "x") as fp:
    json.dump(data, fp, indent=2)