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

interval = max(config.INTERVAL_HIGH,config.INTERVAL_LOW) # Interval from last take.

GPIO.setmode(GPIO.BCM)
GPIO.setup(sensor, GPIO.IN, GPIO.PUD_DOWN)
current_state = False
cam = picamera.PiCamera()
cam.resolution = (960, 540)  # (1920, 1080)
cam.led = False

# Take a photo and reset the interval.
def take_a_photo():
    fileName = get_file_name()
    cam.led = True
    cam.capture(fileName)
    cam.led = False
    print("A photo taken. %s" % (fileName))
    global interval
    interval = 0

while True:
    time.sleep(1.0)
    current_state = GPIO.input(sensor)
    if current_state:
        print("Something moved.")
        if interval >= config.INTERVAL_HIGH:
            take_a_photo()
    elif interval >= config.INTERVAL_LOW:
        take_a_photo()
    interval += 1
    print("%d" % (interval))
