#!/usr/bin/env python

# Based on Pimoroni exsample all.py.

import argparse, sys, time
from envirophat import light, weather, motion, analog

INTERVAL = 1 # sec

def write(line):
    print(line)
    fn = "envirophat-%s.csv" % (time.strftime("%y%m%d"))
    with open(fn, mode='a') as f:
        f.write(line+"\n")

def draw_graph(v,max_v):
    w = 60
    i = int(v * (w / max_v))
    sys.stderr.write("\033[92m")
    sys.stderr.write('\r' + ('o' * i) + ' ' * (60-i))
    sys.stderr.write("\033[0m")
    sys.stderr.write(' ' + ('%04d' % (v)))
    sys.stderr.flush()

parser = argparse.ArgumentParser(description='Envorophat interface')
parser.add_argument('-g','--graph',action='store_true',help='Show graph')
args = parser.parse_args()

try:
    while True:
        d = time.strftime("%F")
        t = time.strftime("%T")
        vs = [d,t]
        # Temp,Light,Accelerometer X,Y,Z
        temp = weather.temperature()
        ligh = light.light()
        vs += [round(temp,2),ligh]
        vs += [round(x,2) for x in motion.accelerometer()]
        if args.graph: draw_graph(ligh,5000)
        else: write(",".join(map(str,vs)))

        time.sleep(INTERVAL)

except KeyboardInterrupt:
    pass
