#!/usr/bin/env python3
import json, urllib.request, datetime, time, sys

BASE = 'https://api.aladhan.com/v1/timingsByCity'

def fetch(date=None):
    url = f'{BASE}?city=Dubai&country=AE&method=8'
    if date:
        url = f'{BASE}/{date}?city=Dubai&country=AE&method=8'
    resp = urllib.request.urlopen(url)
    return json.load(resp)['data']['timings']

def next_prayer(timings, now_str):
    prayers = [('Fajr',timings['Fajr']),('Dhuhr',timings['Dhuhr']),
               ('Asr',timings['Asr']),('Maghrib',timings['Maghrib']),('Isha',timings['Isha'])]
    for n,ti in prayers:
        if ti >= now_str:
            return n, ti
    return None, None

timings = fetch()
last_date = datetime.date.today()

while True:
    today = datetime.date.today()
    if today != last_date:
        timings = fetch()
        last_date = today
    now = datetime.datetime.now().strftime('%H:%M')
    name, time_str = next_prayer(timings, now)
    if name is None:
        # All today's prayers passed — fetch next day's Fajr
        tom_str = (today + datetime.timedelta(days=1)).strftime('%d-%m-%Y')
        next_timings = fetch(tom_str)
        name, time_str = 'Fajr', next_timings['Fajr']
        last_date = today
    print(f'\ufda6 {name} {time_str}')
    sys.stdout.flush()
    time.sleep(60)
