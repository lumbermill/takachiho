#!/usr/bin/env python

# Based on Pimoroni exsample all.py.

import sys, time
from envirophat import light, weather, motion, analog

INTERVAL = 1 # sec
DRAW_GRAPH = True

def write(line):
    print(line)
    fn = "envirophat-%s.csv" % (time.strftime("%y%m%d"))
    with open(fn, mode='a') as f:
        f.write(line+"\n")

def draw_graph(v):
    i = int(temp)
    sys.stderr.write("\033[92m")
    sys.stderr.write('\r' + ('o' * i) + ' ' * (60-i))
    sys.stderr.write("\033[0m")
    sys.stderr.write(' ' + ('%02d' % (i)))
    sys.stderr.flush()

try:
    while True:
        d = time.strftime("%F")
        t = time.strftime("%T")
        vs = [d,t]
        # Temp,Light,Accelerometer X,Y,Z
        temp = weather.temperature()
        vs += [round(temp,2),light.light()]
        vs += [round(x,2) for x in motion.accelerometer()]
        if DRAW_GRAPH: draw_graph(temp)
        else: write(",".join(map(str,vs)))

        time.sleep(INTERVAL)

except KeyboardInterrupt:
    pass
