#!/usr/bin/env python

import os, time, requests, json
import numpy as np
from envirophat import motion, leds

print("""This example will detect motion using the accelerometer.

Press Ctrl+C to exit.

""")

# For debug use:
SLACK_WEBHOOK = os.environ.get("SLACK_WEBHOOK")
SLACK_THRESH = 30.0

# TODO: implements function to send push notifications to iOS app.
PUSH_THRESH = 30.0

DETECT_THRESH = 0.01
DETECT_INTERVAL = 0.01
DETECT_NUM = 4
DETECT_NOOP = int(0.1 / DETECT_INTERVAL) #  0.1 sec
DATA_MAX = int(60 / DETECT_INTERVAL)  # 60.0 sec
data = [[],[],[]]
last_d = [-1,-1,-1]
started = -1
started_at = None

## TODO: 揺れ終わり後、フーリエ変換を使って、震度を求める
# 気象庁
# https://www.data.jma.go.jp/svd/eqev/data/kyoshin/kaisetsu/calc_sindo.htm
# FFT
# https://momonoki2017.blogspot.com/2018/03/pythonfft-1-fft.html
def strength(data):
    fx = np.abs(np.fft.fft(data[0]))[len(data[0])/2+1:]
    return 1.0

try:
    while True:
        v = motion.accelerometer()
        data[0].append(v.x)
        data[1].append(v.y)
        data[2].append(v.z)
        shaked = False
        for i in range(3):
            data[i] = data[i][-DATA_MAX:]
            if len(data[i]) < DETECT_NUM: continue
            d = sum(data[i][-DETECT_NUM:]) / DETECT_NUM
            if last_d[i] > 0 and abs(d - last_d[i]) > DETECT_THRESH:
                shaked = True
            last_d[i] = d
        if shaked:
            started = DETECT_NOOP
            if started_at == None:
                started_at = time.time()
                print("detected the quake!")
                leds.on()
        time.sleep(DETECT_INTERVAL)
        started -= 1
        if started == 0:
            elapsed = time.time() - started_at
            s = strength(data)
            print("ended! %.2f %.2f" % (elapsed,s))
            started_at = None
            leds.off()
            if SLACK_WEBHOOK and elapsed > SLACK_THRESH:
                requests.post(SLACK_WEBHOOK, data = json.dumps({
                  'text': "An earthquake detected! %.2f %.2f" % (elapsed,s) ,
                }))
except KeyboardInterrupt:
    pass
