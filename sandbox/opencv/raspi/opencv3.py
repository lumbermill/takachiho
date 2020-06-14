import time
import picamera
import picamera.array
import cv2
import numpy as np

DEBUG = False

low = np.array([160,128,128])
high = np.array([200,255,255])

camera = picamera.PiCamera()
camera.resolution = (640,480)
camera.vflip = True
camera.hflip = True
camera.start_preview()
time.sleep(1)
camera.stop_preview()
      
      
def get_target():
  global camera
  stream = picamera.array.PiRGBArray(camera)
  camera.capture(stream, format='bgr')
  image = stream.array
  hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
  mask = cv2.inRange(hsv, low, high)
  _,contours,_ = cv2.findContours(mask,cv2.RETR_LIST,cv2.CHAIN_APPROX_SIMPLE)
  cx, cy, max_a = -1,-1,0
  for i in range(0,len(contours)):
    if len(contours[i]) == 0: continue
    x,y,w,h = cv2.boundingRect(contours[i])
    a = cv2.contourArea(contours[i])
    if a < 1000: continue
    print("x: %d,y: %d,a: %d" % (x,y,a))
    if a > max_a:
      cx = x + w/2
      cy = y + h/2
      max_a = a
  if DEBUG:
    cv2.imshow("image",image)
    cv2.imshow("debug",mask)
    cv2.waitKey(0)
  return (cx,cy)

w = camera.resolution[0]

while True:
  x,y = get_target()
  p = x/w if x > -1 else -1 # 0.0 - 1.0 or -1(not found)
  print("%.1f" % (p))
  time.sleep(0.1)
