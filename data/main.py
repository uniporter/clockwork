import requests
import os
import shutil
import zipfile
import io
import json

def timezone_handler():
    print("clockwork: Start fetching timezone data.")
    url = "https://raw.githubusercontent.com/rxaviers/iana-tz-data/master/iana-tz-data.json"

    # Remove old data.
    if os.path.exists('timezone'):
        shutil.rmtree('timezone')

    os.makedirs('timezone')

    with open('timezone/source.json', 'w') as fp:
        fp.write(requests.get(url).text)

    print("clockwork: Raw timezone data loaded. Processing.")

    import timezone_parser
    timezone_parser.main()
    os.remove('timezone/source.json')

    print("clockwork: Timezone data processing is complete.")

def locale_handler():
    print("clockwork: Start fetching locale data.")
    if os.path.exists('locale'):
        shutil.rmtree('locale')
    os.makedirs('locale')

    def calendarData():
        url = "https://github.com/unicode-cldr/cldr-dates-modern/archive/master.zip"
        r = requests.get(url, stream=True)
        z = zipfile.ZipFile(io.BytesIO(r.content))
        z.extractall('locale/raw')
        shutil.move('locale/raw/cldr-dates-modern-master/main', 'locale/raw/gregorian')
        shutil.rmtree('locale/raw/cldr-dates-modern-master')

    def dayPeriodsRuleData():
        url = "https://raw.githubusercontent.com/unicode-cldr/cldr-core/master/supplemental/dayPeriods.json"
        with open('locale/raw/dayPeriodsRules.json', 'w') as fp:
            fp.write(requests.get(url).text)

    def weekData():
        url = "https://raw.githubusercontent.com/unicode-cldr/cldr-core/master/supplemental/weekData.json"
        with open('locale/raw/weekData.json', 'w') as fp:
            fp.write(requests.get(url).text)

    calendarData()
    dayPeriodsRuleData()
    weekData()

    print("clockwork: Raw locale data loaded. Processing.")

    import locale_parser;
    locale_parser.main()

    shutil.rmtree('locale/raw')

    print("clockwork: Locale data processing is complete.")

timezone_handler()
locale_handler()