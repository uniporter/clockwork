import json

with open('source.json') as source:
    srcJson = json.load(source)
    zones = srcJson['zones']
    cleanedData = []
    for zone in zones:
        zoneInfo = {
            'name': zone['name'],
            'offsets': [],
            'abbrs': [],
            'info': []
        }

        for i, e in enumerate(zone['offsets']):
            if e not in zoneInfo['offsets']:
                zoneInfo['offsets'].append(e)
                zoneInfo['abbrs'].append(zone['abbrs'][i])


        for i, e in enumerate(zone['untils']):
            zoneInfo['info'].append({
                'until': zone['untils'][i],
                'index': zoneInfo['offsets'].index(zone['offsets'][i])
            })

        cleanedData.append(zoneInfo)

    with open('data_2019c.json', 'w') as target:
        data = json.dumps(cleanedData, sort_keys=True)
        target.write(data)