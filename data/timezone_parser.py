import json
from typing import List, Dict, Union

deprecated = ["Australia/ACT", "Australia/LHI", "Australia/North", "Australia/NSW", "Australia/Queensland", "Australia/South", "Australia/Tasmania", "Australia/Victoria", "Australia/West", "Brazil/Acre", "Brazil/DeNoronha", "Brazil/East", "Brazil/West", "Canada/Atlantic", "Canada/Central", "Canada/Eastern", "Canada/Mountain", "Canada/Newfoundland", "Canada/Pacific", "Canada/Saskatchewan", "Canada/Yukon", "CET", "Chile/Continental", "Chile/EasterIsland", "CST6CDT", "Cuba", "EET", "Egypt", "Eire", "EST", "EST5EDT", "Etc/Greenwich", "Etc/UCT", "Etc/Universal", "Etc/Zulu", "GB", "GB-Eire", "GMT+0", "GMT0", "GMT−0", "Greenwich", "Hongkong", "HST", "Iceland", "Iran", "Israel", "Jamaica", "Japan", "Kwajalein", "Libya", "MET", "Mexico/BajaNorte", "Mexico/BajaSur", "Mexico/General", "MST", "MST7MDT", "Navajo", "NZ", "NZ-CHAT", "Poland", "Portugal", "PRC", "PST8PDT", "ROC", "ROK", "Singapore", "Turkey", "UCT", "Universal", "US/Alaska", "US/Aleutian", "US/Arizona", "US/Central", "US/Eastern", "US/East-Indiana", "US/Hawaii", "US/Indiana-Starke", "US/Michigan", "US/Mountain", "US/Pacific", "US/Pacific-New", "US/Samoa", "WET", "W-SU", "Zulu"]

def recursionHelper(val: Dict[str, Dict]) -> List[Dict]:
    if "abbrs" in val:
        return [zoneInfo('', val)]
    else:
        temp = []
        for key, value in val.items():
            l = recursionHelper(value)
            for elem in l:
                elem['name'] = f"{key}{'/' if elem['name'] != '' else ''}{elem['name']}"

            temp.extend(l)

        return temp

def zoneInfo(name: str, data: Dict[str, List[Union[str, int, float]]]):
    info = {
        'name': name,
        'possibleOffsets': [],
        'possibleAbbrs': [],
        'history': [],
    }

    for i, e in enumerate(data['offsets']):
        if e not in info['possibleOffsets']:
            info['possibleOffsets'].append(e)
            info['possibleAbbrs'].append(data['abbrs'][i])


    for i, e in enumerate(data['untils']):
        info['history'].append({
            'until': data['untils'][i],
            'index': info['possibleOffsets'].index(data['offsets'][i]),
            'dst': data['isdsts'] == 1
        })

    return info

def main():
    with open('timezone/source.json') as source:
        srcJson = json.load(source)
        zones = srcJson['zoneData']

        cleanedData = [val for val in recursionHelper(zones) if val['name'] not in deprecated]

        with open('timezone/data.json', 'w') as target:
            data = json.dumps(cleanedData, sort_keys=True, indent=4)
            target.write(data)