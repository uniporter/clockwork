import os
import json
from typing import List, Dict, Union
import re

# Load the day periods rule and makes sure that each locale has a corresponding entry.
def loadDayPeriodsRule(localeNameList: List[str]) -> dict:
    with open("locale/raw/dayPeriodsRules.json") as fp:
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

    with open("locale/raw/weekData.json") as fp:
        weekData: Dict[str, dict] = json.load(fp)["supplemental"]["weekData"]
        res: dict = {}
        for locale in localeNameList:
            identifier = locale[-2:]
            res[locale] = {
                "minDaysInWeek": int(weekData['minDays'].get(identifier, weekData['minDays']['001'])),
                "firstDayOfWeek": weekdayToNumMap[weekData['firstDay'].get(identifier, weekData['firstDay']['001'])]
            }

    return res

# Load the format data. The JSON entry under `dates > calendars > gregorian` should be given.
def loadFormatData(data: Dict[str, Union[Dict, str]], localeName: str) -> Dict[str, Dict]:
    dateFmt = data['dateFormats']
    timeFmt = data['timeFormats']
    dateTimeFmt: Dict[str, str] = {key:val for (key, val) in data['dateTimeFormats'].items() if key not in ['availableFormats', 'appendItems', 'intervalFormats']}
    dateTimeFmt = {key:value.replace("{0}", dateFmt[key]).replace("{1}", timeFmt[key]) for (key, value) in dateTimeFmt.items()}
    builtIn: Dict[str, str] = data['dateTimeFormats']['availableFormats']

    builtIn['MMMMWCountOther'] = builtIn.pop('MMMMW-count-other')
    if ("MMMMW-count-zero" in builtIn):
        builtIn['MMMMWCountZero'] = builtIn.pop('MMMMW-count-zero')
    if ("MMMMW-count-one" in builtIn):
        builtIn['MMMMWCountOne'] = builtIn.pop('MMMMW-count-one')
    if ("MMMMW-count-two" in builtIn):
        builtIn['MMMMWCountTwo'] = builtIn.pop('MMMMW-count-two')
    if ("MMMMW-count-few" in builtIn):
        builtIn['MMMMWCountFew'] = builtIn.pop('MMMMW-count-few')
    if ("MMMMW-count-many" in builtIn):
        builtIn['MMMMWCountMany'] = builtIn.pop('MMMMW-count-many')

    builtIn['ywCountOther'] = builtIn.pop('yw-count-other')
    if ("yw-count-zero" in builtIn):
        builtIn['ywCountZero'] = builtIn.pop('yw-count-zero')
    if ("yw-count-one" in builtIn):
        builtIn['ywCountOne'] = builtIn.pop('yw-count-one')
    if ("yw-count-two" in builtIn):
        builtIn['ywCountTwo'] = builtIn.pop('yw-count-two')
    if ("yw-count-few" in builtIn):
        builtIn['ywCountFew'] = builtIn.pop('yw-count-few')
    if ("yw-count-many" in builtIn):
        builtIn['ywCountMany'] = builtIn.pop('yw-count-many')

    if ('Md-alt-variant' in builtIn):
        builtIn['MdAlt'] = builtIn.pop('Md-alt-variant')
    if ('MEd-alt-variant' in builtIn):
        builtIn['MEdAlt'] = builtIn.pop('MEd-alt-variant')
    if ('MMdd-alt-variant' in builtIn):
        builtIn['MMddAlt'] = builtIn.pop('MMdd-alt-variant')
    if ('yM-alt-variant' in builtIn):
        builtIn['yMAlt'] = builtIn.pop('yM-alt-variant')
    if ('yMd-alt-variant' in builtIn):
        builtIn['yMdAlt'] = builtIn.pop('yMd-alt-variant')
    if ('yMEd-alt-variant' in builtIn):
        builtIn['yMEdAlt'] = builtIn.pop('yMEd-alt-variant')

    with open(f"locale/raw/gregorian/{localeName}/timeZoneNames.json") as fp:
        data: Dict[str, str] = json.load(fp)['main'][localeName]['dates']['timeZoneNames']
        patternTemp: str = data['hourFormat'].split(';')[0].lstrip('\u200e')
        timezone = {
            "gmt": re.sub(r"[^\{0\}]+", lambda m: "<" + m.group(0) + ">", data['gmtFormat']).replace('{0}', patternTemp),
            "gmtZero": data['gmtZeroFormat'],
            "region": data['regionFormat'],
            "regionDaylight": data['regionFormat-type-daylight'],
            "regionStandard": data['regionFormat-type-standard'],
        }

    return {
        "date": dateFmt,
        "time": timeFmt,
        "datetime": dateTimeFmt,
        "builtIn": builtIn,
        "timezone": timezone
    }

def loadGregorianCalendarData(json: Dict[str, Dict]):
    eras: Dict[str, Dict[str, str]] = json["eras"]
    eras['name'] = eras.pop('eraNames')
    eras['abbr'] = eras.pop('eraAbbr')
    eras['narrow'] = eras.pop('eraNarrow')
    for key, value in eras.items():
        value["pre"] = value.pop("0")
        value["preAlt"] = value.pop("0-alt-variant")
        value["post"] = value.pop("1")
        value["postAlt"] = value.pop("1-alt-variant")

    dayPeriods = json["dayPeriods"]
    dayPeriods["standalone"] = dayPeriods.pop("stand-alone")
    for key, value in dayPeriods['standalone'].items():
        if 'am-alt-variant' in value:
            dayPeriods['standalone'][key]['amAlt'] = dayPeriods['standalone'][key].pop('am-alt-variant')
        if 'pm-alt-variant' in value:
            dayPeriods['standalone'][key]['pmAlt'] = dayPeriods['standalone'][key].pop('pm-alt-variant')
    for key, value in dayPeriods['format'].items():
        if 'am-alt-variant' in value:
            dayPeriods['format'][key]['amAlt'] = dayPeriods['format'][key].pop('am-alt-variant')
        if 'pm-alt-variant' in value:
            dayPeriods['format'][key]['pmAlt'] = dayPeriods['format'][key].pop('pm-alt-variant')


    months = {k:{a:list(b.values()) for (a, b) in v.items()} for (k, v) in json["months"].items()}
    months['standalone'] = months.pop('stand-alone')

    weekdays = {k:{a:list(b.values()) for (a, b) in v.items()} for (k, v) in json["days"].items()}
    weekdays['standalone'] = weekdays.pop('stand-alone')

    quarters = {k:{a:list(b.values()) for (a, b) in v.items()} for (k, v) in json["quarters"].items()}
    quarters['standalone'] = quarters.pop('stand-alone')

    return {
        "months": months,
        "weekdays": weekdays,
        "quarters": quarters,
        "dayPeriods": dayPeriods,
        "eras": eras,
    }

# Get the list of names of locales.
def localeNameList() -> List[str]:
    return os.listdir('locale/raw/gregorian/')

def main():
    localeNames = localeNameList()
    dayPeriodsRule = loadDayPeriodsRule(localeNames)
    weekData = loadWeekData(localeNames)

    os.mkdir('locale/data')

    for dir in os.listdir('locale/raw/gregorian/'):
        with open(f"locale/raw/gregorian/{dir}/ca-gregorian.json") as fp:
            parsed: Dict[str, Dict] = json.load(fp)["main"][dir]["dates"]["calendars"]["gregorian"]
            finalData = {
                "gregorianCalendar": loadGregorianCalendarData(parsed),
                "dayPeriodsRule": dayPeriodsRule[next(key for key in dayPeriodsRule.keys() if dir.startswith(key))],
                "weekData": weekData[dir],
                "format": loadFormatData(parsed, dir)
            }

            with open(f"locale/data/{dir}.json", 'w') as fpp:
                json.dump(finalData, fpp, indent=2)