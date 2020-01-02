import os
import json

j = []

for dir in os.listdir():
    if dir != 'en':
        continue
    with open(dir + '/ca-gregorian.json') as fp:
        parsed = json.load(fp)["main"][dir]["dates"]["calendars"]["gregorian"]
        j.append({
            "months": {k:{a:list(b.values()) for (a, b) in v.items()} for (k, v) in parsed["months"].items()},
            "weekdays": {k:{a:list(b.values()) for (a, b) in v.items()} for (k, v) in parsed["days"].items()},
            "quarters": {k:{a:list(b.values()) for (a, b) in v.items()} for (k, v) in parsed["quarters"].items()},
            "dayPeriods": parsed["dayPeriods"],
            "eras": parsed["eras"]
        })

with open('res.json', "x") as fp:
    json.dump(j, fp)

