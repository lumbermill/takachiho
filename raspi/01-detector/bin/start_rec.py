# coding: UTF-8
import RPi.GPIO as GPIO
import picamera
import time,datetime
import os,sys
sys.path.append(os.path.dirname(os.path.abspath(__file__)) + '/../etc')
import config

if os.path.isdir(config.FOLDER_PATH + "/storage/picture") == False:
    os.makedirs(config.FOLDER_PATH + "/storage/picture")

def get_file_name():
    return (datetime.datetime.utcnow() + datetime.timedelta(hours=9)).strftime(config.FOLDER_PATH + "/storage/picture/" + config.PICTURE_NAME)

sensor = 4

created_high = 0
created_low = 0

GPIO.setmode(GPIO.BCM)
GPIO.setup(sensor, GPIO.IN, GPIO.PUD_DOWN)
current_state = False
cam = picamera.PiCamera()

while True:
    time.sleep(1.0)
    current_state = GPIO.input(sensor)
    new_state = "HIGH" if current_state else "LOW"
    print("GPIO pin %s is %s" % (sensor, new_state))
    if current_state:
        created_low = 0
        if created_high == 0:
            cam.led = True
            fileName = get_file_name()
            cam.capture(fileName)
            # cam.led = False
        created_high += 1
        if created_high >= config.INTERVAL_HIGH:
            created_high = 0
        print(created_high)
    else:
        cam.led = False
        created_high = 0
        if created_low == 0:
            cam.led = True
            fileName = get_file_name()
            cam.capture(fileName)
            cam.led = False
        created_low += 1
        if created_low >= config.INTERVAL_LOW:
            created_low = 0
        print(created_low)
