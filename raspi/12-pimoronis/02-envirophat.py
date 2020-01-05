#!/usr/bin/env python

# Based on Pimoroni exsamble all.py.

import sys, time
from envirophat import light, weather, motion, analog

INTERVAL = 1 # sec

def write(line):
    print(line)
    fn = "envirophat-%s.csv" % (time.strftime("%y%m%d"))
    with open(fn, mode='a') as f:
        f.write(line+"\n")

try:
    while True:
        # Temp,Light,Accelerometer X,Y,Z
        vs = [round(weather.temperature(),2),light.light()]
        vs += [round(x,2) for x in motion.accelerometer()]
        write(",".join(map(str,vs)))

        time.sleep(INTERVAL)

except KeyboardInterrupt:
    pass
