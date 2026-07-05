#!/usr/bin/env bash
MS_HEX=(
10017F 100180 100181 100182 100183 100184 100185 100186
100187 100188 100189 10018A 10018B 10018C 10018D 10018E
10018F 100190 100191 100192 100193 100194 100195 100196
100197 100198 100199 10019A 10019B 10019C 10019D 10019E
10019F 1001A0 1001A1 1001A2 1001A3 1001A4 1001A5 1001A6
1001A7 1001A8 1001A9 1001AA
)
I=0
PRAYER="?"
S=0

while true; do
  NOW=$(date +%s)
  if (( NOW - S >= 60 )); then
    PRAYER=$(python3 -c "
import json, urllib.request, datetime
BASE = 'https://api.aladhan.com/v1/timingsByCity'
today = datetime.date.today()
url = f'{BASE}?city=Dubai&country=AE&method=8'
resp = urllib.request.urlopen(url)
timings = json.load(resp)['data']['timings']
now = datetime.datetime.now().strftime('%H:%M')
prayers = [('Fajr',timings['Fajr']),('Dhuhr',timings['Dhuhr']),
           ('Asr',timings['Asr']),('Maghrib',timings['Maghrib']),('Isha',timings['Isha'])]
name, ti = None, None
for n, t in prayers:
    if t >= now:
        name, ti = n, t
        break
if name is None:
    tom_str = (today + datetime.timedelta(days=1)).strftime('%d-%m-%Y')
    url2 = f'{BASE}/{tom_str}?city=Dubai&country=AE&method=8'
    resp2 = urllib.request.urlopen(url2)
    timings2 = json.load(resp2)['data']['timings']
    name, ti = 'Fajr', timings2['Fajr']
print(f'{name} {ti}')
" 2>/dev/null)
    PRAYER=${PRAYER:-?}
    S=$NOW
  fi
  printf "\U${MS_HEX[$I]} $PRAYER\n"
  ((I = (I + 1) % ${#MS_HEX[@]}))
  sleep 0.033
done
